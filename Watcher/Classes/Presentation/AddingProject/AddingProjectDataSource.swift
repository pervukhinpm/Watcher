//
//  AddingProjectDataSource.swift
//  Wathcer
//
//  Created by Петр Первухин on 17/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

enum ProjectCellType {
    case timeInfoCell
    case timePickerCell
    case logTimeDescriptionCell
}

final class AddingProjectDataSource: NSObject {
    
    // MARK: - Properties

    weak var viewController: AddingProjectViewController?
    public var cellTypes: [ProjectCellType] = [.timeInfoCell, .timePickerCell, .logTimeDescriptionCell]
    
}


// MARK: - UITableViewDataSource

extension AddingProjectDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cellTypes[indexPath.row]
        switch cellType {
        case .timeInfoCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TimeInfoCell.identifier, 
                                                           for: indexPath) as? TimeInfoCell else {
                                                            return UITableViewCell() 
            }
            cell.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
            return cell
        case .timePickerCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TimePickerCell.identifier, 
                                                           for: indexPath) as? TimePickerCell else {
                                                            return UITableViewCell() 
            }
            cell.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
            cell.delegate = viewController
            return cell
        case .logTimeDescriptionCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LogTimeDescriptionCell.identifier, 
                                                           for: indexPath) as? LogTimeDescriptionCell else {
                                                            return UITableViewCell() 
            }
            cell.selectionStyle = .none
            cell.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
            cell.delegate = viewController
            return cell
        }
    }
        
}
