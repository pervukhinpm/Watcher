//
//  APIClient.swift
//  Wathcer
//
//  Created by Петр Первухин on 17/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Alamofire
import Foundation

///ApiClient обертка над Alamofire для отправки запросов
open class ApiClient: NSObject, ApiClientProtocol {
    
    private var sessionManager: SessionManager
    
    
    /// Создание экземпляра ApiClient
    ///
    /// - Parameter configuration: URLSessionConfiguration для конфигурация сессии 
    public init(configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral) {
        self.sessionManager = Alamofire.SessionManager(configuration: configuration)
        super.init()
    }
    
 
    /// Отправка запроса с Request'ом который подписан на протокол Endpoint.
    ///
    /// - Parameter request: Request подписанный на протокол Endpoint
    /// - Parameter completionHandler: completionHandler возвращается Request.Response и ApiClientError.
    public func request<Request>(
        with request: Request, 
        completionHandler: @escaping (ApiResult<Request.Response>) -> Void) where Request: Endpoint {
        do {
            sessionManager.request(try request.request()).responseData { (response) in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else { return }
                    switch statusCode {
                    case 200..<400: 
                        do {
                            guard let data = response.data else {
                                print("APIClient error: response.data = nil")
                                return
                            }
                            
                            if let headerFields = response.response?.allHeaderFields as? [String: String],
                                let url = response.request?.url {
                                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
                                if !cookies.isEmpty { 
                                    if let cookie = cookies.first {
                                        TokenProvider.shared.token = cookie.value
                                    }
                                }
                            }
                            let response = try request.parse(response: data)
                            completionHandler(.success(response))

                        } catch let error {
                            completionHandler(.failure(error))
                        }
                    case 400..<600:
                        completionHandler(.statusCode(statusCode))
                    default:
                        return
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        } catch let error {
            completionHandler(.failure(error))
        }
    }
}       
