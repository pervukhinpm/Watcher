//
//  AppDataBase.swift
//  Watcher
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation
import GRDB

///Структура для настройки базы данных GRDB
struct AppDatabase {
        
    static let shared = AppDatabase()
    
    static var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("createLibrary") { db in
            try db.create(table: "grdbLoggedDay") { table in     
                table.column("id", .integer).primaryKey()
                table.column("date", .text).notNull()
                table.column("isWorking", .boolean).notNull().defaults(to: false)
            }
            
            try db.create(table: "grdbProject") { table in
                table.column("id", .integer).primaryKey()
                table.column("name", .text).notNull()
            }
            
            try db.create(table: "grdbLoggedTimeRecord") { table in
                table.column("id", .integer).primaryKey()
                table.column("date", .text).notNull()
                table.column("description", .text)
                table.column("minutesSpent", .integer).notNull()
                table.column("dateId", .integer)                    
                    .references("grdbLoggedDay", onDelete: .cascade)
                table.column("projectId", .integer)                               
                    .references("grdbProject") 
            }
        }
        return migrator
    }
    

    /// Открытие баззы данных GRDB по путю path
    ///
    /// - Parameter path: путь к базе данных GRDB
    /// - Throws: error если DatabaseQueue не может быть создана
    /// - Returns: DatabaseQueue для работы с базой данных GRDB
    static func openDatabase(atPath path: String) throws -> DatabaseQueue {
        let dbQueue = try DatabaseQueue(path: path)
        try migrator.migrate(dbQueue)
        return dbQueue
    }
    
}
