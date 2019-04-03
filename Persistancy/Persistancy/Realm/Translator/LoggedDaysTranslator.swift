//
//  LoggedDaysTranslator.swift
//  Watcher
//
//  Created by Петр Первухин on 25/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import RealmSwift

///LoggedDaysTranslator переводит модель базы данных Realm RMLoggedDay  в модель ответа с сервера LoggedDays
class LoggedDaysTranslator {
    
    // MARK: - Fillig
    
    /// Все properties rlmModel будут перезаписаны в entry properties LoggedDays.
    ///
    /// - Parameters:
    ///   - rlmModel: экземпляр типа Results<RMLoggedDay>
    /// - Returns: массив LoggedDays
    func translate(rlmModel: Results<RMLoggedDay>) -> LoggedDays {
        let rlmArray = Array(rlmModel)       
        let loggedDays = rlmArray.map { (rmlLoggedDay) -> LoggedDay in
            let loggedDay = LoggedDay(
                                   date: rmlLoggedDay.dateString, 
                                   isWorking: rmlLoggedDay.isWorking, 
                                   loggedTimeRecords: translate(rlmLoggedTimeRecords: rmlLoggedDay.loggedTimeRecords))
            return loggedDay
        }
        return LoggedDays(days: loggedDays)
    }
    
    
    /// Все properties List<RMLoggedTimeRecord> в [LoggedTimeRecord]
    ///
    /// - Parameters:
    /// - rlmLoggedTimeRecords: экземпляр типа List<RMLoggedTimeRecord>
    /// - Returns: массив [LoggedTimeRecord]
    private func translate(rlmLoggedTimeRecords: List<RMLoggedTimeRecord>) -> [LoggedTimeRecord] {
        let loggedTimeRec = Array(rlmLoggedTimeRecords.map { (rlmRecord) -> LoggedTimeRecord in
            let loggedTimeRecord = LoggedTimeRecord(
                             projectId: rlmRecord.projectId, 
                             id: rlmRecord.id, 
                             minutesSpent: rlmRecord.minutesSpent, 
                             project: self.translate(rlmProject: rlmRecord.project!), 
                             date: rlmRecord.date,
                             description: rlmRecord.projectDescription)
            
            return loggedTimeRecord
        })
        return loggedTimeRec
    }
    
        
    /// Все properties Results<RMLoggedTimeRecord> в [LoggedTimeRecord]
    ///
    /// - Parameters:
    /// - rlmLoggedTimeRecords: экземпляр типа Results<RMLoggedTimeRecord>
    /// - Returns: массив [LoggedTimeRecord]
    func translate(rlmLoggedTimeRecords: Results<RMLoggedTimeRecord>) -> [LoggedTimeRecord] {
        let loggedTimeRec = Array(rlmLoggedTimeRecords.map { (rlmRecord) -> LoggedTimeRecord in
            let loggedTimeRecord = LoggedTimeRecord(
                projectId: rlmRecord.projectId, 
                id: rlmRecord.id, 
                minutesSpent: rlmRecord.minutesSpent, 
                project: self.translate(rlmProject: rlmRecord.project!), 
                date: rlmRecord.date,
                description: rlmRecord.projectDescription)
            
            return loggedTimeRecord
        })
        return loggedTimeRec
    }
    
        
    /// Все properties RMProject в Project
    ///
    /// - Parameters:
    /// - rlmProject: экземпляр типа RMProject
    /// - Returns: экземпляр Project
    func translate(rlmProject: RMProject) -> Project {
        let project = Project(id: rlmProject.id,
                              name: rlmProject.name)
        return project
    }
    
    
    // MARK: - Help

    func convertDateToStringFrom(date: Date) -> String {
        let dateFormatter = getDateFormatter()
        return dateFormatter.string(from: date)
    }
    

    func getDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter
    }

}
