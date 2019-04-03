//
//  AddingProjectViewController.swift
//  Wathcer
//
//  Created by Петр Первухин on 17/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import UIKit

protocol AddingProjectViewControllerDelegate: class {
    func updateLogTime()
}

final class AddingProjectViewController: UIViewController {
    
    // MARK: - IBOutlet

    @IBOutlet private weak var projectNameLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var deleteTaskButton: UIButton!
    
    
    // MARK: - Private Properties
    
    private let dataSource = AddingProjectDataSource()
    private let logTimeService = ServiceLayer.shared.logTimeService
    private var projectDataSource = ProjectDataSource()    
    private var loggedTimeRecordViewModel: LoggedTimeRecordViewModel
    private var isPreview: Bool
    private let progressHUD = ProgressHUD()

    //Начальная высота ячейки
    private var rowHeight: CGFloat = 200
    private var time: DateComponents?
   
    private var isTimePickerCellHidden = false
    private var isStartHeightChanged = false
    
    private var isLogInfoFilled = false {
        didSet {
            if isLogInfoFilled == true {
                addButton.isEnabled = true
                addButton.backgroundColor = .orangeyRed
            } else {
                addButton.isEnabled = false
                addButton.backgroundColor = .orangeyRedOpacity
            }
        }
    }
    
    private var isTimeInfoFilled = false {
        didSet {
            checkLogInfoFilled()
        }
    }
    
    private var isLogDescriptionFilled = false {
        didSet {
            checkLogInfoFilled()
        }
    }
    
    
    // MARK: - Private Properties

    public weak var delegate: AddingProjectViewControllerDelegate?
    
    
    // MARK: - Initialization
    
    init(loggedTimeRecordViewModel: LoggedTimeRecordViewModel, isPreview: Bool) {
        self.loggedTimeRecordViewModel = loggedTimeRecordViewModel
        self.isPreview = isPreview
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addobsevers()
    }
    
    
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
        setupViewController()
    }
    
    
    // MARK: - Setup Methods

    private func setupViewController() {
        setupTableView()
        setupProjectNameLabel()
        setupAddButton()
        setupProgressHUD()
        setupColorTheme()
        tableView.reloadData()
        if isPreview {
            setupPreviewMode()
        } else {
            setupDeleteTaskButton()
        }
    }
    
    
    private func setupColorTheme() {
        view.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        tableView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
    }
    
    
    private func setupProgressHUD() {
        tableView.addSubview(progressHUD)
        progressHUD.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressHUD.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            progressHUD.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            progressHUD.heightAnchor.constraint(equalToConstant: 100),
            progressHUD.widthAnchor.constraint(equalToConstant: 100)])
        progressHUD.hide()
    }
    
    
    private func setupPreviewMode() {
        deleteTaskButton.isHidden = false
        deleteTaskButton.isEnabled = true
        addButton.isEnabled = false
        addButton.backgroundColor = .orangeyRedOpacity
        tableView.allowsSelection = false
        
        let descriptionIndexPath = IndexPath(row: 2, section: 0)
        guard let descriptionCell = tableView.cellForRow(at: descriptionIndexPath) as? LogTimeDescriptionCell else {
            return
        }
        descriptionCell.descriptionTextView.isEditable = false
        descriptionCell.descriptionTextView.text = loggedTimeRecordViewModel.description
        descriptionCell.descriptionTextView.textColor = ColorThemeManager.shared.current.mainTextColor
        descriptionCell.descriptionTextView.font = UIFont.b1Font
        let timeIndexPath = IndexPath(row: 0, section: 0)
        guard let timeCell = tableView.cellForRow(at: timeIndexPath) as? TimeInfoCell else { return }
        timeCell.timeLabel.text = loggedTimeRecordViewModel.loggedHours
        timeCell.timeLabel.textColor = ColorThemeManager.shared.current.mainTextColor
        timeCell.timeDescriptionLabel.textColor = .cloudyBlue
    }
    
    
    private func setupDeleteTaskButton() {
        deleteTaskButton.isHidden = true
        deleteTaskButton.isEnabled = false
    }
    
    
    private func setupAddButton() {
        addButton.layer.cornerRadius = 6
        addButton.clipsToBounds = true
        addButton.isEnabled = false
    }
    
    
    func setupProjectNameLabel() {
        projectNameLabel.text = loggedTimeRecordViewModel.projectName
    }

    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = rowHeight
        tableView.separatorStyle = .none
        dataSource.viewController = self
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.register(
            UINib(nibName: "\(TimeInfoCell.self)", bundle: nil),
            forCellReuseIdentifier: TimeInfoCell.identifier)
        tableView.register(
            UINib(nibName: "\(TimePickerCell.self)", bundle: nil),
            forCellReuseIdentifier: TimePickerCell.identifier)
        tableView.register(
            UINib(nibName: "\(LogTimeDescriptionCell.self)", bundle: nil), 
            forCellReuseIdentifier: LogTimeDescriptionCell.identifier)
    }
    
    
    // MARK: - Keyboard Handling

    private func addobsevers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue?)??.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        tableView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: false)
    }
    
    
    // MARK: - Help methods
    
    private func checkLogInfoFilled() {
        if isTimeInfoFilled && isLogDescriptionFilled {
            isLogInfoFilled = true
        } else {
            isLogInfoFilled = false
        }
    }
    
    
    private func hideTimeCell() {
        let index = IndexPath(row: 1, section: 0)
        guard let cell = tableView.cellForRow(at: index) as? TimePickerCell else { return }
        UIView.animate(
            withDuration: 0.1, 
            delay: 0, 
            usingSpringWithDamping: 0, 
            initialSpringVelocity: 0, 
            options: UIView.AnimationOptions.curveEaseIn,
            animations: { 
                cell.datePicker.isHidden = !cell.datePicker.isHidden
                self.isTimePickerCellHidden = cell.datePicker.isHidden
            })
        updateTableView()
    }
    
    
    private func updateTableView() {
        tableView.beginUpdates()
        tableView.endUpdates() 
    }
    
    
    private func converDateToString(date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateformatter.string(from: date)        
        return dateString
    }
    
    
    private func converDateComponentsToMinutes(dateComponents: DateComponents) -> Int? {
        guard let hour = dateComponents.hour,
            let minute = dateComponents.minute
            else { return nil }
        let minutes = hour * 60 + minute
        return minutes
    }
    
    
    // MARK: - IBAction

    @IBAction private func closeButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        delegate?.updateLogTime()
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction private func deleteTaskButtonAction(_ sender: Any) {
        print("Delete task")
    }
    
    
    @IBAction private func addButtonAction(_ sender: UIButton) {
        let dateString = converDateToString(date: loggedTimeRecordViewModel.date)
        let indexPath = IndexPath(row: 2, section: 0)

        guard let time = time else { return }
        guard let minutes = converDateComponentsToMinutes(dateComponents: time) else { return }
        guard let cell = tableView.cellForRow(at: indexPath) as? LogTimeDescriptionCell else { return }
        
        let logTimeRequest = LogTimeRequest(projectId: loggedTimeRecordViewModel.id, 
                                            minutesSpent: minutes, 
                                            date: dateString, 
                                            description: cell.descriptionTextView.text!)
        progressHUD.show()
        logTimeService.logTime(logTimeRequest) {[weak self] (loggedTimeData, errorMessage) in
            guard let self = self else { return }
            self.progressHUD.hide()
            guard loggedTimeData != nil else { 
                self.showAlert(message: errorMessage)
                return
            }
            self.deleteTaskButton.isHidden = false
            self.deleteTaskButton.isEnabled = true
            self.addButton.isEnabled = false
            self.addButton.backgroundColor = .orangeyRedOpacity
            if !self.isTimePickerCellHidden {
                self.hideTimeCell()
            }
            self.tableView.allowsSelection = false
            cell.descriptionTextView.isEditable = false
        }
    }
        
    
    @objc private func didTapView(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}


