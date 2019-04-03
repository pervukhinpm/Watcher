//
//  ThemeManager.swift
//  Watcher
//
//  Created by Петр Первухин on 20/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

class ColorThemeManager {
    
    static let shared = ColorThemeManager()
    
    var current: ColorThemeProtocol = LightColorTheme()
    
}
