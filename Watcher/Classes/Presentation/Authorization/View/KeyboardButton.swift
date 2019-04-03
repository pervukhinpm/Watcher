//
//  keyboardButton.swift
//  Watcher
//
//  Created by Петр Первухин on 08/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class KeyboardButton: UIButton {
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    
    // MARK: - Draw 
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
        layer.borderColor = UIColor.orangeyRed.cgColor
        layer.borderWidth = 1
    }
    
    
    // MARK: - Setup Methods

    func setupButton() {
        setTitleColor(ColorThemeManager.shared.current.mainTextColor, for: .normal)
        backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        titleLabel?.font = UIFont.t1Font
    }

}
