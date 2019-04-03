//
//  GRDBModel.swift
//  Watcher
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//


import Foundation
import GRDB

///Структура GRDBLoggedDay для базы данных GRDB
public struct GRDBLoggedDay: GRDBEntry {
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public var id: Int64 = 0
    public var date: String = ""
    public var isWorking: Bool = false
    
    
    public init() {
    }
    
}

extension GRDBLoggedDay: Codable, FetchableRecord, MutablePersistableRecord {
    
    private enum CodingKeys: String, CodingKey, ColumnExpression {
        case id, date, isWorking
    }
    
    mutating public func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}  

extension GRDBLoggedDay {
    static let grdbLoggedTimeRecords = hasMany(GRDBLoggedTimeRecord.self)
    var grdbLoggedTimeRecords: QueryInterfaceRequest<GRDBLoggedTimeRecord> {
        return request(for: GRDBLoggedDay.grdbLoggedTimeRecords)
    }
}
