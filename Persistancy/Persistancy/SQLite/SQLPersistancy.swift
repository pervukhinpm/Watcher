//
//  SQLPersistancy.swift
//  Persistancy
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import SQLite

///Класс для работы с базой данных SQLPersistancy
open class SQLPersistancy: PersistancyProtocol {

    // MARK: - Private Properties

    private let daoLoggedDay = SQLiteDAO<LoggedDay, SQLLoggedDay> (
        SQLoggedDayTranslator(),
        configuration: SQLiteConfiguration(table: "SQLLoggedDayTable",                                       
                                           temporary: false))
    
    private let daoTimeRecord = SQLiteDAO<LoggedTimeRecord, SQLLoggedTimeRecord> (
        SQLoggedTimeRecordTranslator(),
        configuration: SQLiteConfiguration(table: "SQLLoggedTimeRecordTable",
                                           temporary: false))
    
    private let daoProject = SQLiteDAO<Project, SQLProject> (
        SQLProjectTranslator(),
        configuration: SQLiteConfiguration(table: "SQLProject",
                                           temporary: false))
    
    
    // MARK: - Initialization

    /// Создание экземпляра SQLPersistancy
    public init() {
        
    }
    
    
    // MARK: - PersistancyProtocol
    
    /// Сохранение Project в базу данных SQLite
    ///
    /// - Parameter model: Project который должен быть сохранен
    public func saveProject(model: Project) {
        daoProject.deleteWithId(id: Int64(model.id))
        daoProject.persist(model)
    }
    
    
    /// Сохранение LoggedDay в базу данных SQLite
    ///
    /// - Parameter model: LoggedDay который должен быть сохранен
    public func saveLoggedDay(model: LoggedDay) {        
        let dateId = Expression<Int64>("dateId")
        let id = getDateIdFrom(dateString: model.date)
        daoLoggedDay.deleteWithId(id: id)
        daoTimeRecord.deleteWithId(id: id, expression: dateId)
        daoLoggedDay.persist(model)
        daoTimeRecord.persist(model.loggedTimeRecords)
    }
    
    
    /// Загрузка LoggedDay за определенный период из базу данных SQLite
    ///
    /// - Parameter startDate: Date начала периода 
    /// - Parameter endDate: Date конца периода
    /// - Returns: массив LoggedDays
    public func loadLoggedDay(startDate: Date, endDate: Date) -> LoggedDays {

        let keys = convertPeriodToKeys(startDate: startDate, endDate: endDate)
        let dateId = Expression<Int64>("dateId")
        let id = Expression<Int64>("id")

        let loggedDaysResult = daoLoggedDay.readFilterBetween(keys: keys, idExpression: id)
       
        for loggedDay in loggedDaysResult {
            let index = getDateIdFrom(dateString: loggedDay.date)
            loggedDay.loggedTimeRecords = daoTimeRecord.reaWithId(expression: dateId, id: index)
        }
        
        return LoggedDays(days: loggedDaysResult)
    }
    
    
    /// Загрузка всех LoggedDay из базу данных SQLite
    ///
    /// - Returns: массив [LoggedDay]
    public func loadAllLoggedDays() -> [LoggedDay] {
        return daoLoggedDay.readAll()
    }
    
    
    /// Загрузка всех LoggedTimeRecord из базу данных SQLite
    ///
    /// - Returns: массив [LoggedTimeRecord]
    public func loadAllLoggedTimeRecords() -> [LoggedTimeRecord] {
        return daoTimeRecord.readAll()

    }
    
    
    /// Загрузка всех Project из базу данных SQLite
    ///
    /// - Returns: массив [LoggedTimeRecord]
    public func loadAllProjects() -> [Project] {
        return daoProject.readAll()
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
