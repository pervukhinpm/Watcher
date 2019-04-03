//
//  SpinerLayer.swift
//  Watcher
//
//  Created by Петр Первухин on 06/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class SpinerLayer: CAShapeLayer {
    
    // MARK: - Public Methods

    public var spinnerColor = UIColor.orangeyRed {
        didSet {
            strokeColor = spinnerColor.cgColor
        }
    }
    
    
    // MARK: - Initialization

    init(frame: CGRect) {
        super.init() 
        
        self.setToFrame(frame)
        
        self.fillColor = nil
        self.strokeColor = spinnerColor.cgColor
        self.lineWidth = 1
        
        self.strokeEnd = 0.4
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    
    // MARK: - Public Methods
    
    func setToFrame(_ frame: CGRect) {
        let radius: CGFloat = (frame.height / 2) * 0.5
        self.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
        let boundsCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let center = CGPoint(x: frame.height / 2, y: boundsCenter.y)
        let startAngle = 0 - Double.pi / 2
        let endAngle = Double.pi * 2 - Double.pi / 2
        let clockwise: Bool = true
        self.path = UIBezierPath(arcCenter: center,
                                 radius: radius, 
                                 startAngle: CGFloat(startAngle),
                                 endAngle: CGFloat(endAngle), 
                                 clockwise: clockwise).cgPath
    }
    

    public func animation() {
        self.isHidden = false
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = 0
        rotate.toValue = Double.pi * 2
        rotate.duration = 0.6
        rotate.timingFunction = CAMediaTimingFunction(name: .linear)
        
        rotate.repeatCount = HUGE
        rotate.fillMode = .forwards
        rotate.isRemovedOnCompletion = false
        self.add(rotate, forKey: rotate.keyPath)
        
    }
    
    public func stopAnimation() {
        self.isHidden = true
        self.removeAllAnimations()
    }
}
