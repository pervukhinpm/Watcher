//
//  DAO.swift
//  Watcher
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import Foundation

/// Родительский класс для DAO 
open class DAO<Model: Entity> {
    
    // MARK: - Insert/update
    
    /// Сохранение новой entity 
    ///
    /// - Parameter entity: entity которая должна быть сохранена
    /// - Throws: error если entity не может быть сохранена
    open func persist(_ entity: Model) throws {
        preconditionFailure()
    }
    
    
    /// Сохранение новых entitys
    ///
    /// - Parameter entities: entitys которые должны быть сохранены
    /// - Throws: error если entity не может быть сохранена
    open func persist(_ entities: [Model]) throws {
        preconditionFailure()
    }
    
    
    // MARK: - Read
    
    /// Чтение entity из базы данных
    ///
    /// - Parameter entityId: entity идентификатор.
    /// - Returns: entity или nil.
    open func read(_ entityId: String) -> Model? {
        preconditionFailure()
    }
    
    
    /// Возвращает все entities из базы данных типа `Model`.
    ///
    /// - Returns: массив entities.
    open func read() -> [Model] {
        preconditionFailure()
    }
    
    // MARK: - Delete
    
    /// Удаляет все entities типа `Model`.
    ///
    /// - Throws: error если entity не может быть удалена
    open func erase() throws {
        preconditionFailure()
    }
    
    
    /// Удаляет entity типа `Model` по идентификатору.
    ///
    /// - Throws: error если entitie не может быть удалена
    open func erase(_ entityId: String) throws {
        preconditionFailure()
    }
    
}
