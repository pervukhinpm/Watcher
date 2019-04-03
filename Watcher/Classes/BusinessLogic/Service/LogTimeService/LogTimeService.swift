//
//  LoggedTimeService.swift
//  Wathcer
//
//  Created by Петр Первухин on 18/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient

protocol LogTimeServiceProtocol {
    func logTime(_ logTimeRequest: LogTimeRequest, completionHandler: @escaping (LoggedTimeData?, String?) -> Void)
}

///Сервис для списания времени /logged-time/
final class LogTimeService: LogTimeServiceProtocol {
    
    // MARK: - Private Properties

    private let apiClient: ApiClientProtocol


    // MARK: - Initialization
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    
    // MARK: - Public Methods
    
    ///Метод для отправки post запроса с LogTimeRequest для списания времени. 
    ///В completionHanler возвращает ответ с сервера LoggedTimeData и сообщение об ошибке
    public func logTime(_ logTimeRequest: LogTimeRequest, 
                        completionHandler: @escaping (LoggedTimeData?, String?) -> Void) {
        apiClient.request(with: LoggedTimeEndpoint(logTimeRequest: logTimeRequest)) { (result) in
            switch result {
            case .success(let model):
                completionHandler(model, nil)
            case .failure(let error):
                completionHandler(nil, error.localizedDescription)
            case .statusCode(let statusCode):
                guard let loggedTimeError = LoggedTimeError(rawValue: statusCode) else {
                    completionHandler(nil, nil)
                    return
                }
                completionHandler(nil, loggedTimeError.desciption)
            }
        }
    }
}
