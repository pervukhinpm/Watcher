//
//  LoggedTimeRecordHeaderCell.swift
//  Watcher
//
//  Created by Петр Первухин on 19/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

class LoggedTimeRecordHeaderCell: UITableViewCell {
    
    // MARK: - Constants

    static let identifier = "LoggedTimeRecordHeaderCellID"

    
    // MARK: - IBOutlet

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var projectIdLabel: UILabel!
    @IBOutlet weak var minutesSpentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
}
