//
//  ApiLoaderTests.swift
//  WathcerTests
//
//  Created by Петр Первухин on 19/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

@testable import apiClient
import XCTest

class ApiLoaderTests: XCTestCase {
    
    var client: ApiClient!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        client = ApiClient(configuration: configuration)
    }
    
    func testLoaderSuccess() {
        let json1 = "{\"data\": {\"projects\": [{\"id\": 1,\"is_commercial\": true"
        let json2 = ",\"is_archived\": false,\"name\": \"Watcher 2\",\"managers\": []}]}}"
        let json = json1 + json2
        let mockJSONData = json.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let url = "https://watcher.intern.redmadrobot.com/api/v1/projects/"
            XCTAssertEqual(request.url, URL(string: url))
            return (HTTPURLResponse(), mockJSONData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        expectation.fulfill() 
        let projectEndpoint = ProjectEndpoint()
        
        client.request(with: projectEndpoint) { (result) in
            switch result {
            case .success(let model):
                let projectData = ProjectData(
                    projects: [Project(id: 1, name: "Watcher 2")])
          
                
                XCTAssertEqual(model.projects, projectData.projects)
                expectation.fulfill()
            case .failure(let error):
                print(error)
            case .statusCode(let code):
                print(code)
            }
        }
        wait(for: [expectation], timeout: 1)
        }
    }

class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func stopLoading() {
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(
                self,
                didReceive: response,
                cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        } 
    }
    
}
