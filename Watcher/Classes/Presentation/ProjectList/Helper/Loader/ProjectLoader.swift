//
//  ProjectLoader.swift
//  Wathcer
//
//  Created by Петр Первухин on 13/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

final class ProjectLoader {

    // MARK: - Private Properties

    private let projectService = ServiceLayer.shared.projectService
    
    // MARK: - Public Methods

    public func getProjects (
        completionHandler: @escaping ([ProjectViewModel]?, String?) -> Void) {
        projectService.getProjects { (model, error) in
            guard let model = model else { 
                completionHandler(nil, error)
                return 
            } 
            let viewModel = (model.projects.map({ (projectModel) -> ProjectViewModel in
                return ProjectViewModel(name: projectModel.name, id: projectModel.id)
            }))
            completionHandler(viewModel, nil)
        }
    }
    
}
