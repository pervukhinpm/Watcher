//
//  GRDBEntry.swift
//  Watcher
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation
import GRDB

/// Родительский класс GRDBEntry
public protocol GRDBEntry: Codable, FetchableRecord, MutablePersistableRecord {
    init()
}
