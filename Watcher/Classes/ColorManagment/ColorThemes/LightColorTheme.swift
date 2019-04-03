//
//  LightColorTheme.swift
//  Watcher
//
//  Created by Петр Первухин on 20/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

class LightColorTheme: ColorThemeProtocol {

    // MARK: - Background
    
    var mainBackgroundColor = UIColor.white
    var messageBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    var textViewBackgroundColor = #colorLiteral(red: 0.831372549, green: 0.8509803922, blue: 0.8745098039, alpha: 0.3)
    
    
    // MARK: - NavigationBar
    
    var navigationBarColor = UIColor.charcoalGrey
    
    
    // MARK: - Text
    
    var mainTextColor = UIColor.charcoalGrey
    
    
    // MARK: - Filling
    
    var formNonFillingColor = UIColor.cloudyBlue
    var formFillingColor = UIColor.charcoalGrey
    var animatedLineNonFillingColor = #colorLiteral(red: 0.9333333333, green: 0.9411764706, blue: 0.9490196078, alpha: 1)
    
}
