//
//  CalendarController.swift
//  Watcher
//
//  Created by Петр Первухин on 01/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit
import struct apiClient.CalendarDays

enum CalendarSelectionType {
    case date
    case vacation
    case illness
}


protocol CalendarControllerDelegate: class {
    func rangeDidSelecting(calendarViewModelArray: [CalendarViewModel])
    func dateSelecting(date: Date)
    func rangeDeselecting()
}


final class CalendarController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet private  weak var collectionView: UICollectionView!
    @IBOutlet private weak var monthLabel: UILabel!

    
    // MARK: - Public Properties

    public weak var delegate: CalendarControllerDelegate?

    
    // MARK: - Private Properties

    private var calendarViewModelArray = [CalendarViewModel]()
    private var cachedCalendarViewModelArray = [CalendarViewModel]()
    private let calendarService = ServiceLayer.shared.calendarService
    private var currentDate = Date()
    private let numberOfCells = 35
    private var currentStartRange: Date?
    private var currentEndRange: Date?
    private var calendarSelectionType: CalendarSelectionType
    private let spiner = Spiner(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    
    // MARK: - Initialization

    init(calendarSelectionType: CalendarSelectionType) {
        self.calendarSelectionType = calendarSelectionType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupColorTheme()
        setupSpiner()
        getCalendarForCurrentDate()
    }

    
    // MARK: - IBAction

    @IBAction func nextMonthButtonAction(_ sender: UIButton) {
        currentDate = currentDate.startDateNextMonth
        if currentStartRange != nil && currentEndRange == nil {
            if currentDate.endOfMonth > currentStartRange! {
                cachedCalendarViewModelArray.append(contentsOf: calendarViewModelArray)
            }
        }
        getCalendarForCurrentDate()
    }
    
    
    @IBAction func backMonthButtonAction(_ sender: Any) {
        currentDate = currentDate.startDateBackToMonth
        getCalendarForCurrentDate()
    }
    
    
    // MARK: - Setup Methods
    
    private func setupColorTheme() {
        headerContainerView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        collectionView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        view.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
    }
    
    
    private func setupCollectionView() {
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            UINib(nibName: "\(CalendarCell.self)",
                bundle: nil),
            forCellWithReuseIdentifier: CalendarCell.identifier)
    }
    
    
    private func setupSpiner() {
        collectionView.addSubview(spiner)
        spiner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spiner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            spiner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            spiner.heightAnchor.constraint(equalToConstant: 100),
            spiner.widthAnchor.constraint(equalToConstant: 100)])
    }
   
    
    // MARK: - Help Methods    

    func getCalendarForCurrentDate() {
        getCalendar(fromDate: currentDate.startOfMonth, toDate: currentDate.endOfMonth)
        monthLabel.text = makeMonthYearStringFrom(date: currentDate).capitalized
    }
    
    
    func getCalendar(fromDate: Date, toDate: Date) {
        self.spiner.startAnimation()
        calendarService.getCalendar(
            fromDate: Date.convertDateToStringFrom(date: fromDate), 
            toDate: Date.convertDateToStringFrom(date: toDate)) {[weak self] (calendarDays, errorMessage) in
                guard let self = self else { return }
                self.spiner.stopAnimation()
                guard let calendarDays = calendarDays else { 
                    self.showAlert(message: errorMessage)
                    return
                }
                self.calendarViewModelArray.removeAll()
                self.mapToCalendarViewModel(calendarDays: calendarDays)
                self.collectionView.reloadData()
        }
    }
    
    
    // swiftlint:disable function_body_length
    func mapToCalendarViewModel(calendarDays: CalendarDays) {
        
        //Берем первый день месяца из calendarDays и вычитаем сколько дней разница между ним и 
        //днем начала недели. Начало недели берется от первого дня месяца
        guard let firstDay = calendarDays.days.first else { return }
        let firstMonthDay = Date.convertStringToDateFrom(dateString: firstDay.date)
        let components = Date.getCalendar().dateComponents([.day],
                                                           from: firstMonthDay.startOfWeek, 
                                                           to: firstMonthDay)
        guard let difference = components.day else { return }
        
        //Находим разницу этих дней и заполняем calendarViewModelArray пустыми днями бланками
        for index in 0..<abs(difference) {
            guard let date = Date.getCalendar().date(byAdding: .day,
                                                     value: index, 
                                                     to: currentDate.startOfWeek) else { return }
            let calendarViewModel = CalendarViewModel(date: date,
                                                      day: "",
                                                      isWorking: false,
                                                      isBlank: true, 
                                                      isSelected: false)   
            calendarViewModelArray.append(calendarViewModel)
        }
        
        //Здесь идет заполнение calendarViewModelArray днями
        var isSelected = false 
        let visibleDays = calendarDays.days.map({ (calendarDay) -> CalendarViewModel in
            let date = Date.convertStringToDateFrom(dateString: calendarDay.date)
            
            //Проверка чтобы заполнять calendarViewModelArray выбранными днями, если выбран период
            //Эта проверка нужна так как при переключении месяца идет обновление массива 
            if currentStartRange != nil {
                    isSelected = date == currentStartRange
                if currentEndRange != nil {
                    if date >= currentStartRange! && date <= currentEndRange! {
                        isSelected = true
                    } else {
                        isSelected = false
                    }
                }
            }
            return CalendarViewModel(date: date,
                                     day: Date.convertStringToDayFrom(dateString: calendarDay.date), 
                                     isWorking: calendarDay.isWorking,
                                     isBlank: false, 
                                     isSelected: isSelected)
        })
        calendarViewModelArray.append(contentsOf: visibleDays)
        
        //Заполнение оставшихся дней в calendarViewModelArray днями бланками
        if calendarViewModelArray.count < numberOfCells {
            for index in 0..<numberOfCells - calendarViewModelArray.count {
                guard let date = Date.getCalendar().date(byAdding: .day,
                                                         value: index + 1, 
                                                         to: currentDate.endOfMonth) else { return }
                
                let calendarViewModel = CalendarViewModel(date: date,
                                                          day: "",
                                                          isWorking: false,
                                                          isBlank: true, 
                                                          isSelected: false)   
                calendarViewModelArray.append(calendarViewModel)
            }
        }
    }
    // swiftlint:enable function_body_length
    
    
    private func makeMonthYearStringFrom(date: Date) -> String {        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "LLLL, yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
}


