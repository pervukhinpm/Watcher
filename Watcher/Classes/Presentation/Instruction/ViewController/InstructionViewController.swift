//
//  InstructionViewController.swift
//  Watcher
//
//  Created by Петр Первухин on 19/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class InstructionViewController: UIViewController {
   
    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    private let dataSource = InstructionDataSource()
    private var viewModel: InstructionViewModel?
    
    
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
        let instructionViewModelBuilder = InstructionViewModelBuilder()
        viewModel = instructionViewModelBuilder.buildViewModel()
        
        setupViewController()
    }
    
    
    // MARK: - IBAction
    
    @IBAction private func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Setup
    
    private func setupViewController() {
        view.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        setupTableView()
    }
    
    
    private func setupTableView() {
        guard let viewModel = viewModel else { return }
        dataSource.viewModel = viewModel
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        tableView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor

        tableView.delegate = self
        
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: "\(ComplexInstructionCell.self)", bundle: nil), 
                           forCellReuseIdentifier: ComplexInstructionCell.identifier)
        tableView.register(UINib(nibName: "\(InfoInsctructionCell.self)", bundle: nil), 
                           forCellReuseIdentifier: InfoInsctructionCell.identifier)
        tableView.register(UINib(nibName: "\(HeaderInstructionCell.self)", bundle: nil), 
                           forCellReuseIdentifier: HeaderInstructionCell.identifier)
        tableView.register(UINib(nibName: "\(GreetingsInstructionCell.self)", bundle: nil), 
                           forCellReuseIdentifier: GreetingsInstructionCell.identifier)
        tableView.reloadData()
    }
   
}


// MARK: - UITableViewDelegate

extension InstructionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let  headerCell = tableView.dequeueReusableCell(
            withIdentifier: HeaderInstructionCell.identifier) as? HeaderInstructionCell else { 
                return UITableViewCell()
        }
        guard let viewModel = viewModel else { return UITableViewCell() }
        let sectionViewModel = viewModel.sectionViewModels[section]
        switch sectionViewModel.type {
        case .greetings:
            return UITableViewCell()
        default:
            headerCell.headerLabel.text = sectionViewModel.title
            headerCell.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
            return headerCell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let viewModel = viewModel else { return 0 }
        let sectionViewModel = viewModel.sectionViewModels[section]
        return sectionViewModel.type == .greetings ? CGFloat.leastNormalMagnitude : 28
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 1 ? 12 : CGFloat.leastNormalMagnitude
    }
    
}
