//
//  AuthorizationViewModel.swift
//  Wathcer
//
//  Created by Петр Первухин on 13/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

struct AuthorizationViewModel {
    
    var firstName: String?
    var lastName: String?
    var role: String?
    
    init(firstName: String?, lastName: String?, role: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.role = role
    }
    
}
