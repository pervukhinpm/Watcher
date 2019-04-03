//
//  SecurityMessageViewController.swift
//  Watcher
//
//  Created by Петр Первухин on 12/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

enum SecurityMessageControllerType {
    case pinCode
    case biometric
}

protocol SecurityMessageViewControllerDelegate: class {
    func okButtonDidTappedForType(_ type: SecurityMessageControllerType)
    func cancelButtonDidTapped()
}

class SecurityMessageViewController: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var messageLabel: B2Label!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var okButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    

    // MARK: - Private Properties

    private var type: SecurityMessageControllerType!
    
    
    // MARK: - Public Properties

    public weak var delegate: SecurityMessageViewControllerDelegate?
    
    
    // MARK: - Initialization
    
    init(type: SecurityMessageControllerType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.backgroundColor = ColorThemeManager.shared.current.messageBackgroundColor
        setupViewController()
    }

    
    // MARK: - Setup

    func setupViewController() {
        messageLabel.text = type == .pinCode ? "Установите Pin Code" : "Установите FaceID/TouchID"
        cancelButton.isEnabled = type == .pinCode ? false : true
        cancelButton.isHidden = type == .pinCode ? true : false
    }

    
    // MARK: - IBAction

    @IBAction func okButtonAction(_ sender: UIButton) {
        dismiss(animated: true) { 
            self.delegate?.okButtonDidTappedForType(self.type)
        }
    }
    
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismiss(animated: true) { 
            self.delegate?.cancelButtonDidTapped()
        }
    }
    
}
