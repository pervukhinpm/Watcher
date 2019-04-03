//
//  DataBaseViewController.swift
//  Watcher
//
//  Created by Петр Первухин on 19/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Persistancy
import UIKit

final class DataBaseViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var dataBaseSegmentedControl: UISegmentedControl!
    @IBOutlet weak var modelsSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private Properties
    
    private let dataSource = DataBaseDataSource()
    private var viewModel: DataBaseViewModel?
    private let sqlitePersistancy = ServiceLayer.shared.sqlitePersistancy
    private let grdbPersistancy = ServiceLayer.shared.grdbPersistancy
    private let realmPersistancy = ServiceLayer.shared.realmPersistancy
    private var currentPersistancy: PersistancyProtocol = ServiceLayer.shared.grdbPersistancy
    
    
    // MARK: - Lifecycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let path = UIBezierPath(roundedRect: self.view.bounds, 
                                byRoundingCorners: [.topLeft, .topRight], 
                                cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.view.layer.mask = maskLayer
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPersistancy = sqlitePersistancy
        setupTableView()
        view.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
    }
    
    
    private func setupTableView() {
        viewModel = DataBaseViewModel(type: .loggedDay, 
                                      cellModels: currentPersistancy.loadAllLoggedDays())
        guard let viewModel = viewModel else { return }
        dataSource.viewModel = viewModel
        tableView.dataSource = dataSource        
        tableView.delegate = self
        tableView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor        

        tableView.register(UINib(nibName: "\(ProjectHeaderCell.self)", bundle: nil), 
                           forCellReuseIdentifier: ProjectHeaderCell.identifier)
        tableView.register(UINib(nibName: "\(LoggedTimeRecordHeaderCell.self)", bundle: nil), 
                           forCellReuseIdentifier: LoggedTimeRecordHeaderCell.identifier)
        tableView.register(UINib(nibName: "\(LoggedDayHeaderCell.self)", bundle: nil), 
                           forCellReuseIdentifier: LoggedDayHeaderCell.identifier)
        setLoggedDaysToViewModel()
    }
    
    
    // MARK: - IBAction

    @IBAction private func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func modelsSegmentedControlValueDidChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            setLoggedDaysToViewModel()
        case 1:
            setLoggedTimeRecordsToViewModel()
        case 2:
            setProjectsToViewModel()
        default:
            print("something go wrong")
        }
    }
    
    @IBAction private func segmentedControlValueDidChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentPersistancy = sqlitePersistancy
        case 1:
            currentPersistancy = realmPersistancy
        case 2:
            currentPersistancy = grdbPersistancy
        default:
            print("something go wrong")
        }
        modelsSegmentedControl.selectedSegmentIndex = 0
        setLoggedDaysToViewModel()
    }
    
    
    // MARK: - Private Methods

    private func setLoggedDaysToViewModel() {
        viewModel = nil
        viewModel = DataBaseViewModel(type: .loggedDay, 
                                      cellModels: currentPersistancy.loadAllLoggedDays())
        dataSource.viewModel = viewModel
        tableView.reloadData()
    }
    
    
    private func setLoggedTimeRecordsToViewModel() {
        viewModel = nil
        viewModel = DataBaseViewModel(type: .loggedTimeRecord, 
                                      cellModels: currentPersistancy.loadAllLoggedTimeRecords())
        dataSource.viewModel = viewModel
        tableView.reloadData()
    }
    
    
    private func setProjectsToViewModel() {
        viewModel = nil
        viewModel = DataBaseViewModel(type: .project, 
                                      cellModels: currentPersistancy.loadAllProjects())
        dataSource.viewModel = viewModel
        tableView.reloadData()
    }
    
}


// MARK: - UITableViewDelegate

extension DataBaseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = viewModel else { return UITableViewCell() }
        switch viewModel.type {
        case .project:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ProjectHeaderCell.identifier) as? ProjectHeaderCell else { 
                    return UITableViewCell()
            }
            cell.backgroundColor = .white
            cell.idLabel.text = "id"
            cell.nameLabel.text = "name"
            cell.backgroundColor = ColorThemeManager.shared.current.textViewBackgroundColor
            return cell
        case .loggedDay:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: LoggedDayHeaderCell.identifier) as? LoggedDayHeaderCell else {
                    return UITableViewCell()
            }
            cell.backgroundColor = .white
            cell.dateLabel.text = "date"
            cell.isWorkingLabel.text = "isWorking"
            cell.backgroundColor = ColorThemeManager.shared.current.textViewBackgroundColor
            return cell
        case .loggedTimeRecord:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: LoggedTimeRecordHeaderCell.identifier) as? LoggedTimeRecordHeaderCell else {
                    return UITableViewCell()
            }
            cell.backgroundColor = .white
            cell.dateLabel.text = "date"
            cell.idLabel.text = "id"
            cell.projectIdLabel.text = "projectId"
            cell.minutesSpentLabel.text = "minutesSpent"
            cell.backgroundColor = ColorThemeManager.shared.current.textViewBackgroundColor
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
