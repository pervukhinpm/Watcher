//
//  ProgressHUD.swift
//  Wathcer
//
//  Created by Петр Первухин on 13/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

///UIView с activityIndicator.Имеет методы начала и остановки анимации
final class ProgressHUD: UIView {

    // MARK: - Properties

    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(
        style: UIActivityIndicatorView.Style.white)
        
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    // MARK: - Setup

    private func setup() {
        addSubview(activityIndicator)
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    
    // MARK: - didMoveToSuperview

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50)])
        
        layer.cornerRadius = 6
        layer.masksToBounds = true
    }
    
    
    // MARK: - Show And Hide Methods

    ///Метод начала анимации и beginIgnoringInteractionEvents
    public func show() {
        self.isHidden = false
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    
    ///Метод остановки анимации и endIgnoringInteractionEvents
    public func hide() {
        self.isHidden = true
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
