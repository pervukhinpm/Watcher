//
//  SugarHoneyIceTea.swift
//  Watcher
//
//  Created by Петр Первухин on 25/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import RealmSwift

///RMLoggedModelTranslator переводит модель ответа с сервера LoggedDay в модель базы данных Realm RMLoggedDay
open class RMLoggedModelTranslator {
        
    // MARK: - Fillig
    
    /// Все properties loggedDay будут перезаписаны в RMLoggedDay properties.
    ///
    /// - Parameters:
    /// - loggedDay: экземпляр типа loggedDay
    /// - Returns: экземпляр RMLoggedDay
    func translate(loggedDay: LoggedDay) -> RMLoggedDay {
        let rlmLoggedDay = RMLoggedDay()
        rlmLoggedDay.dateString = loggedDay.date
        rlmLoggedDay.date = convertStringToDateFrom(dateString: loggedDay.date)
        rlmLoggedDay.isWorking = loggedDay.isWorking
        rlmLoggedDay.loggedTimeRecords = translate(loggedTimeRecords: loggedDay.loggedTimeRecords)
        return rlmLoggedDay
    }
    
    
    /// Перевод [LoggedTimeRecord] будут перезаписаны в List<RMLoggedTimeRecord>
    ///
    /// - Parameters:
    /// - loggedTimeRecords: экземпляр типа [LoggedTimeRecord]
    /// - Returns: экземпляр List<RMLoggedTimeRecord>
    private func translate(loggedTimeRecords: [LoggedTimeRecord]) -> List<RMLoggedTimeRecord> {
        let rlmEntity = List<RMLoggedTimeRecord>()
        for record in loggedTimeRecords {
            let rlmRecord = RMLoggedTimeRecord()
            rlmRecord.projectId = record.project.id
            rlmRecord.id = record.id
            rlmRecord.minutesSpent = record.minutesSpent
            rlmRecord.project = translate(project: record.project) 
            rlmRecord.date = record.date
            rlmRecord.projectDescription = record.description
            rlmEntity.append(rlmRecord)
        }
        return rlmEntity
    }
    
    ///Перевод Project в RMProject
    
    /// Перевод Project будут перезаписаны в RMProject
    ///
    /// - Parameters:
    /// - project: экземпляр типа Project
    /// - Returns: экземпляр RMProject
    func translate(project: Project) -> RMProject {
        let rlmEntity = RMProject()
        rlmEntity.id = project.id
        rlmEntity.name = project.name
        return rlmEntity
    }
    
    
    // MARK: - Help

    func convertStringToDateFrom(dateString: String) -> Date {
        let dateFormatter = getDateFormatter()
        return dateFormatter.date(from: dateString)!
    }
    
    func getDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter
    }
    
}
