//
//  DaysCollectionViewController.swift
//  Watcher
//
//  Created by Петр Первухин on 22/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import class apiClient.LoggedDays
import UIKit

protocol DaysCollectionViewControllerDeleagte: class {
    func didChangeLoggedWeekTime(loggedWeekMinutes: Int, workingWeekHours: Int)
}

final class DaysChildViewController: UIViewController {
    
    // MARK: - IBOutlet

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    
    // MARK: - Public Properties
    
    public weak var delegate: DaysCollectionViewControllerDeleagte?

    
    // MARK: - Private Properties
    
    private var dataSource: DaysCollectionViewDataSource?
    private var service = ServiceLayer.shared.daysLogTimeService
    private let selection: (Date) -> Void
    
    private var loggedDaysViewModel = [LoggedDayViewModel]() {
        didSet {
            if loggedDaysViewModel.count == 7 {
                dataSource?.loggedDaysViewModel = loggedDaysViewModel
                collectionView.reloadData()
            }
        }
    }
    
    
    // MARK: - Initialization

    init(selection : @escaping (Date) -> Void) {
        self.selection = selection
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupController()        
        let currentDate = Date()
        load(startDay: currentDate.startOfWeek, endDate: currentDate.startOfWeek.endOfWeek)
        registerViewForPeekAndPop()
    }
    
    
    // MARK: - Setup  Methods
    
    private func setupController() {
        activityIndicator.isHidden = true
        view.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        collectionView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
    }
    
    
    private func setupCollectionView() {
        dataSource = DaysCollectionViewDataSource(daysViewController: self)
        collectionView.dataSource = dataSource
        collectionView.register(
            UINib(nibName: "\(DayCollectionViewCell.self)",
                bundle: nil),
            forCellWithReuseIdentifier: DayCollectionViewCell.identifier)
    }
    
    
    private func registerViewForPeekAndPop() {
        if traitCollection.forceTouchCapability == .available {  
            registerForPreviewing(with: self, sourceView: collectionView)
        }
    }
    
    
    // MARK: - Public Methods

    public func changeWeek(startDay: Date, endDate: Date) {
        load(startDay: startDay, endDate: endDate)
    }
    
    
    // MARK: - Private Load  Methods

    private func load(startDay: Date, endDate: Date) {        
        service.getloggedTimeRecords(
            fromDate: Date.convertDateToStringFrom(date: startDay),
            toDate: Date.convertDateToStringFrom(date: endDate)) {[weak self] (loggedDays, errorMessage) in
                guard let self = self else { return }
                guard let loggedDays = loggedDays else {
                    self.showAlert(message: errorMessage)
                    if self.activityIndicator.isAnimating {
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                    }
                    return
                }
                if loggedDays.days.isEmpty {
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
                self.loggedDaysViewModel = self.mappingModelToViewModel(loggedDays: loggedDays)
                self.calculateWorkingHours(loggedDays: loggedDays)
        }
    }
    
    
    // MARK: - Private Help Methods

    private func calculateWorkingHours(loggedDays: LoggedDays) {
        var loggedWeekMinutes = 0
        var workingDays = 0
        
        for loggedTimeDay in loggedDays.days {
            if loggedTimeDay.isWorking {
                workingDays += 1
            }
            for loggedTimeRecord in loggedTimeDay.loggedTimeRecords {
                loggedWeekMinutes += loggedTimeRecord.minutesSpent
            }
        }
        
        let workingWeekHours = workingDays * 8
        self.delegate?.didChangeLoggedWeekTime(loggedWeekMinutes: loggedWeekMinutes,
                                               workingWeekHours: workingWeekHours)
    }
    
    
    private func mappingModelToViewModel(loggedDays: LoggedDays) -> [LoggedDayViewModel] {
        var loggedDaysViewModel = [LoggedDayViewModel]()
        var daysTitle = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
        for index in 0..<loggedDays.days.count {
            let formattedDate = Date.convertStringToDayMonthString(dateString: loggedDays.days[index].date)
            let date = Date.convertStringToDateFrom(dateString: loggedDays.days[index].date)

            let loggedTimeRecordViewModel = loggedDays.days[index].loggedTimeRecords
                .map { (loggedTimeRecord) -> LoggedTimeRecordViewModel in
                    let timeTuple = convertMinutesToHours(minutes: loggedTimeRecord.minutesSpent)
                    let loggedHours = timeTuple.1 == 0 ? "\(timeTuple.0) ч" : "\(timeTuple.0):\(timeTuple.1) ч"
                    let description = loggedTimeRecord.description
                    return LoggedTimeRecordViewModel(projectName: loggedTimeRecord.project.name,
                                                     loggedHours: loggedHours, 
                                                     loggedMinutes: loggedTimeRecord.minutesSpent,
                                                     description: description,
                                                     date: date, 
                                                     id: loggedTimeRecord.project.id)
                }

            let loggedDayViewModel = LoggedDayViewModel(day: daysTitle[index],
                                                        dateString: formattedDate,
                                                        date: date, 
                                                        isWorking: loggedDays.days[index].isWorking, 
                                                        loggedTimeRecordViewModel: loggedTimeRecordViewModel)
            loggedDaysViewModel.append(loggedDayViewModel)
        }
        return loggedDaysViewModel
    }
        

    private func convertMinutesToHours(minutes: Int) -> (Int, Int) {
        return (minutes / 60, (minutes % 60))
    }    
    
}


// MARK: - UIViewControllerPreviewingDelegate

extension DaysChildViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = collectionView.indexPathForItem(at: location) {
            guard let cell = collectionView.cellForItem(at: indexPath) as? DayCollectionViewCell else { return nil }
            let convertedLocation = collectionView.convert(location, to: cell.tableView)
            guard let convertedIndexPath = cell.tableView.indexPathForRow(at: convertedLocation) else { return nil }
            let loggedDayViewModel = loggedDaysViewModel[indexPath.row]
            let viewModel = loggedDayViewModel.loggedTimeRecordViewModel[convertedIndexPath.row]
            let addingProjectViewModel = AddingProjectViewController(loggedTimeRecordViewModel: viewModel,
                                                                     isPreview: true)
            addingProjectViewModel.preferredContentSize = CGSize(width: 0, height: 500)
            return addingProjectViewModel
        }
        return nil
        
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, 
                           commit viewControllerToCommit: UIViewController) {
        let customModalTransitionDelegate = DimmingModalTransitioningDelegate()
        viewControllerToCommit.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewControllerToCommit.transitioningDelegate = customModalTransitionDelegate
        viewControllerToCommit.modalPresentationStyle = .custom
        self.present(viewControllerToCommit, animated: true, completion: nil)
    }
    
}


// MARK: - DayCollectionViewCellDelegate

extension DaysChildViewController: DayCollectionViewCellDelegate {
    func didAddProjectButtonTapped(date: Date) {
        selection(date)
    }
}
