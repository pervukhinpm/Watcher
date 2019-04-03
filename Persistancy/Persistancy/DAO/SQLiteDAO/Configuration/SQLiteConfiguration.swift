//
//  SQLiteConfiguration.swift
//  Watcher
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation
import SQLite

///Класс для конфигурирования SQLite базы данных
public struct SQLiteConfiguration {
    
    // MARK: - Private Properties

    public let temporary: Bool
    public let table: String
    
    // MARK: - Initialization
    
    /// Создание нового экземпляра SQLiteConfiguration 
    ///
    /// - Parameter table: название таблицы.По умолчанию "TableName"
    /// - Parameter temporary: Параметр для определения временно сохранять в базе данных или нет.
    /// По умолчанию false
    public init(table: String = "TableName",
                temporary: Bool = false) {
        self.table = table
        self.temporary = temporary
    }
    
}
