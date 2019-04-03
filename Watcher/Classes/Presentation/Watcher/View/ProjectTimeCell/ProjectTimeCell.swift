//
//  ProjectTimeCell.swift
//  Watcher
//
//  Created by Петр Первухин on 22/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class ProjectTimeCell: UITableViewCell {
    
    // MARK: - Constants
    
    public static let identifier = "ProjectTimeCellID"
    
    
    // MARK: - IBOutlet

    @IBOutlet weak var loggedTimeLabel: UILabel!
    @IBOutlet weak var projectDescriptionLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    
    // MARK: - LifeCycle

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.clipsToBounds = true
        containerView.layer.borderColor = UIColor.cloudyBlue.cgColor
        containerView.layer.borderWidth = 1
        containerView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor

    }
    
    
}
