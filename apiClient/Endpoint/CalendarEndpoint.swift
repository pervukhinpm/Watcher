//
//  CalendarEndpoint.swift
//  apiClient
//
//  Created by Петр Первухин on 01/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Alamofire

///Endpoint для отправки get запроса /calendar на получение CalendarDays 
public struct CalendarDaysEndpoint: Endpoint {
    
    public typealias Response = CalendarDays
    
    private var fromDate: String
    private var toDate: String
    
    public init(fromDate: String, toDate: String) {
        self.fromDate = fromDate
        self.toDate = toDate
    }
    
    public func request() throws -> URLRequest {
        var components = URLComponents(string: "https://watcher.intern.redmadrobot.com/api/v1/calendar")!
        components.queryItems = [
            URLQueryItem(name: "from", value: "\(fromDate)"),
            URLQueryItem(name: "to", value: "\(toDate)")
        ]
        var request = URLRequest(url: components.url!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("access_token=\(TokenProvider.shared.token)", forHTTPHeaderField: "Cookie")
        return request
    }
    
    public func parse(response: Data) throws -> CalendarDays {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData = try decoder.decode(APIResponse<CalendarDays>.self, from: response)
        return decodedData.data
    }
}
