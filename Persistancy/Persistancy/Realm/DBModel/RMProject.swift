//
//  RMProject.swift
//  Persistancy
//
//  Created by Петр Первухин on 20/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import RealmSwift

///Модель для базы данных Realm RMProject
@objcMembers class RMProject: Object {
    
    // MARK: - Properties
    
    dynamic var id: Int = 0 
    dynamic var isCommercial: Bool = false 
    dynamic var isArchived: Bool = false 
    dynamic var name: String = ""
    
    // MARK: - primaryKey
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
}
