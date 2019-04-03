//
//  Endpoint.swift
//  Watcher
//
//  Created by Петр Первухин on 19/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

///protocol Endpoint для создания request'a и парсинга имеет associatedtype Response
public protocol Endpoint {
    
    associatedtype Response
    
    ///Функция для создания запроса
    ///
    /// - Throws: error если urlRequest не может быть создан
    ///
    /// - Returns: возвращает URLRequest.
    func request() throws -> URLRequest
    
    ///Функция для парсинга
    ///
    /// - Throws: error если произошла ошибка при парсинге
    ///
    /// - Parameter response: Data для парсинга
    /// - Returns: возвращает ассоциативный тип Response
    func parse(response: Data) throws -> Response
}
