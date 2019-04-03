//
//  SnapshotSwitcher.swift
//  Watcher
//
//  Created by Петр Первухин on 12/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation
import UIKit

final class SnapshotSwitcher {
    
    // MARK: Private Properties
    
    private var snapshotSwitcherWindow = UIWindow()
    private var snapshotSwitcherViewController = UIViewController()

    
    // MARK: Notifications
    
    private func addNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didEnterBackgroundNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.willEnterForegroundNotification,
                                                  object: nil)
    }
    
    @objc private func didEnterBackground() {
        showWindow()
    }
    
    @objc private func willEnterForeground() {
        hideWindow()
    }
    
    
    // MARK: Private Methods
    
    private func showWindow() {
        snapshotSwitcherWindow.makeKeyAndVisible()
    }
    
    
    private func hideWindow() {
        snapshotSwitcherWindow.isHidden = true
    }
    
    
    private func configureWindow() {
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 1
        blurEffectView.frame = UIScreen.main.bounds
        vc.view.addSubview(blurEffectView)
        snapshotSwitcherViewController = vc
        snapshotSwitcherWindow = UIWindow(frame: UIScreen.main.bounds)
        snapshotSwitcherWindow.rootViewController = snapshotSwitcherViewController
        snapshotSwitcherWindow.windowLevel = UIWindow.Level.alert + 1
    }
    
    
    // MARK: Public Methods
    
    public func setup() {
        configureWindow()
        addNotifications()
    }
    
}
