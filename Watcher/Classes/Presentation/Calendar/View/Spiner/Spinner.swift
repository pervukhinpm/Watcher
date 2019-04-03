//
//  Spiner.swift
//  Watcher
//
//  Created by Петр Первухин on 06/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class Spiner: UIView {

    // MARK: - Private Properties

    private var spinerLayer: SpinerLayer?
    
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        spinerLayer = SpinerLayer(frame: self.frame)
        guard let spinerLayer = spinerLayer else { return }
        self.layer.addSublayer(spinerLayer)
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public Methods

    public func startAnimation() {
        self.isHidden = false
        UIApplication.shared.beginIgnoringInteractionEvents()
        spinerLayer?.animation()
    }
    
    public func stopAnimation() {
        self.isHidden = true
        UIApplication.shared.endIgnoringInteractionEvents()
        spinerLayer?.stopAnimation()
    }
    
}
