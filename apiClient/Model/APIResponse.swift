//
//  APIResponse.swift
//  Wathcer
//
//  Created by Петр Первухин on 17/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

///Generic структура-обертка для всех ответов API
public struct APIResponse<Content>: Decodable where Content: Decodable {
    public let data: Content
}
