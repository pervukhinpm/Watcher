//
//  SQLiteEntry.swift
//  Watcher
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation
import SQLite

/// Протокол для моделей SQLiteEntry для базы данных SQL
public protocol SQLiteEntry {
    
    var id: Int64 { get set }
    var table: Table { get set }
    var createTable: String { get set }
    
    init(id: Int64, table: Table)
    
}
