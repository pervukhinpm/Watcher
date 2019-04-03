//
//  ProjectService.swift
//  Wathcer
//
//  Created by Петр Первухин on 13/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import Persistancy

protocol ProjectServiceProtocol {
    func getProjects(completionHandler: @escaping (ProjectData?, String?) -> Void)
}

///Сервис для получения списка проектов /projects/
final class ProjectService: ProjectServiceProtocol {
    
    // MARK: - Private Properties

    private let apiClient: ApiClientProtocol
    private let realmPersistancy: PersistancyProtocol
    private let grdbPersistancy: PersistancyProtocol
    private let sqlPersistancy: PersistancyProtocol
    private var currentPersistancy: PersistancyProtocol

    
    // MARK: - Initialization

    init(apiClient: ApiClientProtocol, 
         realmPersistancy: PersistancyProtocol,
         grdbPersistancy: PersistancyProtocol, 
         sqlPersistancy: PersistancyProtocol) {
        
        self.apiClient = apiClient
        
        self.realmPersistancy = realmPersistancy
        self.grdbPersistancy = grdbPersistancy
        self.sqlPersistancy = sqlPersistancy
        
        self.currentPersistancy = grdbPersistancy
        
        defaultsChanged()
        
        NotificationCenter.default.addObserver(self, 
                                               selector: #selector(self.defaultsChanged),
                                               name: UserDefaults.didChangeNotification, 
                                               object: nil)
    }
    
    
    // MARK: - Public Methods

    ///Метод для запроса на получение списка проектов.В completionHandler возвращает ProjectData 
    ///со списком проектов и сообщение об ошибки
    func getProjects(completionHandler: @escaping (ProjectData?, String?) -> Void) {
        let projectData = ProjectData(projects: currentPersistancy.loadAllProjects())
        completionHandler(projectData, nil)
        apiClient.request(with: ProjectEndpoint()) { (result) in
            switch result {
            case .success(let model):
                
                for project in model.projects {
                    self.currentPersistancy.saveProject(model: project)
                }
                
                let projectData = ProjectData(projects: self.currentPersistancy.loadAllProjects())
                completionHandler(projectData, nil)
                
            case .failure(let error):
                completionHandler(nil, error.localizedDescription)
            case .statusCode(let statusCode):
                guard let projectError = ProjectError(rawValue: statusCode) else {
                    completionHandler(nil, nil)
                    return
                }
                completionHandler(nil, projectError.desciption)
            }
        }
    }
    
    
    // MARK: - Private Methods

    @objc private func defaultsChanged() {
        if let dateBase = UserDefaults.standard.string(forKey: SettingsBundleKeys.BaseDataKey) {
            switch dateBase {
            case DataBaseType.sqlite.rawValue:
                currentPersistancy = sqlPersistancy
            case DataBaseType.realm.rawValue:
                currentPersistancy = realmPersistancy
            case DataBaseType.grdb.rawValue:
                currentPersistancy = grdbPersistancy
            default:
                currentPersistancy = realmPersistancy
            }   
        } else {
            currentPersistancy = grdbPersistancy
        }
    }
}
