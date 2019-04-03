//
//  Font.swift
//  Watcher
//
//  Created by Петр Первухин on 07/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

private enum SourceSansProName: String {
    case light = "SourceSansPro-Light"
    case regular = "SourceSansPro-Regular"
    case semiBold = "SourceSansPro-SemiBold"
    case bold = "SourceSansPro-Bold"
}

extension UIFont {
    
    static var h1Font: UIFont {
        return sourceSansPro(.semiBold, size: 28)
    }
    
    static var b2Font: UIFont {
        return sourceSansPro(.bold, size: 18)
    }
    
    static var t1Font: UIFont {
        return sourceSansPro(.regular, size: 18)
    }
    
    static var t2Font: UIFont {
        return sourceSansPro(.regular, size: 16)
    }
    
    static var b1Font: UIFont {
        return sourceSansPro(.semiBold, size: 16)
    }
    
    static var b3Font: UIFont {
        return sourceSansPro(.bold, size: 16)
    }
    
    static var c1Font: UIFont {
        return sourceSansPro(.regular, size: 14)
    }
    
    private static func sourceSansPro(_ name: SourceSansProName,
                                      size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name.rawValue, size: size) else {
            print("Warning \(name.rawValue) not found")
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
        return font
    }
}
