//
//  ProjectEndpointTest.swift
//  WatcherTests
//
//  Created by Петр Первухин on 20/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

@testable import Alamofire
@testable import apiClient

import XCTest

class ProjectEndpointTest: XCTestCase {
   
    var projectEndpoint: MockProjectEndpoint!

    override func setUp() {
        super.setUp()
        projectEndpoint = MockProjectEndpoint()
    }
    
    override func tearDown() {
        projectEndpoint = nil
        super.tearDown()
    }
    
    func testProjectEndpointUrlRequest() {
        do {
            let request = try projectEndpoint.request()
            XCTAssertEqual(request.url, URL(string: "https://test.com/"))
            XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
        } catch let error {
            print(error)
        }
    }
    
    func testProjectEndpointParsing() {
        let json1 = "{\"data\": {\"projects\": [{\"id\": 1,\"is_commercial\": true"
        let json2 = ",\"is_archived\": false,\"name\": \"Watcher 2\",\"managers\": []}]}}"
        let json = json1 + json2
        let mockJSONData = json.data(using: .utf8)!
        
        let projectData = ProjectData(projects: [Project(id: 1,
                                                         name: "Watcher 2")])
        do {
            let parsingProjectData = try projectEndpoint.parse(response: mockJSONData)
            XCTAssertEqual(parsingProjectData.projects, projectData.projects)
        } catch let error {
            XCTAssertFalse(false, error.localizedDescription)
        }
        
    }

}

class MockProjectEndpoint: Endpoint {
    
    typealias Response = ProjectData
    
    private var urlString: String = "https://test.com/"
    
    func request() throws -> URLRequest {
        guard let url = URL(string: urlString) else { 
            throw EndpointError.invalidUrl 
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        return request
    }
    
    func parse(response: Data) throws -> ProjectData {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData = try decoder.decode(APIResponse<ProjectData>.self, from: response)
        return decodedData.data
    }
    
}
