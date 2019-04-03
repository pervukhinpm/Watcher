//
//  GRDBLoggedTimeRecordTranslator.swift
//  Persistancy
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import GRDB

///Класс транслятор для моделей LoggedTimeRecord и GRDBLoggedTimeRecord
open class GRDBLoggedTimeRecordTranslator: GRDBTranslator<LoggedTimeRecord, GRDBLoggedTimeRecord> {

    // MARK: - Private Properties

    private let dbQueue: DatabaseQueue
    
    
    // MARK: - Initialiaztion
    
    /// Создание экземпляра GRDBLoggedTimeRecordTranslator
    ///
    /// - Parameter dbQueue: DatabaseQueue для работы с базой данных
    required public init(dbQueue: DatabaseQueue) {
        self.dbQueue = dbQueue
    }
    
    required public init() {
        fatalError("init() has not been implemented")
    }
    
    
    // MARK: - Filling

    open override func fill(_ entity: inout LoggedTimeRecord, fromEntry: GRDBLoggedTimeRecord) {
        entity.id = Int(fromEntry.id)
        entity.date = fromEntry.date
        entity.minutesSpent = Int(fromEntry.minutesSpent)
        entity.description = fromEntry.description
        
        do {
            let grdbProject: GRDBProject = try dbQueue.read { db in
                let project = try GRDBProject.fetchOne(db, key: fromEntry.projectId) 
                return project!
            }
            entity.project.id = Int(grdbProject.id)
            entity.project.name = grdbProject.name
        } catch {
            print(error)
        }
    }
    
    
    open override func fill(_ entry: inout GRDBLoggedTimeRecord, fromEntity: LoggedTimeRecord) {
        
        let someDate = Date.convertStringToDateFrom(dateString: fromEntity.date)
        let timeInterval = someDate.timeIntervalSince1970
        let dateId = Int64(timeInterval)
        
        entry.id = Int64(fromEntity.id)
        entry.date = fromEntity.date
        entry.minutesSpent = Int64(Int(fromEntity.minutesSpent))
        entry.dateId = dateId
        entry.description = fromEntity.description
        entry.projectId = Int64(fromEntity.project.id)
        
    }
    
}
