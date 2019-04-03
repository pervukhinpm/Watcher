//
//  DayCollectionViewCell.swift
//  Watcher
//
//  Created by Петр Первухин on 22/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import UIKit

protocol DayCollectionViewCellDelegate: class {
    func didAddProjectButtonTapped(date: Date)
}

final class DayCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    public static let identifier = "DayCollectionViewCellID"
    
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addProjectButton: UIButton!

    
    // MARK: - Public Properties

    public var date: Date?
    
    public var isWorkingDay: Bool = true {
        didSet {
            addProjectButton.isEnabled = isWorkingDay ? true : false
            addProjectButton.backgroundColor = isWorkingDay ? .orangeyRed : .orangeyRedOpacity
        }
    }
    
    public weak var delegate: DayCollectionViewCellDelegate?
    
    public var loggedRecords = [LoggedTimeRecordViewModel]() {
        didSet {
            tableView.reloadData()
            updateHoursLabel()
        }
    }
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        containerView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        addProjectButton.layer.cornerRadius = 6
        addProjectButton.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "\(ProjectTimeCell.self)", bundle: nil), 
                           forCellReuseIdentifier: ProjectTimeCell.identifier)   
        tableView.separatorStyle = .none
    }

    // MARK: - Update
    func updateHoursLabel() {
        var minutes = 0
        for loggedRecord in loggedRecords {
            minutes += loggedRecord.loggedMinutes
        }
        let hmTuple = convertMinutesToHours(minutes: minutes)        
        let time = hmTuple.1 == 0 ? "\(hmTuple.0) ч" : "\(hmTuple.0).\(hmTuple.1) ч"
        hoursLabel.text = time
    }

    //Возвращает tuple со временем (часы,минуты)
    private func convertMinutesToHours(minutes: Int) -> (Int, Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    // MARK: - IBAction

    @IBAction private func addProjectButtonAction(_ sender: Any) {
        guard let date = date else { return }
        delegate?.didAddProjectButtonTapped(date: date)
    }
    
}


// MARK: - UITableViewDelegate

extension DayCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - UITableViewDataSource

extension DayCollectionViewCell: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loggedRecords.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectTimeCell.identifier,
                                                       for: indexPath) as? ProjectTimeCell else {
                                                        return UITableViewCell()
        }
        cell.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        cell.projectNameLabel.text = loggedRecords[indexPath.row].projectName
        cell.projectDescriptionLabel.text = loggedRecords[indexPath.row].description
        cell.loggedTimeLabel.text = loggedRecords[indexPath.row].loggedHours
        return cell
    }
    
}
