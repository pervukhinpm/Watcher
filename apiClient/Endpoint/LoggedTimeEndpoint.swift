//
//  LoggedTimeEndpoint.swift
//  Wathcer
//
//  Created by Петр Первухин on 18/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Alamofire

///Endpoint для отправки post запроса с LogTimeRequest для списания времени
public struct LoggedTimeEndpoint: Endpoint {
    
    public typealias Response = LoggedTimeData

    private var logTimeRequest: LogTimeRequest
    
    public init(logTimeRequest: LogTimeRequest) {
        self.logTimeRequest = logTimeRequest
    }
    
    public func request() throws -> URLRequest {
        let components = URLComponents(string: "https://watcher.intern.redmadrobot.com/api/v1/logged-time/")!
        var request = URLRequest(url: components.url!)
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        request.httpBody = try jsonEncoder.encode(logTimeRequest)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("access_token=\(TokenProvider.shared.token)", forHTTPHeaderField: "Cookie")
        return request
    }

    public func parse(response: Data) throws -> LoggedTimeData {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData = try decoder.decode(APIResponse<LoggedTimeData>.self, from: response)
        return decodedData.data
    }

}
