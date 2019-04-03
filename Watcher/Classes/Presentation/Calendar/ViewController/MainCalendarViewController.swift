//
//  MainCalendarViewController.swift
//  Watcher
//
//  Created by Петр Первухин on 06/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

protocol MainCalendarViewControllerDelegate: class {
    func updateLoggedTime()
    func updateWeekDate(_ date: Date)
}

final class MainCalendarViewController: ModalPresentationViewController {
    
    // MARK: - Private Properties
    
    private var calendarSelectionType: CalendarSelectionType 
    private let buttonViewController: ButtonViewController!
    private var calendarController: CalendarController!
    
    
    // MARK: - Public Properties
    
    public weak var delegate: MainCalendarViewControllerDelegate?
    
    
    // MARK: - PreferredStatusBarStyle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - Initialization
    
    init(calendarSelectionType: CalendarSelectionType,
         interactor: ModalInteractiveTransition, 
         viewWillDismissHandler: @escaping ViewWillDismiss) {
        self.calendarSelectionType = calendarSelectionType
        self.calendarController = CalendarController(calendarSelectionType: calendarSelectionType)
        self.buttonViewController = ButtonViewController(calendarSelectionType: calendarSelectionType)
        super.init(interactor: interactor,
                   viewWillDismissHandler: viewWillDismissHandler)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModalPresentationViewController()
    }
    
    
    // MARK: - Setup
    
    private func  setupColorTheme() {
        view.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
    }
    

    private func setupModalPresentationViewController() {
        
        calendarController.delegate = self
        buttonViewController.delegate = self
        
        addArrangedSubview(view: calendarController.view, 
                                                           height: view.frame.height / 2) 
        addArrangedSubview(view: buttonViewController.view, 
                                                           height: 100)  
        buttonViewController.view.isHidden = true
        
        addChild(viewController: calendarController)
        addChild(viewController: buttonViewController)
        
    }
    
    
    private func showButtonView() {
        buttonViewController.showFillButton()
    }
    
    
    // MARK: - Child ViewController
    
    private func removeChild(viewController: UIViewController) {
        viewController.willMove(toParent: nil) 
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    
    private func addChild(viewController: UIViewController) {
        addChild(viewController)
        viewController.didMove(toParent: self)
    }
    
    
    private func removeChilds() {
        removeChild(viewController: buttonViewController)
        removeChild(viewController: calendarController)
    }
    
}


// MARK: - CalendarControllerDelegate

extension MainCalendarViewController: CalendarControllerDelegate {
    
    func rangeDeselecting() {
        guard !buttonViewController.view.isHidden else { return }
        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 1,
                       options: [],
                       animations: {
                        self.buttonViewController.view.isHidden = true
                        self.stackView.layoutIfNeeded()
        },
                       completion: nil)
    }
    
    
    func rangeDidSelecting(calendarViewModelArray: [CalendarViewModel]) {
        var requestArray = [String]()
        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 1,
                       options: [],
                       animations: {
                        self.buttonViewController.view.isHidden = false
                        self.stackView.layoutIfNeeded()
        },
                       completion: nil)
        for calendarViewModel in calendarViewModelArray {
            if calendarViewModel.isWorking && calendarViewModel.isSelected {
                let dateString = Date.convertDateToStringFrom(date: calendarViewModel.date)
                requestArray.append(dateString)
            }
        }
        buttonViewController.requestArray = requestArray
        showButtonView()
    }
    
    
    func dateSelecting(date: Date) {
        delegate?.updateWeekDate(date)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}


// MARK: - ButtonViewControllerDelegate

extension MainCalendarViewController: ButtonViewControllerDelegate {
    
    func updateLoggedTime() {
        dismiss(animated: true, completion: nil)
        delegate?.updateLoggedTime()
    }
    
    
    func showAllert(errorMessage: String) {
        showAlert(message: errorMessage)
    }
    
}
