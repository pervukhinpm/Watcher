//
//  SQLoggedTimeRecord.swift
//  Persistancy
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import SQLite

///Структура SQLLoggedTimeRecord для базы данных SQLLite
class SQLLoggedTimeRecord: SQLiteEntry {
    
    var id: Int64
    var dateid: Int = 0
    var minutesSpent: Int64 = 0
    var description: String = ""    
    var projectId: Int64 = 0
    var projectName: String = ""
    var date: String = ""
    
    var table: Table
    var createTable: String
    
    required init(id: Int64, table: Table) {
        self.table = table
        self.id = id
        
        self.createTable = self.table.create(ifNotExists: true) { (table) in
            table.column(Expression<Int64>("id"), primaryKey: true)
            table.column(Expression<Int64>("dateId"))
            table.column(Expression<Int64>("minutesSpent"))
            table.column(Expression<Int64>("projectId"))
            table.column(Expression<String>("projectName"))
            table.column(Expression<String>("description"))
            table.column(Expression<String>("date"))
        }
    }
    
}
