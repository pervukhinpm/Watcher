//
//  TimePickerCell.swift
//  Wathcer
//
//  Created by Петр Первухин on 17/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

protocol TimePickerCellDelegate: class {
    func updateViewWith(_ time: DateComponents)
}

final class TimePickerCell: UITableViewCell {

    // MARK: - Constants

    static let identifier = "TimePickerCellID"
    
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    // MARK: - Public Properties

    weak var delegate: TimePickerCellDelegate?
    
   
    // MARK: - awakeFromNib

    override func awakeFromNib() {
        super.awakeFromNib()
        datePicker.datePickerMode = .time
        datePicker.tintColor = ColorThemeManager.shared.current.mainTextColor
        datePicker.setValue(ColorThemeManager.shared.current.mainTextColor, forKey: "textColor")
        
        let calendar = Calendar(identifier: .gregorian)
        var timeComponents = DateComponents()
        
        // минимальное время
        timeComponents.hour = 0
        timeComponents.minute = 0
        let minTime = calendar.date(from: timeComponents)
        
        // максимальное время
        timeComponents.hour = 8
        timeComponents.minute = 0
        let maxTime = calendar.date(from: timeComponents)
        
        datePicker.minimumDate = minTime 
        datePicker.maximumDate = maxTime 
    }
    
    
    // MARK: - IBAction

    @IBAction private func timeDidChanged(_ sender: UIDatePicker) {
        let time = datePicker.calendar.dateComponents([.hour, .minute], from: datePicker.date)
        delegate?.updateViewWith(time)
    }
    
}
