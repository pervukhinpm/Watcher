//
//  DateBaseViewModel.swift
//  Watcher
//
//  Created by Петр Первухин on 19/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

enum DataBaseViewModelType {
    case project
    case loggedDay
    case loggedTimeRecord
}

struct DataBaseViewModel {
    var type: DataBaseViewModelType
    var cellModels: [Any]
}
