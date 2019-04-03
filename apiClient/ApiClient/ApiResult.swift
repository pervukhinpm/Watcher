//
//  ApiResult.swift
//  Watcher
//
//  Created by Петр Первухин on 19/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

///Generic enum ApiResult
public enum ApiResult<T> {
    case success(T)
    case failure(Error)
    case statusCode(Int)
}
