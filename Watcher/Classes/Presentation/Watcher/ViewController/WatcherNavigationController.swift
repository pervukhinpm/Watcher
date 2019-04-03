//
//  WatcherNavigationController.swift
//  Watcher
//
//  Created by Петр Первухин on 22/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class WatcherNavigationController: UINavigationController {

    // MARK: - Properties

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    // MARK: - LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
}
