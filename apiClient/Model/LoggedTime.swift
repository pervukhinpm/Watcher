//
//  LoggedTime.swift
//  Wathcer
//
//  Created by Петр Первухин on 18/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

///Структуры ответа сервера при post запросе списания времени /logged-time/
public struct LoggedTimeData: Codable {
    public var loggedTime: LoggedTime
}

public struct LoggedTime: Codable {
    public var projectId: Int
    public var userId: Int
    public var minutesSpent: Int
}

///Структура для httpBody для post запроса на списания времени /logged-time/
public struct LogTimeRequest: Codable {
    public var projectId: Int
    public var minutesSpent: Int
    public var date: String
    public var description: String
    
    public init(projectId: Int, minutesSpent: Int, date: String, description: String) {
        self.projectId = projectId
        self.minutesSpent = minutesSpent
        self.date = date
        self.description = description
    }
}

///Extension структуры Project для сравнения двух проектов
extension LoggedTimeData: Equatable {
    static public func == (lhs: LoggedTimeData, rhs: LoggedTimeData) -> Bool {
        if lhs.loggedTime == rhs.loggedTime {
            return true
        } else {
            return false
        }
    }
}

///Extension структуры Project для сравнения двух проектов
extension LoggedTime: Equatable {
    static public  func == (lhs: LoggedTime, rhs: LoggedTime) -> Bool {
        if lhs.projectId == rhs.projectId, 
            lhs.userId == rhs.userId, 
            lhs.minutesSpent == rhs.minutesSpent {
            return true
        } else {
            return false
        }
    }
}
