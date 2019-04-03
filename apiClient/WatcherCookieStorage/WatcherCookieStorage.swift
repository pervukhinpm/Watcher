//
//  WatcherCookieStorage.swift
//  apiClient
//
//  Created by Петр Первухин on 22/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

open class WatcherCookieStorage: HTTPCookieStorage {
    
    // MARK: - Properties

    private static var sharedStorage: HTTPCookieStorage?
    private static var sharedCookieStorages: [String: HTTPCookieStorage] = [:]  
    private let workQueue: DispatchQueue = DispatchQueue(label: "com.WatcherCookieStorage.queue", 
                                                         attributes: .concurrent)
    private var allCookies: [String: HTTPCookie]
    private var cookieAcceptPolicyPrivate: HTTPCookie.AcceptPolicy = .always
    
    
    override open var cookies: [HTTPCookie]? {
        var cookies: [HTTPCookie]?
        workQueue.sync {
            cookies = Array(self.allCookies.values)
        }
        return cookies
    }
    
    
    override open var cookieAcceptPolicy: HTTPCookie.AcceptPolicy {
        get {
            return cookieAcceptPolicyPrivate
        }
        set {
            cookieAcceptPolicyPrivate = newValue
        }
    }
    
    
    override open class var shared: HTTPCookieStorage {
        guard let sharedStorage = sharedStorage else { 
            self.sharedStorage = WatcherCookieStorage(cookieStorageName: "WatcherCookieStorage")
            return self.sharedStorage!
        }
        return sharedStorage
    }
    
    
    override open class func sharedCookieStorage(forGroupContainerIdentifier identifier: String) -> HTTPCookieStorage {
        guard let cookieStorage = sharedCookieStorages[identifier] else {
            let newCookieStorage = WatcherCookieStorage(cookieStorageName: identifier)
            sharedCookieStorages[identifier] = newCookieStorage
            return newCookieStorage
        }
        return cookieStorage
    }
    
    
    // MARK: - Initialization

    private init(cookieStorageName: String) {
        allCookies = [:]
        super.init()
        cookieAcceptPolicyPrivate = .always
    }

    
    // MARK: - Methods
    
    override open func setCookie(_ cookie: HTTPCookie) {
        workQueue.async(flags: .barrier) {
            guard self.cookieAcceptPolicy != .never else { return }
            let key = cookie.domain + cookie.path + cookie.name

            if self.allCookies.index(forKey: key) != nil {
                self.allCookies.updateValue(cookie, forKey: key)
            } else {
                self.allCookies[key] = cookie
            }
            let expiredCookies = self.allCookies.filter { (_, value) in 
                guard let expiresDate = value.expiresDate else { return false }
                return expiresDate.timeIntervalSinceNow < 0 
            }
            for (key, _) in expiredCookies {
                self.allCookies.removeValue(forKey: key)
            }
        }
    }
    
    
    override open func deleteCookie(_ cookie: HTTPCookie) {
        let key = cookie.domain + cookie.path + cookie.name
        workQueue.async(flags: .barrier) {
            self.allCookies.removeValue(forKey: key)
        }
    }
    
    
    override open func removeCookies(since date: Date) {
        var cookiesSinceDate = [HTTPCookie]()
        workQueue.sync {
            cookiesSinceDate = allCookies.values.filter { (cookie) -> Bool in
                return cookie.dateCreate > date
            }
        }
        for cookie in cookiesSinceDate {
            deleteCookie(cookie)
        }
    }
    
    
    override open func cookies(for URL: URL) -> [HTTPCookie]? {
        var cookies: [HTTPCookie]?
        guard let host = URL.host else { return nil }
        workQueue.sync {
            cookies = Array(self.allCookies.values.filter { $0.domain == host })
        }
        return cookies
    }
    
    
    override open func setCookies(_ cookies: [HTTPCookie], for URL: URL?, mainDocumentURL: URL?) {
        guard cookieAcceptPolicy != .never else { return }
        guard let urlHost = URL?.host else { return }
        if mainDocumentURL != nil && cookieAcceptPolicy == .onlyFromMainDocumentDomain {
            guard let mainDocumentHost = mainDocumentURL?.host else { return }
            guard mainDocumentHost.hasSuffix(urlHost) else { return }
        }
        let validCookies = cookies.filter { urlHost == $0.domain }
        for cookie in validCookies {
            setCookie(cookie)
        }
    }
    
    
    override open func sortedCookies(using sortOrder: [NSSortDescriptor]) -> [HTTPCookie] {
        guard let cookies = cookies else { return [] }
        guard let sortedCookies = (cookies as NSArray).sortedArray(using: sortOrder) as? [HTTPCookie] else { return [] }
        return sortedCookies
    }
    
}


extension WatcherCookieStorage {
    
    override open func storeCookies(_ cookies: [HTTPCookie], for task: URLSessionTask) {
        let mainDocUrl = task.currentRequest?.url ?? task.originalRequest?.mainDocumentURL ?? task.originalRequest?.url
        setCookies(cookies, for: task.currentRequest?.url, mainDocumentURL: mainDocUrl)
    }
 
    
    override open func getCookiesFor(_ task: URLSessionTask, completionHandler: @escaping ([HTTPCookie]?) -> Void) {
        guard let url = task.currentRequest?.url else {
            completionHandler(nil)
            return
        }
        completionHandler(cookies(for: url))
    }
    
}
