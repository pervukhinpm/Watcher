//
//  ProjectEndpoint.swift
//  Wathcer
//
//  Created by Петр Первухин on 17/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Alamofire

///Endpoint для отправки запроса на получения списка проектов
public struct ProjectEndpoint: Endpoint {
    
    public typealias Response = ProjectData
    
    public init() {
    }
    
    public func request() throws -> URLRequest {
        let components = URLComponents(string: "https://watcher.intern.redmadrobot.com/api/v1/projects/")!
        var request = URLRequest(url: components.url!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("access_token=\(TokenProvider.shared.token)", forHTTPHeaderField: "Cookie")
        return request
    }
    
    public func parse(response: Data) throws -> ProjectData {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData = try decoder.decode(APIResponse<ProjectData>.self, from: response)
        return decodedData.data
    }
}
