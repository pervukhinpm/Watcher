//
//  DateSource.swift
//  Watcher
//
//  Created by Петр Первухин on 07/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class DaysCollectionViewDataSource: NSObject {
 
    // MARK: - Public Properties
    
    public var loggedDaysViewModel = [LoggedDayViewModel]()
    
    
    // MARK: - Private Properties
    
    private weak var daysViewController: DaysChildViewController?
    private let numberOfSection = 1
    

    // MARK: - Initialization

    init(daysViewController: DaysChildViewController) {
        self.daysViewController = daysViewController
    }
    
}

// MARK: - UITableViewDataSource

extension DaysCollectionViewDataSource: UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSection
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loggedDaysViewModel.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DayCollectionViewCell.identifier, 
            for: indexPath) as? DayCollectionViewCell else {
                return UICollectionViewCell()
        }
        cell.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor

        cell.delegate = daysViewController
        cell.isWorkingDay = loggedDaysViewModel[indexPath.row].isWorking
        cell.dayLabel.text = loggedDaysViewModel[indexPath.row].day
        cell.dateLabel.text = loggedDaysViewModel[indexPath.row].dateString
        cell.date = loggedDaysViewModel[indexPath.row].date
        cell.loggedRecords = loggedDaysViewModel[indexPath.row].loggedTimeRecordViewModel
        return cell
    }
    
}
