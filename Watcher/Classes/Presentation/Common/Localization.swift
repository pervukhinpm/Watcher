//
//  Localization.swift
//  Wathcer
//
//  Created by Петр Первухин on 13/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

/// Возвращает локализованную строку по ключу
public func ls(_ name: String) -> String {
    return NSLocalizedString(name, comment: "")
}
