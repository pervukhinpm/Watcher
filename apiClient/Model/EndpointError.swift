//
//  EndpointError.swift
//  Watcher
//
//  Created by Петр Первухин on 19/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

///Enum ошибок для Endpoint'a
public enum EndpointError: Error {
    case invalidUrl
    case encondingError
}
