//
//  LoggedDayViewModel.swift
//  Watcher
//
//  Created by Петр Первухин on 27/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

struct LoggedDayViewModel {
    var day: String
    var dateString: String
    var date: Date
    var isWorking: Bool
    var loggedTimeRecordViewModel: [LoggedTimeRecordViewModel]
}
