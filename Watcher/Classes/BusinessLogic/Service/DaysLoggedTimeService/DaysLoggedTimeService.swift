//
//  DaysLoggedTimeService.swift
//  Watcher
//
//  Created by Петр Первухин on 23/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import Persistancy

protocol DaysLoggedTimeServiceProtocol {
    func getloggedTimeRecords(fromDate: String, 
                              toDate: String, 
                              completionHandler: @escaping (LoggedDays?, String?) -> Void)
}

///Сервис для получения LoggedDays
final class DaysLoggedTimeService: DaysLoggedTimeServiceProtocol {
    

    // MARK: - Private Properties

    private let apiClient: ApiClientProtocol
    private let realmPersistancy: PersistancyProtocol
    private let grdbPersistancy: PersistancyProtocol
    private let sqlPersistancy: PersistancyProtocol
    private var currentPersistancy: PersistancyProtocol
    private var currentURL: URL?

    
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

    ///Метод для отправки get запроса на получение LoggedDays на выбранный период
    ///Вначале возвращает кэшированные данные. После получения данных с сервера обновляет базу данных
    ///И возвращает обновленные данные в completionHandler 
    func getloggedTimeRecords(fromDate: String, 
                              toDate: String, 
                              completionHandler: @escaping (LoggedDays?, String?) -> Void) {
        
        var components = URLComponents(string: "https://watcher.intern.redmadrobot.com/api/v1/days")!
        components.queryItems = [
            URLQueryItem(name: "from", value: "\(fromDate)"),
            URLQueryItem(name: "to", value: "\(toDate)")
        ]
        currentURL = components.url
        let endpoint = DaysLoggedTimeEndpoint(fromDate: fromDate, toDate: toDate)
        let startDate = Date.convertStringToDateFrom(dateString: fromDate)
        let endDate = Date.convertStringToDateFrom(dateString: toDate)        
        let loggedDays = currentPersistancy.loadLoggedDay(startDate: startDate, endDate: endDate)
        completionHandler(loggedDays, nil)
        apiClient.request(with: endpoint) { (result) in
            switch result {
            case .success(let model):
                for loggedDay in model.days {
                    self.currentPersistancy.saveLoggedDay(model: loggedDay)
                }
                do {
                    if try endpoint.request().url == self.currentURL {
                        completionHandler(self.currentPersistancy.loadLoggedDay(startDate: startDate,
                                                                                endDate: endDate),
                                          nil)
                    }
                } catch {
                    completionHandler(nil, nil)
                }
            case .failure(let error):
                completionHandler(nil, error.localizedDescription)
            case .statusCode(let statusCode):
                guard let authorizationError = AuthorizationError(rawValue: statusCode) else {
                    completionHandler(nil, nil)
                    return
                }
                completionHandler(nil, authorizationError.desciption)
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
