//
//  CheckAuthorizationService.swift
//  Watcher
//
//  Created by Петр Первухин on 12/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient

protocol AuthorizationCheckServiceProtocol {
    func checkAuthorization(completionHandler: @escaping (AuthorizationCheckData?, String?) -> Void)
}

///Сервис для авторизации  
final class AuthorizationCheckService: AuthorizationCheckServiceProtocol {

    // MARK: - Private Properties

    private let apiClient: ApiClientProtocol
    
    
    // MARK: - Initialization

    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    

    // MARK: - Public Methods

    ///Метод для отправки get запроса для проверки аутентификации. 
    ///В completionHanler возвращает ответ с сервера AuthorizationCheckData и сообщение об ошибке
    public func checkAuthorization(completionHandler: @escaping (AuthorizationCheckData?, String?) -> Void) {
        let endpoint = AuthorizationCheckEndpoint()
        apiClient.request(with: endpoint) { (result) in
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
