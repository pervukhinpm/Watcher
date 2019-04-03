//
//  InstructionDataSource.swift
//  Watcher
//
//  Created by Петр Первухин on 19/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class InstructionDataSource: NSObject {
    
    public var viewModel: InstructionViewModel!
    
}


// MARK: - UITableViewDataSource

extension InstructionDataSource: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel.sectionViewModels[section] 
        return section.cellModels.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionViewModels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sectionViewModels[indexPath.section] 
        switch section.type {
        case .greetings:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GreetingsInstructionCell.identifier,
                                                           for: indexPath) as? GreetingsInstructionCell else {
                                                        return UITableViewCell()
            }
            cell.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
            return cell
        case .complex:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ComplexInstructionCell.identifier,
                                                           for: indexPath) as? ComplexInstructionCell else {
                                                            return UITableViewCell()
            }
            guard let viewModel = section.cellModels[indexPath.row] as? InstructionRecordViewModel else { return cell }
            cell.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
            cell.activityTextLabel.text = viewModel.activityText
            cell.timeLogTextLabel.text = viewModel.timeLogText
            cell.verifiesTextLabel.text = viewModel.verifiesText
            return cell
        case .info:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoInsctructionCell.identifier,
                                                           for: indexPath) as? InfoInsctructionCell else {
                                                            return UITableViewCell()
            }
            guard let viewModel = section.cellModels[indexPath.row] as? InstructionInfoViewModel else { return cell }
            cell.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
            cell.infoTextLabel.text = viewModel.text
            return cell
        }
    }
    
}
