//
//  AuthorizationViewController.swift
//  Wathcer
//
//  Created by Петр Первухин on 13/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

protocol AuthorizationViewControllerDelegate: class {
    func userDidAuthorize()
}

final class AuthorizationViewController: ViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var rmrLogoImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet private weak var loginErrorLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var authorizeButton: UIButton!
    @IBOutlet private weak var enterForRobotsButton: UIButton!
    @IBOutlet private weak var registrationButton: UIButton!
    @IBOutlet private weak var forgotPasswordButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var emailLineView: UIView!
    @IBOutlet private weak var passwordLineView: UIView!
    @IBOutlet private weak var emailHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var passwordHeightConstraint: NSLayoutConstraint!
    

    // MARK: - Public Properties

    public weak var delegate: AuthorizationViewControllerDelegate?
    
    
    // MARK: - Private Properties
    
    private let constraintHeight: CGFloat = 100
    private let authorizationService = ServiceLayer.shared.authorizationService
    private var authorizationRouter: AuthorizationRouter?
    private var authorizationViewModel: AuthorizationViewModel?
    
    
    // MARK: - Initializers
    
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
        addobsevers()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    
    // MARK: - IBAction
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if sender.text == "" {
            authorizeButton.isEnabled = false
            authorizeButton.backgroundColor = .orangeyRedOpacity
            if let email = emailTextField.text {
                if EmailValidator.isValidEmail(email: email) {
                    showLoginErrorLabel()
                }
            }
        }
    }
    

    @IBAction func passwordTextFieldEditingChanged(_ sender: UITextField) {
        if sender.text == "" {
            authorizeButton.isEnabled = false
            authorizeButton.backgroundColor = .orangeyRedOpacity
        } else {
            if let email = emailTextField.text {
                if EmailValidator.isValidEmail(email: email) {
                    if passwordTextField.text != "" {
                        hideLoginErrorLabel()
                        authorizeButton.isEnabled = true
                        authorizeButton.backgroundColor = .orangeyRed
                    } else {
                        hideLoginErrorLabel()
                        authorizeButton.isEnabled = false
                        authorizeButton.backgroundColor = .orangeyRedOpacity
                    }
                }
            }
        }
    }
    
    
    @IBAction private func enterForRobotButtonAction(_ sender: UIButton) {        
    }
    
    
    @IBAction private func authorizeButtonAction(_ sender: Any) {
        showIndicator()
        view.endEditing(true)
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }    
        authorizationService.authorize(
            email: email,
            password: password) {[weak self] (authorizationData, errorMessage) in
                guard let self = self else { return }
                self.hideIndicator()
                guard authorizationData != nil else {
                    self.showAlert(message: errorMessage)
                    return 
                }
                self.delegate?.userDidAuthorize()
        }

    }
    
    
    @IBAction func registrationButtonAction(_ sender: UIButton) {
    }
    
    
    // MARK: - Setup Methods
    
    private func setupViewController() {
        setupColorTheme()
        setupAuthorizeButton()
        setupEnterForRobotsButton()
        setupDelegate()
        setupInitialState()
        setupLocalization()
    }
    
    
    private func setupColorTheme() {
        
        if let colorTheme = UserDefaults.standard.object(forKey: SettingsBundleKeys.AppThemeKey) {
            guard let colorThemeInteger = colorTheme as? Int else { return }
            guard let theme = ColorTheme(rawValue: colorThemeInteger) else { return }
            switch theme {
            case .light:
                rmrLogoImageView.image = #imageLiteral(resourceName: "imgRmrLogo")
            case .dark:
                rmrLogoImageView.image = #imageLiteral(resourceName: "imgRmrLogoDark")
            }
        }
        
        contentView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        view.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        emailTextField.textColor = ColorThemeManager.shared.current.mainTextColor
        passwordTextField.textColor = ColorThemeManager.shared.current.mainTextColor
    }
    
    
    private func setupLocalization() {

        emailTextField.attributedPlaceholder = NSAttributedString(
            string: ls("email_placeholder"), 
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.cloudyBlue])
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: ls("password_placeholder"), 
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.cloudyBlue])
    }
    
    
    private func setupDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    private func setupInitialState() {
        loginErrorLabel.alpha = 0
        authorizeButton.isEnabled = false
        authorizeButton.backgroundColor = .orangeyRedOpacity
    }
    
    
    private func setupAuthorizeButton() {
        authorizeButton.layer.cornerRadius = 6
        authorizeButton.clipsToBounds = true
    }
    
    
    private func setupEnterForRobotsButton() {
        enterForRobotsButton.layer.borderColor = UIColor.orangeyRed.cgColor
        enterForRobotsButton.layer.borderWidth = 1
        enterForRobotsButton.layer.cornerRadius = 6
        enterForRobotsButton.clipsToBounds = true
    }
    
    
    // MARK: - Keyboard Handling
    
    private func addobsevers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue?)??.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height + constraintHeight, right: 0)
        scrollView.contentInset = contentInset
    }
    
    
    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
    }
    
    
    // MARK: - Help functions
    
    private func showLoginErrorLabel() {
        self.authorizeButton.isEnabled = false
        UIView.animate(withDuration: 0.3) { 
            self.loginErrorLabel.alpha = 1
        }
    }
    
    
    private func hideLoginErrorLabel() {
        self.authorizeButton.isEnabled = true
        UIView.animate(withDuration: 0.3) { 
            self.loginErrorLabel.alpha = 0
        }
    }
    
}


// MARK: - UITextFieldDelegate

extension AuthorizationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailLineView.backgroundColor = .orangeyRed
            emailHeightConstraint.constant = 2
        }
        if textField == passwordTextField {
            passwordLineView.backgroundColor = .orangeyRed
            passwordHeightConstraint.constant = 2
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == emailTextField {
            emailLineView.backgroundColor = .cloudyBlue
            emailHeightConstraint.constant = 1
        }
        if textField == passwordTextField {
            passwordLineView.backgroundColor = .cloudyBlue
            passwordHeightConstraint.constant = 1
        }
        guard let email = emailTextField.text else { return }
        if EmailValidator.isValidEmail(email: email) {
            if passwordTextField.text != "" {
                hideLoginErrorLabel()
                authorizeButton.isEnabled = true
                authorizeButton.backgroundColor = .orangeyRed
            } else {
                hideLoginErrorLabel()
                authorizeButton.isEnabled = false
                authorizeButton.backgroundColor = .orangeyRedOpacity
            }
        } else {
            showLoginErrorLabel()
            authorizeButton.isEnabled = false
            authorizeButton.backgroundColor = .orangeyRedOpacity
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
