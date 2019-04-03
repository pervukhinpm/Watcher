//
//  WatcherViewModel.swift
//  Watcher
//
//  Created by Петр Первухин on 26/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

public struct WatcherViewModel {
    
    // MARK: - Public Properties

    public var weekWorkHours: String = "40"
    public var currentWeek: String = ""
    
    public var currentStartWeekDate: Date = Date() {
        didSet {
            currentWeek = makeStringDatePeriod(date: currentStartWeekDate)
        }
    }
    
    public var loggedMonthTime: String = "" {
        didSet {
            loggedMonthTime = "\(loggedMonthTime) ч не списано в этом месяце" 
        }
    }
    
    public var loggedWeekTime: String = "" {
        didSet {
            loggedWeekTime = "\(loggedWeekTime) / \(weekWorkHours)" 
        }
    }
    
    
    // MARK: - Help Methods

    private func makeStringDatePeriod(date: Date) -> String {        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd"
        let dayStartOfWeek = dateFormatter.string(from: date.startOfWeek)
        dateFormatter.dateFormat = "dd MMMM"
        let dayEndOfWeek = dateFormatter.string(from: date.endOfWeek)
        let period = dayStartOfWeek + " — " + dayEndOfWeek
        return period
    } 
    
}
