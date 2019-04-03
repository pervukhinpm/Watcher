//
//  GRDBProject.swift
//  Persistancy
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import GRDB

///Структура GRDBProject для базы данных GRDB
public struct GRDBProject: GRDBEntry {
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public var id: Int64 = 0
    public var name: String = ""
    
    
    public init() {
    }
    
    
}

extension GRDBProject: Codable, FetchableRecord, MutablePersistableRecord {
    
    private enum CodingKeys: String, CodingKey, ColumnExpression {
        case id, name
    }
    
    mutating public func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
    
}
