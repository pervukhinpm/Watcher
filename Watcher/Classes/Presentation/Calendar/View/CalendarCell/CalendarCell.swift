//
//  CalendarCell.swift
//  Watcher
//
//  Created by Петр Первухин on 01/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit



final class CalendarCell: UICollectionViewCell {
   
    // MARK: - Constants

    static let identifier = "CalendarCellID"

    
    // MARK: - IBOutlet

    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var dayLabel: UILabel!    

    
    // MARK: - Public Properties

    public var dayColor: UIColor!

    override var isSelected: Bool { 
        didSet {
            isSelected ? selectCell() : resetCell()
            dayLabel.textColor = isSelected ? .white : dayColor
        }
    }
    
    override func awakeFromNib() {
        selectedView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
    }
    
    
    // MARK: - LifeCycle

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = 0.75 * self.contentView.bounds.size.width
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        selectedView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        selectedView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        selectedView.widthAnchor.constraint(equalToConstant: width).isActive = true
        selectedView.heightAnchor.constraint(equalToConstant: width).isActive = true
        
        selectedView.layer.cornerRadius = width / 2
        selectedView.clipsToBounds = true
    }
    
    
    // MARK: - Select Methods

    func resetCell() {
        selectedView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
    }
    
    
    func selectCell() {
        self.selectedView.backgroundColor = .orangeyRed
    }
    
}
