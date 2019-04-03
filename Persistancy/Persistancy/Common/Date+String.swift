//
//  Date+String.swift
//  Persistancy
//
//  Created by Петр Первухин on 18/03/2019.
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
    
    private static func getDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter
    }
    
}
