//
//  PinIndicator.swift
//  Watcher
//
//  Created by Петр Первухин on 08/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class PinIndicator: UIView {

    // MARK: - Draw 

    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }
    
    
    // MARK: - Public Methods

    public func animateFilling() {
        UIView.animate(withDuration: 2) { 
            self.backgroundColor = ColorThemeManager.shared.current.formFillingColor
        }
    }

    
    public func animateResetFilling() {
        UIView.animate(withDuration: 2) { 
            self.backgroundColor = ColorThemeManager.shared.current.formNonFillingColor
        }
    }
    
    
}
