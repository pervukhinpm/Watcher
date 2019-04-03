//
//  AuthorizationModel.swift
//  Wathcer
//
//  Created by Петр Первухин on 13/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

///Сруктура ответа сервера при авторизации auth/sign-in/
public struct AuthorizationData: Codable {
    public var user: User
}

public struct User: Codable {
    public var id: Int
    public var email: String
    public var lastName: String
    public var isStaff: Bool
    public var role: String
    public var firstName: String
}

///Extension структуры AuthorizationData для сравнения двух AuthorizationData
extension AuthorizationData: Equatable {
    static public func == (lhs: AuthorizationData, rhs: AuthorizationData) -> Bool {
        if lhs.user == rhs.user {
            return true
        } else {
            return false
        }
    }
}

///Extension структуры USer для сравнения двух User
extension User: Equatable {
    static public func == (lhs: User, rhs: User) -> Bool {
        if lhs.id == rhs.id,
            lhs.email == rhs.email,
            lhs.lastName == rhs.lastName,
            lhs.isStaff == rhs.isStaff,
            lhs.role == rhs.role,
            lhs.firstName == rhs.firstName {
            return true
            } else {
            return false
        }
    }
}
