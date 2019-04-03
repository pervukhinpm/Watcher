//
//  LoggedTimeError.swift
//  Watcher
//
//  Created by Петр Первухин on 19/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

///Enum ошибок которые могут возникнуть при post запросе списания времени /logged-time/
enum LoggedTimeError: Int {
    
    case validationError = 400
    case authenticationRequiredError = 401
    
    var desciption: String {
        switch self {
        case .validationError: return ls("validation_error")
        case .authenticationRequiredError: return ls("authentication_required_error")
        }
    }
}
