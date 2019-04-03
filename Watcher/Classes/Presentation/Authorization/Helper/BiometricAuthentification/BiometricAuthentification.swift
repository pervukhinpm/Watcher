//
//  BiometricAuthentification.swift
//  Watcher
//
//  Created by Петр Первухин on 11/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation
import LocalAuthentication

enum BiometricType {
    case none
    case touchID
    case faceID
}

final class BiometricIDAuth {
    
    // MARK: - Properties

    private let context = LAContext()
    private var loginReason = ls("login_reason")
    
    
    // MARK: - Public
    
    public var allowableReuseDuration: TimeInterval? = nil {
        didSet {
            guard let duration = allowableReuseDuration else {
                return
            }
            self.context.touchIDAuthenticationAllowableReuseDuration = duration
        }
    }
    
    
    public func biometricType() -> BiometricType {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        }
    }
    
    
    public func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    
    public func authenticateUser(completion: @escaping (String?) -> Void) {
        guard canEvaluatePolicy() else {
            DispatchQueue.main.async {
                completion(ls("biometric_cant_configured_error"))
            }
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: loginReason) { (success, evaluateError) in
            if success {
                DispatchQueue.main.async {
                    completion(nil)
                }
            } else {
                let message: String
                switch evaluateError {
                case LAError.authenticationFailed?:
                    message = ls("verifying_error")
                case LAError.userCancel?:
                    message = ls("pressed_cancel_error")
                case LAError.userFallback?:
                    message = ls("pressed_password_error")
                case LAError.biometryNotAvailable?:
                    message = ls("biometric_not_available_error")
                case LAError.biometryNotEnrolled?:
                    message = ls("biometric_not_set_up_error")
                case LAError.biometryLockout?:
                    message = ls("biometric_locked_error")
                default:
                    message = ls("biometric_cant_configured_error")
                }
                DispatchQueue.main.async {
                    completion(message)
                }
            }
        }
    }
}
