//
//  ClearButton.swift
//  Watcher
//
//  Created by Петр Первухин on 20/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

class ClearButton: UIButton {

    // MARK: - Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let textColor = ColorThemeManager.shared.current.mainTextColor
        self.setTitleColor(textColor, for: .normal)
        self.titleLabel?.font = UIFont.t1Font
        self.backgroundColor = .clear
    }
    
}
