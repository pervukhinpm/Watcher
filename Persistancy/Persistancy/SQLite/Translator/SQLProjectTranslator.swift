//
//  SQLProjectTranslator.swift
//  Persistancy
//
//  Created by Петр Первухин on 19/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import SQLite

///Класс транслятор для моделей Project и SQLProject
class SQLProjectTranslator: SQLiteTranslator<Project, SQLProject> {
    
    // MARK: - Private Properties

    private let id = Expression<Int64>("id")
    private let name = Expression<String>("name")
    
    
    // MARK: - Filling

    open override func fill(fromEntry: Row) -> Project {
        let project = Project(id: Int(fromEntry[id]),
                              name: fromEntry[name])        
        return project
    }
    
    open  override func fill(_ entry: SQLProject, fromEntity: Project) -> Insert {
        let insert = entry.table.insert(id <- Int64(fromEntity.id), 
                                        name <- fromEntity.name)
        return insert
    }
    
}
