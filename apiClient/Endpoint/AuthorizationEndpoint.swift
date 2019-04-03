//
//  AuthorizationEndpoint.swift
//  Wathcer
//
//  Created by Петр Первухин on 17/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Alamofire

///Endpoint для отправки post запроса на авторизацию
public struct AuthorizationEndpoint: Endpoint {
    
    public typealias Response = AuthorizationData
    
    private var password: String
    private var email: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    public func request() throws -> URLRequest {
        let components = URLComponents(string: "https://watcher.intern.redmadrobot.com/api/v1/auth/sign-in/")!
        let login = Login(email: email, password: password)
        var request = URLRequest(url: components.url!)
        request.httpBody = try JSONEncoder().encode(login)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    public func parse(response: Data) throws -> AuthorizationData {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData = try decoder.decode(APIResponse<AuthorizationData>.self, from: response)
        return decodedData.data
    }
    
}
