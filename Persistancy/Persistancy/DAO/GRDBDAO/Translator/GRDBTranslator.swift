//
//  GRDBTranslator.swift
//  Watcher
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import Foundation
import GRDB

/// Родительский класс для GRDBTranslator
open class GRDBTranslator<Model: Entity, DBModel: GRDBEntry> {
    
    // MARK: - Initialization

    /// Создает экземпляр класса
    required public init() { }
    
    
    // MARK: - Fillig

    /// Все properties entity будут перезаписаны entry properties.
    ///
    /// - Parameters:
    ///   - entity: экземпляр типа `Entity`.
    ///   - fromEntry: экземпляр типа `GRDBEntry`.
    open func fill(_ entity: inout Model, fromEntry: DBModel) {
        fatalError("Abstact method")
    }


    /// Все properties entry будут перезаписаны entity properties.
    ///
    /// - Parameters:
    ///   - entry: экземпляр типа `GRDBEntry`.
    ///   - fromEntity: экземпляр типа `Entity`.
    open func fill(_ entry: inout DBModel, fromEntity: Model) {
        fatalError("Abstact method")
    }
    
}
