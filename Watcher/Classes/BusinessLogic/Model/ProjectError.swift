//
//  ProjectError.swift
//  Watcher
//
//  Created by Петр Первухин on 19/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

///Enum ошибок которые могут возникнуть при запросе списка проектов /projects/
enum ProjectError: Int {
    
    case authenticationRequiredError = 401
    
    var desciption: String {
        switch self {
        case .authenticationRequiredError: return ls("authentication_required_error")
        }
    }
}
