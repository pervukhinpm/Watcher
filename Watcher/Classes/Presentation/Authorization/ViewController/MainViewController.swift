//
//  MainViewController.swift
//  Watcher
//
//  Created by Петр Первухин on 11/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import KeychainSwift
import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var containerView: UIView!
    
    
    // MARK: - Private Properties
    
    private var authorizationRouter: AuthorizationRouter?
    private lazy var authorizationViewController = AuthorizationViewController()
    private lazy var pinCodeViewController = PinCodeViewController()
    private var securityService = ServiceLayer.shared.securityService
    private var authorizationCheckService = ServiceLayer.shared.authorizationCheckService
    private var dateBackground: Date?
    
    private lazy var dimmingView: UIView = {
        let view = UIView(frame: self.view.bounds)
        view.isHidden = true
        view.alpha = 0
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        return view
    }()
    
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        authorizationRouter = AuthorizationRouter(viewController: self)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        containerView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        
        addNotifications()
        if JaibreakDetection.jailbroken() {
            let jailbreakProtectionViewController = JailbreakProtectionViewController()
            showChildViewController(jailbreakProtectionViewController)
        } else {
            authorizationViewController.delegate = self
            pinCodeViewController.delegate = self
            setupChildViewController() 
            setupDimmingView()
        }
    }
    
    
    // MARK: - Setup
    
    private func setupDimmingView() {
        view.addSubview(dimmingView)
        dimmingView.isHidden = true
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    
    private func setupChildViewController() {
        if securityService.isPinCodeEnabled() {
            showChildViewController(pinCodeViewController)
        } else {
            showChildViewController(authorizationViewController)
        }
    }
    
    
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
    
    
    @objc private func didEnterBackground() {
        dateBackground = Date()
    }
    

    @objc private func willEnterForeground() {
        guard let dateBackground = dateBackground else { return }
        let component = Calendar.current.dateComponents([.second], from: dateBackground, to: Date())
        let seconds = component.second ?? 0
        if seconds > 120 {
            TokenProvider.shared.token = ""
        }
    }

    
    // MARK: - Container Managment
    
    private func showPinCodeViewController() {
        switchViewController(authorizationViewController, viewControllerToShow: pinCodeViewController)
    }
    
    
    private func showAuthorizationViewController() {
        switchViewController(pinCodeViewController, viewControllerToShow: authorizationViewController)
    }
    
    
    private func showChildViewController(_ viewController: UIViewController) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            ])
        viewController.didMove(toParent: self)
    }
    
    
    private func hideChildViewController(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil) 
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    
    private func switchViewController(_ viewControllerToHide: UIViewController,
                                      viewControllerToShow: UIViewController) {
        hideChildViewController(viewControllerToHide)
        showChildViewController(viewControllerToShow)
    } 
    
    
    // MARK: - DimmingView Methods
    
    public func showDimmingView() {
        dimmingView.isHidden = false
        UIView.animate(withDuration: 0.15) { 
            self.dimmingView.alpha = 1
        }
    }
    
    
    public func hideDimmingView() {
        UIView.animate(withDuration: 0.15, animations: {
            self.dimmingView.alpha = 0
        }, completion: { _ in
            self.dimmingView.isHidden = true
        })
    }
    
    
    // MARK: - Alert
    
    private func showBiometricSecurityMessageAlert() {
        showSecurityMessageAlert(type: .biometric)
    }
    
    
    private func showPinCodeSecurityMessageAlert() {
        showSecurityMessageAlert(type: .pinCode)
    }
    
    
    private func showSecurityMessageAlert(type: SecurityMessageControllerType) {
        showDimmingView()
        let securityMessageViewController = SecurityMessageViewController(type: type)
        securityMessageViewController.delegate = self
        securityMessageViewController.providesPresentationContextTransitionStyle = true
        securityMessageViewController.definesPresentationContext = true
        securityMessageViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        securityMessageViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(securityMessageViewController, animated: true, completion: nil)
    }

}


// MARK: - AuthorizationViewControllerDelegate

extension MainViewController: AuthorizationViewControllerDelegate {
    
    func userDidAuthorize() {
        if securityService.isPinCodeEnabled() {
            showPinCodeViewController()
        } else {
            showPinCodeSecurityMessageAlert()
        }
    }
    
}


// MARK: - PinCodeViewControllerDelegate

extension MainViewController: PinCodeViewControllerDelegate {
  
    func resetRegistration() {
        showAuthorizationViewController()
    }
    
    
    func showWatcherViewController() {
        self.authorizationRouter?.showWatcherViewController()
    }
    
    
    func showErrorMessage(_ message: String) {
        self.showAlert(message: message)
    }
    
    
    func requesBiometric() {
        showBiometricSecurityMessageAlert()
    }
    
}


// MARK: - PinCodeViewControllerDelegate

extension MainViewController: SecurityMessageViewControllerDelegate {
    
    func okButtonDidTappedForType(_ type: SecurityMessageControllerType) {
        hideDimmingView()
        switch type {
        case .pinCode:
            showPinCodeViewController()
        case .biometric:   
            pinCodeViewController.savePassword()
            pinCodeViewController.biometricAuthorization()
        }
    }
    
    
    func cancelButtonDidTapped() {
        hideDimmingView()
        authorizationRouter?.showWatcherViewController()
    }
 
}
