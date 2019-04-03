//
//  AuthorizationService.swift
//  Wathcer
//
//  Created by Петр Первухин on 13/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient

protocol AuthorizationServiceProtocol {
    func authorize(email: String, password: String, 
                   completionHandler: @escaping (AuthorizationData?, String?) -> Void)
}

///Сервис для авторизации  
final class AuthorizationService: AuthorizationServiceProtocol {
        
    // MARK: - Private Properties

    private let apiClient: ApiClientProtocol
    
    
    // MARK: - Initialization

    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
        

    // MARK: - Public Methods

    ///Метод для отправки post запроса с email и password для аутентификации. 
    ///В completionHanler возвращает ответ с сервера AuthorizationData и сообщение об ошибке
    public func authorize(email: String, password: String, 
                          completionHandler: @escaping (AuthorizationData?, String?) -> Void) {
        let endpoint = AuthorizationEndpoint(email: email, password: password)
       
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
