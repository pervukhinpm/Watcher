//
//  SQLiteDAO.swift
//  Watcher
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import Foundation
import SQLite

/// Класс для DAO для базы данных SQL
open class SQLiteDAO<Model: Entity, SQLiteModel: SQLiteEntry> : DAO<Model> {
    
    // MARK: - Private Properties
    
    private var translator: SQLiteTranslator<Model, SQLiteModel>
    private let sqliteTable: Table
    private var someEntry: SQLiteModel
    private var database: Connection!
    
    
    // MARK: - Initialization

    /// Создание нового экземпляра SQLiteDAO 
    ///
    /// - Parameter translator: translator для транслирование моделей
    /// - Parameter configuration: SQLiteConfiguration для конфигурирования базы данных
    public init(_ translator: SQLiteTranslator<Model, SQLiteModel>,
                configuration: SQLiteConfiguration = SQLiteConfiguration()) {
        self.translator = translator
        self.sqliteTable = Table(configuration.table)
        self.someEntry = SQLiteModel(id: 0, table: sqliteTable)
        super.init()
        loadSQLiteForTable(configuration.table)
        createTable()
    }
    
    
    // MARK: - Setup

    /// Загрузка таблицы SQLiteDAO 
    ///
    /// - Parameter tableName: название SQLite таблицы
    private func loadSQLiteForTable(_ tableName: String) {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, 
                                                                in: .userDomainMask,
                                                                appropriateFor: nil, 
                                                                create: true)
            let fileUrl = documentDirectory.appendingPathComponent(tableName).appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
    }
    
    
    /// Создание таблицы SQLiteDAO 
    private func createTable() {
        let createTable = someEntry.createTable
        do {
            try self.database.run(createTable)
        } catch {
            print(error)
        }
    }
    
    
    // MARK: - Insert/update
    
    /// Сохранение новой entity 
    ///
    /// - Parameter entity: entity которая должна быть сохранена
    /// - Throws: error если entity не может быть сохранена
    open override func persist(_ entity: Model) {
        let inserts = translator.fill(someEntry, fromEntity: entity)
        do {
            try database.run(inserts)
        } catch {
            print(error)
        }
    }
    
    
    /// Сохранение новых entitys
    ///
    /// - Parameter entities: entitys которые должны быть сохранены
    /// - Throws: error если entity не может быть сохранена
    open override func persist(_ entities: [Model]) {
        for entity in entities {
            persist(entity)
        }
    }

    
    // MARK: - Read
    
    /// Возвращает все entities из базы данных типа `Model`.
    ///
    /// - Returns: массив entities.
    open func readAll() -> [Model] {
        var rows = [Row]()
        do {
            rows = Array(try database.prepare(sqliteTable))
        } catch {
            print(error)
        }
        let models = translator.fill(fromEntries: rows)
        return models
    }
    
    
    /// Возвращает все entities из базы данных типа `Model`.
    ///
    /// - Parameter keys: идентификаторы по которым должна быть сделана выборка из базы данных
    /// - Parameter idExpression: id по которым может быть сделана выборка типа Expression<Int64> 
    /// - Returns: массив entities.
    open func readFilterBetween(keys: [Int64], idExpression: Expression<Int64>) -> [Model] {
        var rows = [Row]()
        do {
            rows = Array(try database.prepare(sqliteTable.filter(keys.contains(idExpression))))
        } catch {
            print(error)
        }
        let models = translator.fill(fromEntries: rows)
        return models
    }
    
    
    /// Возвращает все entities из базы данных типа `Model`.
    ///
    /// - Parameter id: идентификатор по которому должна быть сделана выборка из базы данных
    /// - Parameter expression: expression по которым может быть сделана выборка типа Expression<Int64> 
    /// - Returns: массив entities.
    open func reaWithId(expression: Expression<Int64>, id: Int64) -> [Model] {
        let entitys = someEntry.table.filter(expression == id)
        var rows = [Row]()
        do {
            rows = Array(try database.prepare(entitys))
        } catch {
            print(error)
        }        
        let models = translator.fill(fromEntries: rows)
        return models
        
    }
    
    
    // MARK: - Delete

    /// Удаляет все entities типа `Model`.
    open func deleteWithId(id: Int64) {
        let idToDelete = Expression<Int64>("id")
        let entityToDelete = someEntry.table.filter(idToDelete == id)
        do {
            try database.run(entityToDelete.delete())
        } catch {
            print(error)
        }
        
    }
    
    /// Удаляет все Entry типа `Model`.
    ///
    /// - Parameter id: идентификатор по которому должна быть удалена entry из базы данных
    /// - Parameter expression: expression по которому должно быть удаение типа Expression<Int64> 
    open func deleteWithId(id: Int64, expression: Expression<Int64>) {
        let entityToDelete = someEntry.table.filter(expression == id)
        do {
            try database.run(entityToDelete.delete())
        } catch {
            print(error)
        }
    }
    
    
    /// Удаляет все Entry типа `Model`.
    open func deleteAll () {
        let delete = sqliteTable.delete()
        do {
            try self.database.run(delete)
        } catch {
            print(error)
        }
    }

}
