//
//  TokenProvider.swift
//  apiClient
//
//  Created by Петр Первухин on 11/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

///Класс для хранения accessToken'а
open class TokenProvider {
    
    static public let shared = TokenProvider()
    
    public var token = ""

}
