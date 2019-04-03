//
//  WatcherViewController.swift
//  Wathcer
//
//  Created by Петр Первухин on 13/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Alamofire
import Reachability
import UIKit

final class WatcherViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var weekContatinerView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var buttonsContainerView: UIView!
    
    
    // MARK: - Private Properties
    
    private var watcherRouter: WatcherRouter?
    private var daysChildViewController: DaysChildViewController?
    private let weeksChildViewController = WeeksChildViewController()
    private let reachability = Reachability()!
    public var isInternetAvailable = false

    private var dimmingView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.isHidden = true
        view.alpha = 0
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        return view
    }()
    
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        watcherRouter = WatcherRouter(viewController: self)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setReachabilityNotifier()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daysChildViewController = DaysChildViewController(selection: {[weak self] (date) in
            guard let self = self else { return }
            if self.reachability.connection == .none {
                self.reachability.stopNotifier()
                try? self.reachability.startNotifier()
                if self.reachability.connection != .none {
                    self.watcherRouter?.showProjectListViewController(date: date)
                } else {
                    self.showAlert(message: "Нет интернета")
                }
            } else {
                self.watcherRouter?.showProjectListViewController(date: date)
            }
        })
        setupViewController()
        setupChildViewController() 
        
    }
    
        
    // MARK: - Motion

    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            watcherRouter?.showDataBaseViewController()
        }
    }
    
    
    // MARK: - Reachability

    private func setReachabilityNotifier() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged(note:)),
                                               name: .reachabilityChanged,
                                               object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            self.showAlert(message: "could not start reachability notifier")
        }
    }
    
    
    @objc func reachabilityChanged(note: Notification) {        
        let reachability = note.object as? Reachability 
        switch reachability!.connection {
        case .wifi:
            isInternetAvailable = true
        case .cellular:
            isInternetAvailable = true
        case .none:
            isInternetAvailable = false
        }
    }
    
    
    // MARK: - Setup Methods
    
    private func setupViewController() {
        setupNavigationBar()
        setupDimmingView()
        setupColorTheme()
    }
    
    
    private func setupColorTheme() {
        containerView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        weekContatinerView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        view.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        buttonsContainerView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
    }
    
    
    private func setupDimmingView() {
        guard let navigationController = navigationController else { return }
        navigationController.view.addSubview(dimmingView)
        dimmingView.isHidden = true
    }
    
    
    private func setupNavigationBar() {
        self.title = ls("time_manage")
        let calendarBarButton = UIBarButtonItem(
            image: #imageLiteral(resourceName: "icnCalendar"),
            style: .plain, 
            target: self, 
            action: #selector(showCalendar))
        navigationItem.rightBarButtonItem = calendarBarButton
    }
    
    
    private func setupDaysChildViewController() {
        guard  let daysChildViewController = daysChildViewController  else { return }
        daysChildViewController.delegate = self
        addChild(daysChildViewController)
        daysChildViewController.view.frame = containerView.bounds
        containerView.addSubview(daysChildViewController.view)
        daysChildViewController.didMove(toParent: self)
    }
    
    
    private func setupWeekChildViewController() {
        weeksChildViewController.delegate = self
        addChild(weeksChildViewController)
        weeksChildViewController.view.frame = weekContatinerView.bounds
        weekContatinerView.addSubview(weeksChildViewController.view)
        weeksChildViewController.didMove(toParent: self)
    }
    
    
    // MARK: - IBAction 
    
    @IBAction func illnesButtonAction(_ sender: UIButton) {
        watcherRouter?.showIllnessCalendarController()
    }
    
    
    @IBAction func instructionButtonAction(_ sender: UIButton) {
        watcherRouter?.showInstructionViewController()
    }
    
    
    @IBAction func vacationButtonAction(_ sender: UIButton) {
        watcherRouter?.showVacationCalendarController()
    }
    
    
    @objc private func showCalendar() {
        watcherRouter?.showCalendarController()
    }
    
    
    // MARK: - Update 
    
    private func setupChildViewController() {
        setupWeekChildViewController()
        setupDaysChildViewController()
    }
    
    
    // MARK: - Setup Child ViewController

    public func updateCurrentDate(date: Date) {
        weeksChildViewController.updateCurrentDate(date: date.startOfWeek)
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
    
}


// MARK: - WeeksChildViewControllerDelegate

extension WatcherViewController: WeeksChildViewControllerDelegate {
    func didChangeWeek(startDay: Date, endDate: Date) {
        guard  let daysChildViewController = daysChildViewController  else { return }
        daysChildViewController.changeWeek(startDay: startDay, endDate: endDate)
    }
}


// MARK: - DaysCollectionViewControllerDeleagte

extension WatcherViewController: DaysCollectionViewControllerDeleagte {
    func didChangeLoggedWeekTime(loggedWeekMinutes: Int, 
                                 workingWeekHours: Int) {
        weeksChildViewController.updateWeekLoggedTimeLabel(loggedWeekMinutes: loggedWeekMinutes,
                                                           workingWeekHours: workingWeekHours)
    }
}


// MARK: - MainCalendarViewControllerDelegate

extension WatcherViewController: MainCalendarViewControllerDelegate {
   
    func updateWeekDate(_ date: Date) {
        updateCurrentDate(date: date.startOfWeek)
    }
    
    
    func updateLoggedTime() {
        weeksChildViewController.update()
    } 
    
}


// MARK: - AddingProjectViewControllerDelegate

extension WatcherViewController: AddingProjectViewControllerDelegate {
    func updateLogTime() {
        weeksChildViewController.update()
    }
}
