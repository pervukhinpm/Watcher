//
//  GRDBLoggedTimeRecord.swift
//  Persistancy
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import GRDB

///Структура GRDBLoggedTimeRecord для базы данных GRDB
public struct GRDBLoggedTimeRecord: GRDBEntry {
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public var id: Int64 = 0
    public var dateId: Int64 = 0
    public var date: String = "" 
    public var description: String = ""
    public var minutesSpent: Int64 = 0
    public var projectId: Int64 = 0
    
    public init() {
    }
    
}

extension GRDBLoggedTimeRecord: Codable, FetchableRecord, MutablePersistableRecord {
    private enum CodingKeys: String, CodingKey, ColumnExpression {
        case minutesSpent, date, description, projectId, dateId, id
    }
    
    mutating public func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
    
}