// MARK: UITableViewDelegate

extension AddingProjectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = dataSource.cellTypes[indexPath.row]
        switch cellType {
        case .timeInfoCell:
            return UITableView.automaticDimension
        case .timePickerCell:
            if isPreview {
                return 0
            } else {
                return isTimePickerCellHidden == true ? 0 : rowHeight 
            }
        case .logTimeDescriptionCell:
            return isStartHeightChanged == true ? UITableView.automaticDimension : rowHeight
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let index = IndexPath(row: 2, section: 0)
            guard let cell = tableView.cellForRow(at: index) as? LogTimeDescriptionCell else { return }
            cell.descriptionTextView.resignFirstResponder()            
            hideTimeCell()
            updateTableView()
        }
    }
    
}


// MARK: LogTimeDescriptionCellDeleagte

extension AddingProjectViewController: LogTimeDescriptionCellDelegate {
    
    func textViewDidChange(newText: String?) {
        if newText != "" {
            isLogDescriptionFilled = true
        } else {
            isLogDescriptionFilled = false
        }
    }
    
    
    func startAddingDescription() {
        let index = IndexPath(row: 1, section: 0)
        guard let cell = tableView.cellForRow(at: index) as? TimePickerCell else { return }
        UIView.animate(
            withDuration: 0.1, 
            delay: 0, 
            usingSpringWithDamping: 0, 
            initialSpringVelocity: 0, 
            options: UIView.AnimationOptions.curveEaseIn,
            animations: { 
                cell.datePicker.isHidden = true
                self.isTimePickerCellHidden = true
            })
        updateTableView()
    }
    
    
    func updateTableViewWith(_ height: CGFloat) {
        isStartHeightChanged = height < rowHeight ? false : true
        updateTableView()
    }
    
    
}


// MARK: TimePickerCellDelegate

extension AddingProjectViewController: TimePickerCellDelegate {
    
    func updateViewWith(_ time: DateComponents) {
        let indexPath = IndexPath(row: 0, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? TimeInfoCell else { return }
        cell.timeLabel.text = "\(time.hour!):\(time.minute!) " + ls("hour")
        self.time = time
        if time.minute! != 0 || time.hour! != 0 {
            isTimeInfoFilled = true
            cell.timeLabel.textColor = ColorThemeManager.shared.current.mainTextColor
            cell.timeDescriptionLabel.textColor = .cloudyBlue
        } else {
            cell.timeLabel.textColor = .orangeyRed
            cell.timeDescriptionLabel.textColor = .orangeyRed
            isTimeInfoFilled = false
        }
    }
    
}
