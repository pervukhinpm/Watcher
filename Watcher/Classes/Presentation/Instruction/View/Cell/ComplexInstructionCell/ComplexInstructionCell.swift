//
//  InstructionComplexCell.swift
//  Watcher
//
//  Created by Петр Первухин on 19/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class ComplexInstructionCell: UITableViewCell {
    
    // MARK: - Constants

    static let identifier = "ComplexInstructionCellID"
    
    
    // MARK: - IBOutlet

    @IBOutlet weak var activityTextLabel: UILabel!
    @IBOutlet weak var timeLogTextLabel: UILabel!
    @IBOutlet weak var verifiesTextLabel: UILabel!
    
    
}
