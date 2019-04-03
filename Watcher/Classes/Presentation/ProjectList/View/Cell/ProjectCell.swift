//
//  ProjectCell.swift
//  Wathcer
//
//  Created by Петр Первухин on 13/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class ProjectCell: UITableViewCell {
    
    // MARK: - Constants

    static let identifier = "ProjectCellID"
    
    
    // MARK: - IBOutlet

    @IBOutlet private weak var projectNameLabel: UILabel!

    
    // MARK: - Properties

    var viewModel: ProjectViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            projectNameLabel.text = viewModel.name
        }
    }
    
}
