//
//  Login.swift
//  Watcher
//
//  Created by Петр Первухин on 19/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

///Структура httpBody для post запроса аутентификации auth/sign-in/
public struct Login: Encodable {
    public var email: String
    public var password: String
}
