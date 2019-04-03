//
//  SQLiteTranslator.swift
//  Watcher
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import Foundation
import SQLite

///Класс для транслирования моделей SQLite базы данных
open class SQLiteTranslator<Model: Entity, SQLiteModel: SQLiteEntry> {
    
    // MARK: - Fillig
    
    /// Все properties из строки Row таблицы SQLite будут перезаписаны в entry properties.
    ///
    /// - Parameters:
    /// - fromEntry: экземпляр типа `Row`.
    /// - Returns: массив entities.
    open func fill(fromEntry: Row) -> Model {
        fatalError("Abstract method")
    }
    
    
    /// Все properties из fromEntity будут перезаписаны в entry properties.
    ///
    /// - Parameters:
    /// - entry: экземпляр типа `SQLiteModel`.
    /// - fromEntity: экземпляр типа `Model`.
    /// - Returns: вставки Insert в базу данных SQLite.
    open func fill(_ entry: SQLiteModel, fromEntity: Model) -> Insert {
        fatalError("Abstract method")
    }
    
    
    /// Все properties из fromEntity будут перезаписаны в entry properties.
    ///
    /// - Parameters:
    /// - entry: экземпляр типа `SQLiteModel`.
    /// - fromEntity: экземпляр типа `Model`.
    /// - Returns: вставки Insert в базу данных SQLite.
    open func fill(fromEntries: [Row]) -> [Model] {
        var models = [Model]()
        for entry in fromEntries {
            models.append(fill(fromEntry: entry))
        }
        return models
    }
    
}
