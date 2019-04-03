//
//  ColorThemeProtocol.swift
//  Watcher
//
//  Created by Петр Первухин on 20/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

protocol ColorThemeProtocol {
    
    // MARK: - Background
    
    var mainBackgroundColor: UIColor { get set }
    var messageBackgroundColor: UIColor { get set }
    var textViewBackgroundColor: UIColor { get set }
    
    
    // MARK: - NavigationBar
    
    var navigationBarColor: UIColor { get set }
    
    
    // MARK: - Text
    
    var mainTextColor: UIColor { get set }
    
    
    // MARK: - Filling
    
    var formNonFillingColor: UIColor { get set }
    var formFillingColor: UIColor { get set }
    var animatedLineNonFillingColor: UIColor { get set }
    
}
