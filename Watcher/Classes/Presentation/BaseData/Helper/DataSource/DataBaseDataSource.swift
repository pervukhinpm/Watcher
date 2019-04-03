//
//  DataBaseDataSource.swift
//  Watcher
//
//  Created by Петр Первухин on 19/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import UIKit

class DataBaseDataSource: NSObject {

    // MARK: - Public Properties

    public var viewModel: DataBaseViewModel!
    
}

// MARK: - UITableViewDataSource

extension DataBaseDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = viewModel.cellModels[indexPath.row] 
        switch viewModel.type {
        case .project:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectHeaderCell.identifier,
                                                           for: indexPath) as? ProjectHeaderCell else {
                                                            return UITableViewCell()
            }
            guard let viewModel = cellModel as? Project else { return cell }
            cell.idLabel.text = String(viewModel.id)
            cell.nameLabel.text = viewModel.name
            cell.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
            return cell
        case .loggedDay:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoggedDayHeaderCell.identifier,
                                                           for: indexPath) as? LoggedDayHeaderCell else {
                                                            return UITableViewCell()
            }
            guard let viewModel = cellModel as? LoggedDay else { return cell }
            cell.dateLabel.text = viewModel.date
            cell.isWorkingLabel.text = viewModel.isWorking ? "true ": "false"
            cell.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
            return cell
        case .loggedTimeRecord:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoggedTimeRecordHeaderCell.identifier,
                                                           for: indexPath) as? LoggedTimeRecordHeaderCell else {
                                                            return UITableViewCell()
            }
            guard let viewModel = cellModel as? LoggedTimeRecord else { return cell }
            cell.dateLabel.text = viewModel.date
            cell.idLabel.text = String(viewModel.id)
            cell.projectIdLabel.text = String(viewModel.project.id)
            cell.minutesSpentLabel.text = String(viewModel.minutesSpent)
            cell.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
            return cell
        }
    }
    
}
