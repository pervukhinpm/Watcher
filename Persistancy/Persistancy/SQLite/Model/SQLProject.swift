//
//  SQLProject.swift
//  Persistancy
//
//  Created by Петр Первухин on 19/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import SQLite

///Структура SQLProject для базы данных SQLLite
class SQLProject: SQLiteEntry {
    
    var id: Int64
    var name: String = ""
    
    var table: Table
    var createTable: String
    
    required init(id: Int64, table: Table) {
        self.table = table
        self.id = id
        
        self.createTable = self.table.create(ifNotExists: true) { (table) in
            table.column(Expression<Int64>("id"), primaryKey: true)
            table.column(Expression<String>("name"))
        }
    }
    
}