// MARK: - UICollectionViewDelegate

extension CalendarController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        if calendarViewModelArray[indexPath.row].isBlank { return }
        
        if currentStartRange == nil {
            currentStartRange = calendarViewModelArray[indexPath.row].date
            calendarViewModelArray[indexPath.row].isSelected = true
            calendarSelectionType == .date ? delegate?.dateSelecting(date: currentStartRange!) : ()
        } else if currentEndRange == nil {
            currentEndRange = calendarViewModelArray[indexPath.row].date
             if currentEndRange! < currentStartRange! {
                deselectRange()
            } else {
                selectRange()
            }
        } else if currentStartRange != nil && currentEndRange != nil {
            deselectRange()
        }
        collectionView.reloadData()
    }
    
    
    func deselectRange() {
        for index in 0..<calendarViewModelArray.count {
            calendarViewModelArray[index].isSelected = false
        }
        delegate?.rangeDeselecting()
        cachedCalendarViewModelArray.removeAll()
        currentStartRange = nil
        currentEndRange = nil
    }
    
    
    func selectRange() {
        cachedCalendarViewModelArray = cachedCalendarViewModelArray.removingDuplicates()
        
        for index in 0..<cachedCalendarViewModelArray.count {
            if cachedCalendarViewModelArray[index].date >= currentStartRange! && 
                cachedCalendarViewModelArray[index].date <= currentEndRange! &&
                !cachedCalendarViewModelArray[index].isBlank {
                cachedCalendarViewModelArray[index].isSelected = true
            }
        }
        
        for index in 0..<calendarViewModelArray.count {
            if calendarViewModelArray[index].date >= currentStartRange! && 
                calendarViewModelArray[index].date <= currentEndRange! &&
                !calendarViewModelArray[index].isBlank {
                calendarViewModelArray[index].isSelected = true
                cachedCalendarViewModelArray.append(calendarViewModelArray[index])
            }
        }
        
        delegate?.rangeDidSelecting(calendarViewModelArray: cachedCalendarViewModelArray)
    }
    
}


// MARK: - UICollectionViewDataSource

extension CalendarController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarViewModelArray.count == 0 ? 0 : numberOfCells
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarCell.identifier,
            for: indexPath) as? CalendarCell else {
                return UICollectionViewCell()
        }
        
        let dayViewModel = calendarViewModelArray[indexPath.row]
        cell.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        let textColor = ColorThemeManager.shared.current.mainTextColor
        
        cell.dayLabel.text = dayViewModel.day
        cell.dayLabel.textColor = dayViewModel.isWorking ? textColor : .orangeyRed
        cell.dayColor = dayViewModel.isWorking ? textColor : .orangeyRed
        
        if indexPath.row % 7 == 6 {
            cell.dayLabel.textColor = .cloudyBlue
            cell.dayColor = .cloudyBlue
        } else if indexPath.row % 7 == 5 {
            cell.dayLabel.textColor = .cloudyBlue
            cell.dayColor = .cloudyBlue
        }
        
        if dayViewModel.isBlank {
            cell.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        } else {
            if dayViewModel.isSelected {
                let animator = UIViewPropertyAnimator(
                    duration: 0.3,
                    timingParameters: UICubicTimingParameters(animationCurve: .easeIn))
                animator.addAnimations {
                    cell.selectedView.backgroundColor = .orangeyRed   
                    cell.dayLabel.textColor = .white   
                    cell.selectedView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }
                animator.addCompletion {_ in
                    UIView.animate(withDuration: 0.3) {
                        cell.selectedView.transform = CGAffineTransform.identity
                    }
                }                
                animator.startAnimation()
            } else {
                cell.selectedView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
                cell.dayLabel.textColor = cell.dayColor
            }
        }
        
        return cell
    }
        
}
