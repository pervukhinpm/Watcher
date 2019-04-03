//
//  LoggedDayHeaderCell.swift
//  Watcher
//
//  Created by Петр Первухин on 19/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

class LoggedDayHeaderCell: UITableViewCell {
    
    // MARK: - Constants

    static let identifier = "LoggedDayHeaderCellID"
    
    
    // MARK: - IBOutlet

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var isWorkingLabel: UILabel!
    
    
}
