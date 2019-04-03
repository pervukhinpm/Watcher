//
//  GRDBPersistancy.swift
//  Persistancy
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import GRDB
import RealmSwift

///Класс для работы с базой данных GRDBPersistancy
open class GRDBPersistancy: PersistancyProtocol {
    
    // MARK: - Private Properties

    private var dbQueue: DatabaseQueue!

    private lazy var daoLoggedDay = GRDBDAO<LoggedDay, GRDBLoggedDay>(dbQueue: dbQueue,
                                                              translator: GRDBLoggedDayTranslator(dbQueue: dbQueue))  
    private lazy var daoProject = GRDBDAO<Project, GRDBProject> (dbQueue: dbQueue,
                                                         translator: GRDBProjectTranslator())
    private lazy var daoLoggedTimeRecord = GRDBDAO<LoggedTimeRecord, GRDBLoggedTimeRecord>(
        dbQueue: dbQueue,
        translator: GRDBLoggedTimeRecordTranslator(dbQueue: dbQueue))
    
    
    // MARK: - Initialization
    
    /// Создание экземпляра GRDBPersistancy
    public init() {
        do {
            try dbQueue = setupDatabase()
        } catch {
            fatalError()
        }
    }
    

    // MARK: - Setup
    
    /// Настройка базы данных GRDB 
    ///
    /// - Throws: error если DatabaseQueue не может быть создана 
    /// - Returns: DatabaseQueue для работы с базой данных
    private func setupDatabase() throws -> DatabaseQueue {
        let databaseURL = try FileManager.default.url(for: .applicationSupportDirectory, 
                                                      in: .userDomainMask,
                                                      appropriateFor: nil, 
                                                      create: true).appendingPathComponent("db.sqlite")
        dbQueue = try AppDatabase.openDatabase(atPath: databaseURL.path)
        dbQueue.setupMemoryManagement(in: UIApplication.shared)
        return dbQueue
    }
    
    
    // MARK: - PersistancyProtocol

    /// Сохранение Project в базу данных GRDB
    ///
    /// - Parameter model: Project который должен быть сохранен
    public func saveProject(model: Project) {
        do {
            try daoProject.persist(model)
        } catch {
            print("daoProject persist error: ", error)
        }
    }
    
    
    /// Сохранение LoggedDay в базу данных GRDB
    ///
    /// - Parameter model: LoggedDay который должен быть сохранен
    public func saveLoggedDay(model: LoggedDay) {
        do {
            try daoLoggedDay.persist(model)
            for loggedTimeRecord in model.loggedTimeRecords {
                try daoProject.persist(loggedTimeRecord.project)
                try daoLoggedTimeRecord.persist(loggedTimeRecord)
            }
        } catch {
            print("daoLoggedDay persist error: ", error)
        }
    }
    
    
    /// Загрузка LoggedDay за определенный период
    ///
    /// - Parameter startDate: Date начала периода 
    /// - Parameter endDate: Date конца периода
    /// - Returns: массив LoggedDays
    public func loadLoggedDay(startDate: Date, endDate: Date) -> LoggedDays {
        let keys = convertPeriodToKeys(startDate: startDate, endDate: endDate)
                
        let loggedDayArray = daoLoggedDay.readFilterBetween(keys: keys)
        let loggedDays = LoggedDays(days: loggedDayArray)
        return loggedDays
    }
    
    
    /// Загрузка всех LoggedDay
    ///
    /// - Returns: массив [LoggedDay]
    public func loadAllLoggedDays() -> [LoggedDay] {
        return daoLoggedDay.read()
    }
    
    
    /// Загрузка всех LoggedTimeRecord
    ///
    /// - Returns: массив [LoggedTimeRecord]
    public func loadAllLoggedTimeRecords() -> [LoggedTimeRecord] {
        return daoLoggedTimeRecord.read()
    }
    
    
    /// Загрузка всех Project
    ///
    /// - Returns: массив [LoggedTimeRecord]
    public func loadAllProjects() -> [Project] {
        return daoProject.read()
    }
    
    
    // MARK: - Private Methods

    /// Перевод периода дат в массив ключей
    ///
    /// - Parameter startDate: Date начала периода
    /// - Parameter endDate: Date конца периода
    /// - Returns: массив ключей [Int64]
    private func convertPeriodToKeys(startDate: Date, endDate: Date) -> [Int64] {
        var keys = [Int64]()
        
        let dateRange = datesRange(from: startDate, to: endDate)
        
        for date in dateRange {
            let timeInterval = date.timeIntervalSince1970
            let dateId = Int64(timeInterval)
            keys.append(dateId)
        }
        
        return keys
    }
    
    
    /// Перевод даты типа 'String' в ключ Int64
    ///
    /// - Parameter dateString: Date начала периода
    /// - Returns: ключ Int64
    private func getDateIdFrom(dateString: String) -> Int64 {
        let someDate = Date.convertStringToDateFrom(dateString: dateString)
        let timeInterval = someDate.timeIntervalSince1970
        let dateId = Int64(timeInterval)
        return dateId
    }
    
    
    /// Перевод периода дат в массив дат [Date]
    ///
    /// - Parameter from: Date начала периода
    /// - Parameter to: Date конец периода
    /// - Returns: массив дат [Date]
    private func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        var tempDate = from
        var array = [tempDate]
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }
    
}
