//
//  SettingsBundleHelper.swift
//  Watcher
//
//  Created by Петр Первухин on 19/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

enum DataBaseType: String {
    case grdb = "0"
    case sqlite = "1"
    case realm = "2"
}

enum ColorTheme: Int {
    case light = 0
    case dark = 1
}

struct SettingsBundleKeys {
    static let AppThemeKey = "app_theme"
    static let BaseDataKey = "base_data"
}
