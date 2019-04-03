//
//  AuthorizationError.swift
//  Watcher
//
//  Created by Петр Первухин on 19/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

///Enum ошибок которые могут возникнуть при авторизации пользователя auth/sign-in/
enum AuthorizationError: Int {
    
    case validationError = 400
    case invalidLoginError = 401
    
    var desciption: String {
        switch self {
        case .validationError: return ls("validation_error")
        case .invalidLoginError: return ls("login_error")
        }
    }
}
