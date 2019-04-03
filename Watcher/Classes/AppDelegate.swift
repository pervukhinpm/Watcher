//
//  AppDelegate.swift
//  Wathcer
//
//  Created by Петр Первухин on 13/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import RealmSwift
import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let snapshotSwitcher = SnapshotSwitcher()

    func application(_ application: UIApplication, 
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        registerSettingsBundle()
        setColorTheme()
        setNavigationBar()
        snapshotSwitcher.setup()
        showAuthViewController()
        
        return false
    }
    
    private func showAuthViewController() {
        let authVC = MainViewController()        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = authVC
        self.window?.makeKeyAndVisible()
        self.window?.backgroundColor = .charcoalGrey
    }
    
    private func registerSettingsBundle() {
        let appDefaults = [String: AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }
    
    
    private func setColorTheme() {
         if let colorTheme = UserDefaults.standard.object(forKey: SettingsBundleKeys.AppThemeKey) {
            guard let colorThemeInteger = colorTheme as? Int else { return }
            guard let theme = ColorTheme(rawValue: colorThemeInteger) else { return }
            switch theme {
            case .light:
                ColorThemeManager.shared.current = LightColorTheme()
            case .dark:
                ColorThemeManager.shared.current = DarkColorTheme()
            }
        }
    }

    
    private func setNavigationBar() {
        UINavigationBar.appearance().isTranslucent = false
        let navBarColor = ColorThemeManager.shared.current.navigationBarColor
        UINavigationBar.appearance().backgroundColor = navBarColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = navBarColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
}
