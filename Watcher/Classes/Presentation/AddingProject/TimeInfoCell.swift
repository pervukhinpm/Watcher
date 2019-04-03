//
//  ProjectTimeCell.swift
//  Wathcer
//
//  Created by Петр Первухин on 17/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class TimeInfoCell: UITableViewCell {

    // MARK: - Constants
    
    static let identifier = "TimeInfoCellID"
        
    
    // MARK: - IBOutlet

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeDescriptionLabel: UILabel!
    
}
