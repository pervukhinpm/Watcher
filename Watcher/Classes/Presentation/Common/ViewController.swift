//
//  ViewController.swift
//  Watcher
//
//  Created by Петр Первухин on 06/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Private Properties

    private let progressHUD = ProgressHUD()

    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgressHUD()
    }
    

    // MARK: - Setup Methods
    
    private func setupProgressHUD() {
        view.addSubview(progressHUD)
        progressHUD.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressHUD.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressHUD.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            progressHUD.heightAnchor.constraint(equalToConstant: 100),
            progressHUD.widthAnchor.constraint(equalToConstant: 100)])
        progressHUD.hide()
    }
  
    
    // MARK: - Public Methods

    public func showIndicator() {
        progressHUD.show()
    }
    
    
    public func hideIndicator() {
        progressHUD.hide()
    }
    
}
