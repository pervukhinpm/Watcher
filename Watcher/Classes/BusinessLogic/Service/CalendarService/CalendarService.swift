//
//  CalendarService.swift
//  Watcher
//
//  Created by Петр Первухин on 01/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient

protocol CalendarServiceProtocol {
    func getCalendar(fromDate: String, 
                     toDate: String,
                     completionHandler: @escaping (CalendarDays?, String?) -> Void)
}

///Сервис для получения CalendarDays с сервера
final class CalendarService: CalendarServiceProtocol {
 
    // MARK: - Private Properties

    private let apiClient: ApiClientProtocol

    
    // MARK: - Initialization

    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    
    // MARK: - Public Methods

    ///Метод для отправки get запроса на получение days на выбранный период
    func getCalendar(fromDate: String, 
                     toDate: String, 
                     completionHandler: @escaping (CalendarDays?, String?) -> Void) {
        
        apiClient.request(
        with: CalendarDaysEndpoint(fromDate: fromDate, toDate: toDate)) { (result) in
            switch result {
            case .success(let model):
                completionHandler(model, nil)     
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

    
}
