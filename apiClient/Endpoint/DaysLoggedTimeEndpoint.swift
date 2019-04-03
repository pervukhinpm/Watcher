//
//  DaysLoggedTimeEndpoint.swift
//  Watcher
//
//  Created by Петр Первухин on 23/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Alamofire

///Endpoint для отправки get запроса на получение LoggedDays
public struct DaysLoggedTimeEndpoint: Endpoint {
    
    public typealias Response = LoggedDays
 
    private var fromDate: String
    private var toDate: String
    
    public init(fromDate: String, toDate: String) {
        self.fromDate = fromDate
        self.toDate = toDate
    }
    
    public func request() throws -> URLRequest {
        var components = URLComponents(string: "https://watcher.intern.redmadrobot.com/api/v1/days")!
        components.queryItems = [
            URLQueryItem(name: "from", value: "\(fromDate)"),
            URLQueryItem(name: "to", value: "\(toDate)")
        ]
        var request = URLRequest(url: components.url!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("access_token=\(TokenProvider.shared.token)", forHTTPHeaderField: "Cookie")
        return request
    }
    
    public func parse(response: Data) throws -> LoggedDays {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData = try decoder.decode(APIResponse<LoggedDays>.self, from: response)
        return decodedData.data
    }
}
