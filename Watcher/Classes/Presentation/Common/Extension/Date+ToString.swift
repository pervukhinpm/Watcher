//
//  Date+ToString.swift
//  Watcher
//
//  Created by Петр Первухин on 24/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

extension Date {
    static func convertStringToDateFrom(dateString: String) -> Date {
        let dateFormatter = Date.getDateFormatter()
        return dateFormatter.date(from: dateString)!
    }
    
    static func convertDateToStringFrom(date: Date) -> String {
        let dateFormatter = Date.getDateFormatter()
        return dateFormatter.string(from: date)
    }
    
    static func convertStringToDayMonthString(dateString: String) -> String {
        let dateFormatter = Date.getDateFormatter()
        let date = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = "dd.MM"
        return dateFormatter.string(from: date)
    }
    
    static func convertStringToDayFrom(dateString: String) -> String {
        let dateFormatter = Date.getDateFormatter()
        let date = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }
    
    private static func getDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter
    }
    
    static func getCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ru_RU")
        calendar.timeZone = TimeZone(identifier: "GMT")!
        return calendar
    }
    
    var startDateBackToWeek: Date {
        let calendar = Date.getCalendar()
        let newDate = calendar.date(byAdding: .weekOfYear, value: -1, to: self)!
        let dateComponents = calendar.dateComponents([.yearForWeekOfYear,
                                                      .weekOfYear], from: newDate)
        let nextWeekDate = calendar.date(from: dateComponents)
        let startOfNextWeekDate = nextWeekDate?.startOfWeek
        return startOfNextWeekDate!
    }
    
    var startDateNextWeek: Date {
        let calendar = Date.getCalendar()
        let newDate = calendar.date(byAdding: .weekOfYear, value: 1, to: self)!
        let dateComponents = calendar.dateComponents([.yearForWeekOfYear,
                                                      .weekOfYear], from: newDate)
        let nextWeekDate = calendar.date(from: dateComponents)
        let startOfNextWeekDate = nextWeekDate?.startOfWeek
        return startOfNextWeekDate!
    }
    
    var startDateBackToMonth: Date {
        let calendar = Date.getCalendar()
        let newDate = calendar.date(byAdding: DateComponents(month: -1),
                                    to: self)!.startOfMonth
        return newDate
    }
    
    var startDateNextMonth: Date {
        let calendar = Date.getCalendar()
        let newDate = calendar.date(byAdding: DateComponents(month: 1),
                             to: self)!.startOfMonth
        return newDate
    }
    
    
    var startOfWeek: Date {
        let calendar = Date.getCalendar()
        let dateComponents = calendar.dateComponents([.yearForWeekOfYear,
                                                                .weekOfYear],
                                                               from: self)
        return calendar.date(from: dateComponents)!
    }
    
    var endOfWeek: Date {
        let calendar = Date.getCalendar()
        return calendar.date(byAdding: .day, value: 6, to: self)!
    }
    
    var startOfMonth: Date {
        let calendar = Date.getCalendar()
        let dateComponents = calendar.dateComponents([.year, 
                                                      .month],
                                                     from: self)
        return calendar.date(from: dateComponents)!
    }
    
    var endOfMonth: Date {
        let calendar = Date.getCalendar()
        return calendar.date(byAdding: DateComponents(month: 1, day: -1),
                             to: self.startOfMonth)!
    }
}
