//
//  WatcherCookieStorageTests.swift
//  apiClientTests
//
//  Created by Петр Первухин on 26/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import XCTest

class WatcherCookieStorageTests: XCTestCase {

    var cookie: HTTPCookie?
    var urlString = "https://watcher.intern.redmadrobot.com/api/v1/calendar"

    override func setUp() {
        let properties = [HTTPCookiePropertyKey.name: "access_token",
                          HTTPCookiePropertyKey.value: "rkovp024lyxoalo7tc2hr4tjnz476ac8",
                          HTTPCookiePropertyKey.originURL: urlString,
                          HTTPCookiePropertyKey.version: "0",
                          HTTPCookiePropertyKey.domain: "watcher.intern.redmadrobot.com",
                          HTTPCookiePropertyKey.path: "/",
                          HTTPCookiePropertyKey.secure: "false",
                          HTTPCookiePropertyKey.expires: "Tue, 09 Apr 2019 15:31:43 GMT",
                          HTTPCookiePropertyKey.comment: "",
                          HTTPCookiePropertyKey.commentURL: "",
                          HTTPCookiePropertyKey.discard: "",
                          HTTPCookiePropertyKey.maximumAge: "1209600",
                          HTTPCookiePropertyKey.port: ""]
        self.cookie = HTTPCookie(properties: properties)!
    }
    
    override func tearDown() {
        self.cookie = nil
    }

    func testSetCookie() {
        guard let cookie = cookie else { 
            XCTFail("cookie nil")
            return 
        }
        WatcherCookieStorage.shared.setCookie(cookie)
        XCTAssertEqual(WatcherCookieStorage.shared.cookies?.first, cookie)
    }
    
    func testDeleteCookie() {
        guard let cookie = cookie else { 
            XCTFail("cookie nil")
            return 
        }
        WatcherCookieStorage.shared.setCookie(cookie)
        WatcherCookieStorage.shared.deleteCookie(cookie)
        XCTAssertEqual(WatcherCookieStorage.shared.cookies?.count, 0)
    }

    func testRemoveCookiesSinceDate() {
        guard let cookie = cookie else { 
            XCTFail("cookie nil")
            return 
        }
        let dateString = "01-01-2018"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yyyy"
        let date = dateFormatter.date(from: dateString)
        WatcherCookieStorage.shared.setCookie(cookie)
        WatcherCookieStorage.shared.removeCookies(since: date!)
        XCTAssertEqual(WatcherCookieStorage.shared.cookies?.count, 0)
    }
    
    
    func testSetCookiesForUrl() {
        guard let cookie = cookie else { 
            XCTFail("cookie nil")
            return 
        }
        let components = URLComponents(string: urlString)!
        WatcherCookieStorage.shared.setCookies([cookie], for: components.url, mainDocumentURL: nil)
        XCTAssertEqual(WatcherCookieStorage.shared.cookies(for: components.url!)?.first, cookie)
    }

    
    func testSetCookiesForURLSessionDataTask() {
        guard let cookie = cookie else { 
            XCTFail("cookie nil")
            return 
        }
        let components = URLComponents(string: urlString)!
        let urlSessionTask = URLSession.shared.dataTask(with: components.url!)
        WatcherCookieStorage.shared.storeCookies([cookie], for: urlSessionTask)
        WatcherCookieStorage.shared.getCookiesFor(urlSessionTask) { (cookies) in
            XCTAssertEqual(cookies!.first, cookie)
        }
    }
    
}
