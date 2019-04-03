//
//  CalendarViewModel.swift
//  Watcher
//
//  Created by Петр Первухин on 06/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

struct CalendarViewModel {
    var date: Date
    var day: String
    var isWorking: Bool
    var isBlank: Bool
    var isSelected: Bool
}

extension CalendarViewModel: Equatable {
    static public func == (lhs: CalendarViewModel, rhs: CalendarViewModel) -> Bool {
        if lhs.date == rhs.date {
            return true
        } else {
            return false
        }
    }
}
