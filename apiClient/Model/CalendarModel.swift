//
//  CalendarModel.swift
//  apiClient
//
//  Created by Петр Первухин on 01/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

///Структура получения с сервера метода /days
public struct CalendarDays: Codable {
    public var days: [CalendarDay]
    
    public init(days: [CalendarDay]) {
        self.days = days       
    }
}

public struct CalendarDay: Codable {
    public var date: String
    public var isWorking: Bool
    
    public init(date: String, 
                isWorking: Bool) {
        self.date = date
        self.isWorking = isWorking
    }
}
