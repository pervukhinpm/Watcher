//
//  PinCodeViewController.swift
//  Watcher
//
//  Created by Петр Первухин on 08/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

protocol PinCodeViewControllerDelegate: class {
    func resetRegistration()
    func requesBiometric()
    func showWatcherViewController()
    func showErrorMessage(_ message: String)
}

final class PinCodeViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private var pinIndicators: [PinIndicator]!
    @IBOutlet private weak var biometricButton: UIButton!
    @IBOutlet private weak var robotImageView: UIImageView!
    
    // MARK: - Public Properties
    
    public weak var delegate: PinCodeViewControllerDelegate?


    // MARK: - Private Properties

    private var pinCode = ""
    private var mistakes = 0
    private var securityService = ServiceLayer.shared.securityService
    private let biometricIDAuth = BiometricIDAuth()

    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        setupBiometricButton()
        clearPinCodeIndicator()
        setupColorTheme()
        
        if securityService.isBiometricEnabled() {
            if biometricIDAuth.biometricType() == .touchID {
                BiometricIDAuth().allowableReuseDuration = 15 
            } else {
                biometricAuthorization()
            }
        }
    
    }


    // MARK: - Setup
    
    private func setupColorTheme() {
        if let colorTheme = UserDefaults.standard.object(forKey: SettingsBundleKeys.AppThemeKey) {
            guard let colorThemeInteger = colorTheme as? Int else { return }
            guard let theme = ColorTheme(rawValue: colorThemeInteger) else { return }
            switch theme {
            case .light:
                robotImageView.image = #imageLiteral(resourceName: "robot")
            case .dark:
                robotImageView.image = #imageLiteral(resourceName: "darkWhiteRobot")
            }
        }
    }
    
    
    private func setupBiometricButton() {
        switch biometricIDAuth.biometricType() {
        case .faceID:
            biometricButton.setImage(#imageLiteral(resourceName: "FaceID"), for: .normal)
        default:
            biometricButton.setImage(#imageLiteral(resourceName: "touch"), for: .normal)
        }
        biometricButton.isEnabled = securityService.isBiometricEnabled() ? true : false
    }
    
    
    // MARK: - IBAction

    @IBAction private func keyboardButtonAction(_ sender: KeyboardButton) {
        if pinCode.count < pinIndicators.count {
            pinIndicators[pinCode.count].animateFilling()
            pinCode += String(sender.tag)
            if pinCode.count == 4 {
                pinCodeAthorization()
            }
        }
        
    }
    
    
    @IBAction private func deleteButtonAction(_ sender: UIButton) {
        if pinCode.count > 0 && pinCode.count < pinIndicators.count {
            pinCode.removeLast()
            pinIndicators[pinCode.count].animateResetFilling()
        }
    }
    
    
    @IBAction private func biometricButtonAction(_ sender: UIButton) {
        biometricAuthorization()
    }
    
    
    @IBAction func resetRegistrationButtonAction(_ sender: UIButton) {
        resetRegistration()
    }
    
    
    // MARK: - Private functions

    private func pinCodeAthorization() {
        if securityService.isPinCodeEnabled() {
            let isPinCodeValid = securityService.decrypt(pinCode)
            if isPinCodeValid {
                if securityService.isBiometricEnabled() {
                    delegate?.showWatcherViewController()
                } else {
                    delegate?.requesBiometric()
                }
            } else {
                if mistakes == 4 {
                    resetRegistration()
                } else {
                    mistakes += 1
                    clearPinCodeIndicator()
                    delegate?.showErrorMessage("Неправильный пароль")
                }
            }
        } else {
            securityService.crypt(pinCode)
            delegate?.requesBiometric()
        }
    }

    
    private func resetRegistration() {
        securityService.clearAll()
        mistakes = 0
        clearPinCodeIndicator()
        setupBiometricButton()
        delegate?.resetRegistration()
    }
    
    
    // MARK: - Public functions

    public func clearPinCodeIndicator() {
        pinCode = ""
        for indicator in pinIndicators {
            indicator.animateResetFilling()
        }
        
    }
    
    
    public func savePassword() {
        if pinCode.count > 0 && pinCode.count == 4 {
            securityService.savePinCode(pinCode)
        }
    }
    
    
    public func biometricAuthorization() {
        biometricIDAuth.authenticateUser { [weak self] (message) in
            guard let self = self else { return }
            if let message = message {
                let alertView = UIAlertController(title: "Ошибка",
                                                  message: message,
                                                  preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                alertView.addAction(okAction)
                self.present(alertView, animated: true)
                self.pinCode = ""
                for indicator  in self.pinIndicators {
                    indicator.animateResetFilling()
                }
            } else {
                if self.securityService.decryptWithBiometric() {
                    self.delegate?.showWatcherViewController()
                }
            }
        }
    }
    
}
