//
//  SQLoggedTimeRecordTranslator.swift
//  Persistancy
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import SQLite

///Класс транслятор для моделей LoggedTimeRecord и SQLLoggedTimeRecord
class SQLoggedTimeRecordTranslator: SQLiteTranslator<LoggedTimeRecord, SQLLoggedTimeRecord> {
  
    // MARK: - Private Properties

    private let id = Expression<Int64>("id")
    private let dateId = Expression<Int64>("dateId")
    private let date = Expression<String>("date")
    private let minutesSpent = Expression<Int64>("minutesSpent")
    private let description = Expression<String>("description")
    private let projectName = Expression<String>("projectName")
    private let projectId = Expression<Int64>("projectId")
    
    
    // MARK: - Filling

    open override func fill(fromEntry: Row) -> LoggedTimeRecord {
        let project = Project(id: Int(fromEntry[projectId]),
                              name: fromEntry[projectName])
        
        let loggedTimeRecord = LoggedTimeRecord(projectId: project.id, 
                                                id: Int(fromEntry[id]), 
                                                minutesSpent: Int(fromEntry[minutesSpent]),
                                                project: project, 
                                                date: fromEntry[date], 
                                                description: fromEntry[description])
        
        return loggedTimeRecord
    }
    
    
    open  override func fill(_ entry: SQLLoggedTimeRecord, fromEntity: LoggedTimeRecord) -> Insert {
        let someDate = Date.convertStringToDateFrom(dateString: fromEntity.date)
        let timeInterval = someDate.timeIntervalSince1970
        let idDate = Int64(timeInterval)
        
        let insert = entry.table.insert(id <- Int64(fromEntity.id), 
                                        dateId <- idDate,
                                        date <- fromEntity.date,
                                        minutesSpent <- Int64(fromEntity.minutesSpent),
                                        description <- fromEntity.description,
                                        projectId <- Int64(fromEntity.project.id),
                                        projectName <- fromEntity.project.name)
        return insert
    }
    
}
