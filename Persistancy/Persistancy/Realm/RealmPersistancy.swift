//
//  Persistance.swift
//  Watcher
//
//  Created by Петр Первухин on 26/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import RealmSwift

///Класс для работы с базой данных Realm RealmPersistancy
open class RealmPersistancy: PersistancyProtocol {
   
    // MARK: - Initialization
    
    /// Создание экземпляра RealmPersistancy
    public init() {
    }
    
    
    // MARK: - PersistancyProtocol
    
    /// Сохранение Project в базу данных Realm
    ///
    /// - Parameter model: Project который должен быть сохранен
    public func saveProject(model: Project) {
        let realm = try? Realm()
        let rlmModel = RMLoggedModelTranslator().translate(project: model)
        try? realm?.write {
            realm?.add(rlmModel, update: true)
        }
    }
    
    
    /// Сохранение LoggedDay в базу данных Realm
    ///
    /// - Parameter model: LoggedDay который должен быть сохранен
    public func saveLoggedDay(model: LoggedDay) {
        let realm = try? Realm()
        let rlmModel = RMLoggedModelTranslator().translate(loggedDay: model)
        try? realm?.write {
            realm?.add(rlmModel, update: true)
        }
    }
    

    /// Загрузка LoggedDay за определенный период из базы данных Realm
    ///
    /// - Parameter startDate: Date начала периода 
    /// - Parameter endDate: Date конца периода
    /// - Returns: массив LoggedDays
    public func loadLoggedDay(startDate: Date, endDate: Date) -> LoggedDays {
        let realm = try? Realm()
        let events = realm!.objects(RMLoggedDay.self)
            .filter("date BETWEEN %@", [startDate, endDate]) 
            .sorted(byKeyPath: "date")
        return LoggedDaysTranslator().translate(rlmModel: events)
    }
    
    
    /// Загрузка всех LoggedDay из базы данных Realm
    ///
    /// - Returns: массив [LoggedDay]
    public func loadAllLoggedDays() -> [LoggedDay] {
        let realm = try? Realm()
        let events = realm!.objects(RMLoggedDay.self)
        return LoggedDaysTranslator().translate(rlmModel: events).days
    }
    
    
    /// Загрузка всех LoggedTimeRecord из базы данных Realm
    ///
    /// - Returns: массив [LoggedTimeRecord]
    public func loadAllLoggedTimeRecords() -> [LoggedTimeRecord] {
        let realm = try? Realm()
        let events = realm!.objects(RMLoggedTimeRecord.self)
        return LoggedDaysTranslator().translate(rlmLoggedTimeRecords: events)
    }
    
    
    /// Загрузка всех Project из базы данных Realm
    ///
    /// - Returns: массив [LoggedTimeRecord]
    public func loadAllProjects() -> [Project] {
        let realm = try? Realm()
        let events = realm!.objects(RMProject.self)
        var projects = [Project]()
        for project in Array(events) {
            projects.append(LoggedDaysTranslator().translate(rlmProject: project)) 
        }
        return projects
    }
    
}
