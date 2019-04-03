//
//  ProjectModel.swift
//  Wathcer
//
//  Created by Петр Первухин on 13/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

///Сруктура ответа сервера при запросе списка проектов /projects/
public class ProjectData: Codable {
    public var projects: [Project]
    
    public init(projects: [Project]) {
        self.projects = projects       
    }
}

public class Project: Entity, Codable {
    
    public var id: Int
    public var name: String
    
    public init(id: Int, 
                name: String) {
        self.id = id
        self.name = name        
    }
    
    required public init() {
        self.id = 0
        self.name = "name"
    }
    
}

///Extension структуры Project для сравнения двух проектов
extension Project: Equatable {
    static public func == (lhs: Project, rhs: Project) -> Bool {
        if lhs.id == rhs.id,
            lhs.name == rhs.name {
            return true
        } else {
            return false
        }
    }
}
