//
//  GRDBDAO.swift
//  Watcher
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import GRDB
import UIKit

/// Класс для DAO для базы данных GRDB
open class GRDBDAO<Model: Entity, GRDBModel: GRDBEntry>: DAO<Model> {    
    
    // MARK: - Private Properties

    private let translator: GRDBTranslator<Model, GRDBModel>
    private let dbQueue: DatabaseQueue
    
    
    // MARK: - Initialization

    /// Иницализация GRDBDAO
    ///
    /// - Parameter dbQueue: DatabaseQueue для работы с базой данных
    /// - Parameter translator: translator для транслирование моделей
    public init(dbQueue: DatabaseQueue,
                translator: GRDBTranslator<Model, GRDBModel>) {
        self.translator = translator
        self.dbQueue = dbQueue
        super.init()
    }

    
    // MARK: - Insert/update

    /// Сохранение новой entity 
    ///
    /// - Parameter entity: entity которая должна быть сохранена
    /// - Throws: error если entity не может быть сохранена
    override open func persist(_ entity: Model) throws {
        var entry = GRDBModel()
        translator.fill(&entry, fromEntity: entity)
        try dbQueue.write { (db) in
            try entry.insert(db)
        }
    }
    
    
    /// Сохранение новых entitys
    ///
    /// - Parameter entities: entitys которые должны быть сохранены
    /// - Throws: error если entity не может быть сохранена
    open override func persist(_ entities: [Model]) throws {
        for entitie in entities {
            try self.persist(entitie)
        }
    }
    
    
    // MARK: - Read
    
    /// Возвращает все entities из базы данных типа `Model`.
    ///
    /// - Returns: массив entities.
    open override func read() -> [Model] {
        var entitys = [Model]()
        do {
            let dbModels = try dbQueue.read { db -> [GRDBModel] in
                return try GRDBModel.fetchAll(db)      
            }
            for dbModel in dbModels {
                var entity = Model()
                translator.fill(&entity, fromEntry: dbModel)
                entitys.append(entity)
            }
            return entitys
        } catch {
            print(error)
        }
        return entitys
    }
    
    
    /// Возвращает все entities из базы данных типа `Model`.
    ///
    /// - Parameter keys: идентификаторы по которым должна быть сделана выборка из базы данных
    /// - Returns: массив entities.
    open func readFilterBetween(keys: [Int64]) -> [Model] {
        var entitys = [Model]()
        do {
            let dbModels = try dbQueue.read { db -> [GRDBModel] in
                let request = GRDBModel.filter(keys: keys)
                return try request.fetchAll(db)
            }
            for dbModel in dbModels {
                var entity = Model()
                translator.fill(&entity, fromEntry: dbModel)
                entitys.append(entity)
            }
            return entitys
        } catch {
            print(error)
        }
        return entitys
    }
    
    
    // MARK: - Delete
    
    /// Удаляет все entities типа `Model`.
    ///
    /// - Throws: error если entity не может быть удалена
    open override func erase() {
        do {
            _ = try dbQueue.write { (db) in
                try GRDBModel.deleteAll(db)
            }
        } catch {
            print(error)
        }
    }
    
        
    /// Удаляет entitie по идентификатору.
    ///
    /// - Parameter id: идентификатор по которому должна быть удалена entitie из базы данных
    open func eraseById(id: Int64) {
        do {
            _ = try dbQueue.write { (db) in
                try GRDBModel.deleteOne(db, key: id)
            }
        } catch {
            print(error)
        }
    }
}
