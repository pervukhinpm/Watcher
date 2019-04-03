//
//  WatcherRouter.swift
//  Wathcer
//
//  Created by Петр Первухин on 13/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class WatcherRouter: NSObject {

    // MARK: - Public Properties

    public var loggedTimeRecordViewModel: LoggedTimeRecordViewModel?
    
    
    // MARK: - Private Properties
    
    // swiftlint:disable weak_delegate
    let dimmingModalTransitionDelegate = DimmingModalTransitioningDelegate()
    lazy var modalTransitionDelegate = ModalTransitioningDelegate(modalInteractiveTransition: interactor)
    // swiftlint:enable weak_delegate
    
    private let interactor = ModalInteractiveTransition()
    private weak var viewController: WatcherViewController!
    private var currentDate: Date?

    
    // MARK: - Initialization

    init(viewController: WatcherViewController) {        
        super.init()
        self.viewController = viewController
    }

    
    // MARK: - Show Methods
    
    public func showCalendarController() { 
        let dateCalendarController = MainCalendarViewController(
            calendarSelectionType: .date,
            interactor: interactor) { 
                self.viewController.hideDimmingView()
        }
        
        dateCalendarController.delegate = viewController
        showMainCalendarController(calendarController: dateCalendarController)
    }
    
    
    public func showVacationCalendarController() { 
        let vacationCalendar = MainCalendarViewController(
            calendarSelectionType: .vacation,
            interactor: interactor) { 
                self.viewController.hideDimmingView()
        }
        
        vacationCalendar.delegate = viewController
        showMainCalendarController(calendarController: vacationCalendar)
    }
    
    
    public func showIllnessCalendarController() { 
        let illnessCalendarController = MainCalendarViewController(
            calendarSelectionType: .illness,
            interactor: interactor) { 
                self.viewController.hideDimmingView()
        }
        
        illnessCalendarController.delegate = viewController
        showMainCalendarController(calendarController: illnessCalendarController)
    }
    
    
    public func showProjectListViewController(date: Date) { 
        currentDate = date
        let projectListViewController = ProjectListViewController {[weak self] (projectViewModel) in
            guard let self = self else { return }
            self.showAddingProjectViewControllerWith(projectViewModel: projectViewModel)
        }

        projectListViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        projectListViewController.transitioningDelegate = dimmingModalTransitionDelegate
        projectListViewController.modalPresentationStyle = .custom
        viewController?.present(projectListViewController, animated: true, completion: nil)
    }
    
    
    public func showDataBaseViewController() { 
        let dataBaseViewController = DataBaseViewController()
        dataBaseViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dataBaseViewController.transitioningDelegate = dimmingModalTransitionDelegate
        dataBaseViewController.modalPresentationStyle = .custom
        viewController?.present(dataBaseViewController, animated: true, completion: nil)
    }
    
    
    public func showInstructionViewController() { 
        let instructionViewController = InstructionViewController()
        instructionViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        instructionViewController.transitioningDelegate = dimmingModalTransitionDelegate
        instructionViewController.modalPresentationStyle = .custom
        viewController?.present(instructionViewController, animated: true, completion: nil)
    }
    

    // MARK: - Private Methods

    private func showMainCalendarController(calendarController: MainCalendarViewController) { 
        calendarController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        calendarController.transitioningDelegate = modalTransitionDelegate
        viewController.showDimmingView()
        viewController.present(calendarController, animated: true, completion: nil)
    }
    
        
    private func showAddingProjectViewControllerWith(projectViewModel: ProjectViewModel) {  
        let loggedTimeRecordViewModel = LoggedTimeRecordViewModel(projectName: projectViewModel.name, 
                                                                  loggedHours: "", 
                                                                  loggedMinutes: 0, 
                                                                  description: "", 
                                                                  date: currentDate!, 
                                                                  id: projectViewModel.id)
        
        let addingProjectViewController = AddingProjectViewController(
            loggedTimeRecordViewModel: loggedTimeRecordViewModel,
            isPreview: false)
        addingProjectViewController.delegate = viewController
        addingProjectViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addingProjectViewController.transitioningDelegate = dimmingModalTransitionDelegate
        addingProjectViewController.modalPresentationStyle = .custom
        viewController?.present(addingProjectViewController, animated: true, completion: nil)
    }
    
}
