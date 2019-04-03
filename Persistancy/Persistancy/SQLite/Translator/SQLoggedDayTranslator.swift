//
//  SQLoggedDayTranslator.swift
//  Watcher
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import SQLite

///Класс транслятор для моделей LoggedDay и SQLLoggedDay
class SQLoggedDayTranslator: SQLiteTranslator<LoggedDay, SQLLoggedDay> {
    
    // MARK: - Private Properties

    private let id = Expression<Int64>("id")
    private let date = Expression<String>("date")
    private let isWorking = Expression<Bool>("isWorking")
    
    
    // MARK: - Filling

    open override func fill(fromEntry: Row) -> LoggedDay {
        let emptyLoggedTimeRecords = [LoggedTimeRecord]()
        let loggedDay = LoggedDay(date: fromEntry[date], 
                                  isWorking: fromEntry[isWorking],  
                                  loggedTimeRecords: emptyLoggedTimeRecords)
        return loggedDay
    }
    
    
    open  override func fill(_ entry: SQLLoggedDay, fromEntity: LoggedDay) -> Insert {
        
        let someDate = Date.convertStringToDateFrom(dateString: fromEntity.date)
        let timeInterval = someDate.timeIntervalSince1970
        let dateId = Int64(timeInterval)
        
        let insert = entry.table.insert(id <- dateId,
                                        date <- fromEntity.date,
                                        isWorking <- fromEntity.isWorking)
        return insert
    }
    
}
