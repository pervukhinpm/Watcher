//
//  AnimationLineView.swift
//  Watcher
//
//  Created by Петр Первухин on 27/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

//UIView для отображения и анимации списанных часов в неделе
final class AnimateLineView: UIView {
    
    // MARK: - Private Properties

    private var overShapeLayer: CAShapeLayer! {
        didSet {
            overShapeLayer.lineWidth = 4
            overShapeLayer.lineCap = CAShapeLayerLineCap.square
            overShapeLayer.fillColor = nil
            overShapeLayer.strokeEnd = 0
            overShapeLayer.strokeColor = UIColor.cloudyBlue.cgColor
        }
    }
    

    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createOverShapeLayer()
        layer.addSublayer(overShapeLayer)
    }

    
    // MARK: - Creating Methods

    private func createOverShapeLayer() {
        overShapeLayer = createLineLayer(fromPoint: CGPoint(x: 0,
                                                            y: bounds.height / 2),
                                         toPoint: CGPoint(x: UIScreen.main.bounds.width - 32, 
                                                          y: bounds.height / 2))
    }
    
    
    private func createLineLayer(fromPoint: CGPoint, toPoint: CGPoint) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = bounds
        let path = UIBezierPath()
        path.move(to: fromPoint)
        path.addLine(to: toPoint)
        layer.path = path.cgPath
        return layer
    }
    
    
    // MARK: - Progress Animation Method

    public func progressAnimation(spentHours: CGFloat, workingHours: CGFloat) {
        var destination: CGFloat = 0
        destination = workingHours == 0 ? 0 : spentHours / workingHours
        overShapeLayer.lineWidth = destination == 0 ? 0 : 4
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = destination
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.fillMode = CAMediaTimingFillMode.both
        animation.isRemovedOnCompletion = false
        overShapeLayer.add(animation, forKey: nil)
    }
    
}
