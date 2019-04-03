//
//  SQLLoggedDay.swift
//  Watcher
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import SQLite

///Структура SQLLoggedDay для базы данных SQLLite
class SQLLoggedDay: SQLiteEntry {
    
    var id: Int64
    var date: String = ""
    var isWorking: Bool = false
    
    var table: Table
    var createTable: String
    
    required init(id: Int64, table: Table) {
        self.table = table
        self.id = id
        
        self.createTable = self.table.create(ifNotExists: true) { (table) in
            table.column(Expression<Int64>("id"), primaryKey: true)
            table.column(Expression<String>("date"))
            table.column(Expression<Bool>("isWorking"))
        }
    }
    
}
