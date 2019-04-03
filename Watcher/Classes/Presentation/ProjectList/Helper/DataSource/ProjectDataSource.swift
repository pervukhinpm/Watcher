//
//  ProjectDataSource.swift
//  Wathcer
//
//  Created by Петр Первухин on 13/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class ProjectDataSource: NSObject {
    
    // MARK: - Properties
    
    public var viewModel: [ProjectViewModel] = []
    public var filtredViewModel: [ProjectViewModel] = []
    public var isSearched = false
    
}

// MARK: - UITableViewDataSource

extension ProjectDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearched {
            return filtredViewModel.count
        } else {
            return viewModel.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProjectCell.identifier,
            for: indexPath) as? ProjectCell else {
                return UITableViewCell()
        }
        
        cell.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        if isSearched {
            cell.viewModel = filtredViewModel[indexPath.row]
        } else {
            cell.viewModel = viewModel[indexPath.row]
        }
        return cell
    }
    
}
