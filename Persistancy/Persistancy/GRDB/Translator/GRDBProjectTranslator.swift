//
//  GRDBProjectTranslator.swift
//  Watcher
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import GRDB

///Класс транслятор для моделей Project и GRDBProject
open class GRDBProjectTranslator: GRDBTranslator<Project, GRDBProject> {
    
    open override func fill(_ entity: inout Project, fromEntry: GRDBProject) {
        entity.id = Int(fromEntry.id)
        entity.name = fromEntry.name
    }
    
    open override func fill(_ entry: inout GRDBProject, fromEntity: Project) {
        entry.id = Int64(fromEntity.id)
        entry.name = fromEntity.name
    }
    
}
