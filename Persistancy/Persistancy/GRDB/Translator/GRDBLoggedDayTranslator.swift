//
//  GRDBLoggedDayTranslator.swift
//  Persistancy
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import GRDB

open class GRDBLoggedDayTranslator: GRDBTranslator<LoggedDay, GRDBLoggedDay> {

    // MARK: - Private Properties

    private let dbQueue: DatabaseQueue
    
    // MARK: - Initialiaztion
    
    /// Создание экземпляра GRDBLoggedDayTranslator
    ///
    /// - Parameter dbQueue: DatabaseQueue для работы с базой данных
    public init(dbQueue: DatabaseQueue) {
        self.dbQueue = dbQueue
    }
    
    required public init() {
        fatalError("init() has not been implemented")
    }
    
    
    // MARK: - Filling

    open override func fill(_ entity: inout LoggedDay, fromEntry: GRDBLoggedDay) {
        do {            
            entity.date = fromEntry.date
            entity.isWorking = fromEntry.isWorking
            
            let grdbLoggedTimeRecords: [GRDBLoggedTimeRecord] = try dbQueue.read { db in
                let timeRecords = try fromEntry.grdbLoggedTimeRecords.fetchAll(db)
                return timeRecords
            }
            
            var loggedTimeRecords = [LoggedTimeRecord]()
            for grdbLoggedTimeRecord in grdbLoggedTimeRecords {
                var loggedTimeRecord = LoggedTimeRecord()
                GRDBLoggedTimeRecordTranslator(dbQueue: dbQueue).fill(&loggedTimeRecord, 
                                                                      fromEntry: grdbLoggedTimeRecord)
                loggedTimeRecords.append(loggedTimeRecord)
            }
            entity.loggedTimeRecords = loggedTimeRecords
        } catch {   
            print(error)
        }
    }
    
    
    open override func fill(_ entry: inout GRDBLoggedDay, fromEntity: LoggedDay) {
        
        let someDate = Date.convertStringToDateFrom(dateString: fromEntity.date)
        let timeInterval = someDate.timeIntervalSince1970
        let dateId = Int64(timeInterval)
        
        entry.id = dateId
        entry.date = fromEntity.date
        entry.isWorking = fromEntity.isWorking
        
    }
    
}
