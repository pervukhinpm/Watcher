//
//  ListLoggedTime.swift
//  Watcher
//
//  Created by Петр Первухин on 23/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

///Структура получения с сервера метода /days
public class LoggedDays: Codable {
    
    public var days: [LoggedDay]

    public init(days: [LoggedDay]) {
        self.days = days       
    }
    
    public init() {
        self.days = [LoggedDay]()
    }
    
}

public class LoggedDay: Entity, Codable {
    
    public var date: String
    public var isWorking: Bool
    public var loggedTimeRecords: [LoggedTimeRecord]
    
    public init(date: String, 
                isWorking: Bool, 
                loggedTimeRecords: [LoggedTimeRecord]) {
        self.date = date
        self.isWorking = isWorking
        self.loggedTimeRecords = loggedTimeRecords   
    }
    
    required public init() {
        self.date = ""
        self.isWorking = false
        self.loggedTimeRecords = [LoggedTimeRecord]()
    }
}


public class LoggedTimeRecord: Entity, Codable {
    
    public var projectId: Int
    public var id: Int
    public var minutesSpent: Int
    public var project: Project
    public var date: String
    public var description: String
    
    public init(projectId: Int,
                id: Int, 
                minutesSpent: Int, 
                project: Project, 
                date: String, 
                description: String) {
        self.id = id
        self.projectId = id
        self.minutesSpent = minutesSpent
        self.project = project
        self.date = date
        self.description = description
    }
    
    required public init() {
        self.projectId = 0
        self.id = 0
        self.minutesSpent = 0
        self.project = Project()
        self.date = ""
        self.description = "description"
    }
}

///Extension структуры LoggedDay для сравнения двух LoggedDay
extension LoggedDay: Equatable {
    static public func == (lhs: LoggedDay, rhs: LoggedDay) -> Bool {
        if lhs.date == rhs.date,
            lhs.isWorking == rhs.isWorking,
            lhs.loggedTimeRecords == rhs.loggedTimeRecords {
            return true
        } else {
            return false
        }
    }
}

///Extension структуры LoggedDay для сравнения двух LoggedDay
extension LoggedTimeRecord: Equatable {
    static public func == (lhs: LoggedTimeRecord, rhs: LoggedTimeRecord) -> Bool {
        if lhs.projectId == rhs.projectId,
            lhs.id == rhs.id,
            lhs.minutesSpent == rhs.minutesSpent,
            lhs.project == rhs.project,
            lhs.date == rhs.date,
            lhs.description == rhs.description {
            return true
        } else {
            return false
        }
    }
}
