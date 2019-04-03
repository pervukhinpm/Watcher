//
//  WeeksChildViewController.swift
//  Watcher
//
//  Created by Петр Первухин on 26/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import class apiClient.LoggedDays
import UIKit

protocol WeeksChildViewControllerDelegate: class {
    func  didChangeWeek(startDay: Date, endDate: Date)
}

final class WeeksChildViewController: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var monthContainerView: UIView!
    @IBOutlet private weak var loggedTimeContainerView: UIView!
    @IBOutlet private weak var animatedLineView: AnimateLineView!
    @IBOutlet private weak var weekLabel: UILabel!
    @IBOutlet private weak var monthLoggedTimeLabel: UILabel!
    @IBOutlet private weak var weekLoggedTimeLabel: UILabel!
    
    
    // MARK: - Delegate

    public weak var delegate: WeeksChildViewControllerDelegate?

    
    // MARK: - Properties
    
    private var currentDate = Date()
    private var watcherViewModel = WatcherViewModel()    
    private var service = ServiceLayer.shared.daysLogTimeService

    
    // MARK: - Loading

    override func viewDidLoad() {
        super.viewDidLoad()
        monthContainerView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        loggedTimeContainerView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        updateWeekLabel()
        loadMonth()
        animatedLineView.backgroundColor = ColorThemeManager.shared.current.animatedLineNonFillingColor
    }
    
    
    // MARK: - IBAction
    
    @IBAction private func forwardButtonAction(_ sender: Any) {
        currentDate = currentDate.startDateNextWeek
        updateCurrentDate(date: currentDate)
    }
    
    
    @IBAction private func backButtonACtion(_ sender: Any) {
        currentDate = currentDate.startDateBackToWeek
        updateCurrentDate(date: currentDate)
    }
    
    
    public func updateCurrentDate(date: Date) {
        currentDate = date
        updateWeekLabel()
        delegate?.didChangeWeek(startDay: currentDate.startOfWeek,
                                endDate: currentDate.endOfWeek)
    }
    
    
    // MARK: - Loading
    
    private func loadMonth() {
        service.getloggedTimeRecords(
            fromDate: Date.convertDateToStringFrom(date: currentDate.startOfMonth),
            toDate: Date.convertDateToStringFrom(date: currentDate.endOfMonth)) {[weak self] (loggedDays, error) in
                guard let self = self else { return }
                guard let loggedDays = loggedDays else {
                    self.showAlert(message: error)
                    return
                }
                self.calculateSpendingTime(loggedDays: loggedDays)
        }
    }

    
    // MARK: - Update Methods

    public func update() {
        updateCurrentDate(date: currentDate.startOfWeek)
    }
    
    
    public func updateWeekLoggedTimeLabel(loggedWeekMinutes: Int, workingWeekHours: Int) {
        let hmTuple = convertMinutesToHours(minutes: loggedWeekMinutes)        
        let time = hmTuple.1 == 0 ? "\(hmTuple.0)" : "\(hmTuple.0).\(hmTuple.1)"
        watcherViewModel.weekWorkHours = String(workingWeekHours)
        watcherViewModel.loggedWeekTime = time
        
        weekLoggedTimeLabel.text = watcherViewModel.loggedWeekTime
                
        var spentHours = hmTuple.0 + hmTuple.1 / 60
        if spentHours > workingWeekHours {
            spentHours = workingWeekHours
        }

        
        animatedLineView.progressAnimation(spentHours: CGFloat(spentHours),
                                           workingHours: CGFloat(workingWeekHours))
    }
    
    
    private func updateWeekLabel() {
        watcherViewModel.currentStartWeekDate = currentDate.startOfWeek
        weekLabel.text = watcherViewModel.currentWeek
    }
    
    
    private func updateMonthLoggedTimeLabel(notSpendingMinutes: Int) {
        let hmTuple = convertMinutesToHours(minutes: notSpendingMinutes)
        let time = hmTuple.1 == 0 ? "\(hmTuple.0)" : "\(hmTuple.0).\(hmTuple.1)"
        watcherViewModel.loggedMonthTime = time
        monthLoggedTimeLabel.text = watcherViewModel.loggedMonthTime
    }
    
    
    // MARK: - Help Methods

    //Возвращает tuple со временем (часы,минуты)
    private func convertMinutesToHours(minutes: Int) -> (Int, Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    
    //рассчет залогированного времени
    private func calculateSpendingTime(loggedDays: LoggedDays) {
        var spentMinutes = 0
        var workingDays = 0
        for loggedTimeDay in loggedDays.days {
            if loggedTimeDay.isWorking {
                workingDays += 1
            }
            for loggedTimeRecord in loggedTimeDay.loggedTimeRecords {
                spentMinutes += loggedTimeRecord.minutesSpent
            }
        }
        var workingMinutes = workingDays * 8 * 60 //рабочих минут в месяце
        workingMinutes -= spentMinutes
        self.updateMonthLoggedTimeLabel(notSpendingMinutes: workingMinutes)
    }
    
}
