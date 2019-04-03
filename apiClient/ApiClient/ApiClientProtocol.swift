//
//  ApiClientProtocol.swift
//  Watcher
//
//  Created by Петр Первухин on 19/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

public protocol ApiClientProtocol {
    func request<Request>(
        with request: Request,
        completionHandler: @escaping (ApiResult<Request.Response>) -> Void) where Request: Endpoint
}
