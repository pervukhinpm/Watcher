//
//  AuthorizationRouter.swift
//  Wathcer
//
//  Created by Петр Первухин on 13/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class AuthorizationRouter {
    
    // MARK: - Private Properties

    private weak var viewController: UIViewController?
    
    
    // MARK: - Initialization

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Public Methods

    public func showWatcherViewController() {
        let navVC = WatcherNavigationController(rootViewController: WatcherViewController())
        navVC.modalTransitionStyle = .crossDissolve
        viewController?.present(navVC, animated: true, completion: nil)
    }
    
}
