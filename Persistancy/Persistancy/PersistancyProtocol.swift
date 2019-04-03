//
//  PersistancyProtocol.swift
//  Persistancy
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient

public protocol PersistancyProtocol {
    func saveLoggedDay(model: LoggedDay)
    func saveProject(model: Project)
    func loadLoggedDay(startDate: Date, endDate: Date) -> LoggedDays
    func loadAllLoggedDays() -> [LoggedDay]
    func loadAllLoggedTimeRecords() -> [LoggedTimeRecord]
    func loadAllProjects() -> [Project]
}
