//
//  CheckAuthorizationEndpoint.swift
//  apiClient
//
//  Created by Петр Первухин on 12/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Alamofire

///Endpoint для отправки get запроса на проверку авторизацию
public struct AuthorizationCheckEndpoint: Endpoint {
    
    public typealias Response = AuthorizationCheckData
    
    public init() {
    }
    
    public func request() throws -> URLRequest {
        let components = URLComponents(string: "https://watcher.intern.redmadrobot.com/api/v1/auth/check/")!
        var request = URLRequest(url: components.url!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("access_token=\(TokenProvider.shared.token)", forHTTPHeaderField: "Cookie")
        return request
    }
    
    public func parse(response: Data) throws -> AuthorizationCheckData {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData = try decoder.decode(APIResponse<AuthorizationCheckData>.self, from: response)
        return decodedData.data
    }
    
}
