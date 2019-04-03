//
//  RMLoggedDay.swift
//  Watcher
//
//  Created by Петр Первухин on 25/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import RealmSwift

///Модель для базы данных Realm RMLoggedDay
@objcMembers public class RMLoggedDay: Object {

    // MARK: - Properties

    dynamic var dateString: String = ""
    dynamic var date = Date()    
    dynamic var isWorking: Bool = false
    var loggedTimeRecords = List<RMLoggedTimeRecord>()
    
    
    // MARK: - primaryKey
    
    override public static func primaryKey() -> String? {
        return "dateString"
    }
    
}
