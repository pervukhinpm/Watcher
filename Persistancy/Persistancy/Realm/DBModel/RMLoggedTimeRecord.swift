//
//  RMLoggedTimeRecord.swift
//  Persistancy
//
//  Created by Петр Первухин on 20/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import RealmSwift

///Модель для базы данных Realm RMLoggedTimeRecord
@objcMembers class RMLoggedTimeRecord: Object {
    
    // MARK: - Properties
    
    dynamic var projectId: Int = 0 
    dynamic var id: Int = 0 
    dynamic var minutesSpent: Int = 0 
    dynamic var project: RMProject? 
    dynamic var date: String = "" 
    dynamic var status: String = "" 
    dynamic var projectDescription: String = "" 
    dynamic var createdAt: String = "" 
    dynamic var updatedAt: String = "" 
    dynamic var comments: String = ""
    
    
    // MARK: - primaryKey
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
}
