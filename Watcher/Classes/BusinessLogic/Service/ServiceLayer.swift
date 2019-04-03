//
//  ServiceLayer.swift
//  Watcher
//
//  Created by Петр Первухин on 21/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import KeychainSwift
import Persistancy

protocol ServiceLayerProtocol {
    var authorizationService: AuthorizationServiceProtocol { get }
    var daysLogTimeService: DaysLoggedTimeServiceProtocol { get }
    var projectService: ProjectServiceProtocol { get }
    var logTimeService: LogTimeServiceProtocol { get }
    var calendarService: CalendarServiceProtocol { get }
    var securityService: SecurityServiceProtocol { get }
    var authorizationCheckService: AuthorizationCheckServiceProtocol { get }
}

final class ServiceLayer: ServiceLayerProtocol {
    
    // MARK: - Shared
    
    static let shared = ServiceLayer()
    
    
    // MARK: - Public Properties
    
    var daysLogTimeService: DaysLoggedTimeServiceProtocol
    var authorizationService: AuthorizationServiceProtocol
    var projectService: ProjectServiceProtocol
    var logTimeService: LogTimeServiceProtocol
    var calendarService: CalendarServiceProtocol
    var securityService: SecurityServiceProtocol
    var authorizationCheckService: AuthorizationCheckServiceProtocol 
    public let realmPersistancy = RealmPersistancy()
    public let sqlitePersistancy = SQLPersistancy()
    public let grdbPersistancy = GRDBPersistancy()
    
    
    // MARK: - Private Properties

    private let apiClient = ApiClient()

    
    
    // MARK: - Initialization

    init() {
        self.daysLogTimeService = DaysLoggedTimeService(apiClient: apiClient, 
                                                        realmPersistancy: realmPersistancy,
                                                        grdbPersistancy: grdbPersistancy,
                                                        sqlPersistancy: sqlitePersistancy) 
        self.projectService = ProjectService(apiClient: apiClient, 
                                             realmPersistancy: realmPersistancy,
                                             grdbPersistancy: grdbPersistancy,
                                             sqlPersistancy: sqlitePersistancy)
        self.authorizationService = AuthorizationService(apiClient: apiClient)
        self.logTimeService = LogTimeService(apiClient: apiClient)
        self.calendarService = CalendarService(apiClient: apiClient)
        self.securityService = SecurityService()
        self.authorizationCheckService = AuthorizationCheckService(apiClient: apiClient)
    }
    
}
