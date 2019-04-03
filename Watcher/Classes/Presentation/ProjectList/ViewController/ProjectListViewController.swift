//
//  ProjectListViewController.swift
//  Wathcer
//
//  Created by Петр Первухин on 13/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class ProjectListViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    private let progressHUD = ProgressHUD()
    private var projectDataSource = ProjectDataSource()    
    private let projectLoader = ProjectLoader()
    private var projectViewModel: [ProjectViewModel] = [] {
        didSet {
            projectDataSource.viewModel = projectViewModel
        }
    }
    private let selection: (ProjectViewModel) -> Void
    
    
    // MARK: - Initialization
    
    init(selection : @escaping (ProjectViewModel) -> Void) {
        self.selection = selection
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
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
        setupViewController()
        loadProjects()
    }
    
    
    // MARK: - IBAction
    
    @IBAction private func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Setup
    
    private func setupViewController() {
        setupTableView()
        setupSearchTextField() 
        setupProgressHUD()
        setupColorTheme()
    }
    
    
    private func setupColorTheme() {
        view.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        tableView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
    }
    
    
    private func setupProgressHUD() {
        progressHUD.translatesAutoresizingMaskIntoConstraints = true
        progressHUD.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        progressHUD.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin,
                                        UIView.AutoresizingMask.flexibleRightMargin,
                                        UIView.AutoresizingMask.flexibleTopMargin,
                                        UIView.AutoresizingMask.flexibleBottomMargin]
        progressHUD.addConstraints([])
        view.addSubview(progressHUD)
        progressHUD.hide()
    }
    
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = projectDataSource
        tableView.register(UINib(nibName: "\(ProjectCell.self)", bundle: nil), 
                           forCellReuseIdentifier: ProjectCell.identifier)
    }
    
    
    private func setupSearchTextField() {
        searchTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        searchTextField.delegate = self
        searchTextField.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        let textColor = ColorThemeManager.shared.current.mainTextColor
        searchTextField.textColor = textColor
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: ls("enter_project_name"),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.cloudyBlue])
    }
    
    
    // MARK: - TextField Search
    
    @objc func textDidChange(_ textField: UITextField) {
        if let searchString = textField.text {
            projectDataSource.filtredViewModel = projectViewModel
                .filter({ $0.name.prefix(searchString.lowercased().count) == searchString.capitalized })
        }
        projectDataSource.isSearched = true
        tableView.reloadData()
    }
    
    
    // MARK: - Load
    
    private func loadProjects() {
        progressHUD.show()
        projectLoader.getProjects {[weak self] (projectViewModel, error) in
            guard let self = self else { return }
            self.progressHUD.hide()
            guard let projectViewModel = projectViewModel else {
                self.showAlert(message: error)
                return
            }
            self.projectViewModel = projectViewModel
            self.tableView.reloadData()
        }
    }
    
}


// MARK: - UITextFieldDelegate

extension ProjectListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: - UITableViewDelegate

extension ProjectListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        if projectDataSource.isSearched {
            let model = projectDataSource.filtredViewModel[indexPath.row]
            self.dismiss(animated: true) { 
                self.selection(model)
            }
        } else {
            let model = projectDataSource.viewModel[indexPath.row]
            self.dismiss(animated: true) { 
                self.selection(model)
            }
        }
    }
    
}
