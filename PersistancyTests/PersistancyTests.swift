//
//  PersistancyTests.swift
//  PersistancyTests
//
//  Created by Петр Первухин on 18/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

@testable import apiClient
@testable import Persistancy
import XCTest

class PersistancyTests: XCTestCase {
    
   // let grdbPersistancy = GRDBPersistancy()
    
    override func setUp() {

    }

    override func tearDown() {

    }
    
    
//    func test() {
//        
//        guard let loggedDays = readFile() else { 
//            XCTFail("loggedDays nil")
//            return 
//        }
//        
//        for day in loggedDays.days {
//            grdbPersistancy.saveLoggedDay(model: day)
//        }
//        let startDate = convertStringToDateFrom(dateString: "2019-02-17")
//        let endDate = convertStringToDateFrom(dateString: "2019-02-24") 
//        let savedLoggedDays = grdbPersistancy.loadLoggedDay(startDate: startDate, endDate: endDate)
//      
////        if savedLoggedDays == loggedDays {
////            
////        }
//        
//    }
//    
//    func readFile() -> LoggedDays? {
//        if let path = Bundle(for: type(of: self)).url(forResource: "LoggedDays", withExtension: "json") {
//            do {
//                let data = try Data(contentsOf: path, options: .mappedRead)
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let decodedData = try decoder.decode(APIResponse<LoggedDays>.self, from: data)
//                return decodedData.data
//            } catch let error {
//                print(error)
//            }
//        }
//        return nil
//    }
//    
//    func convertStringToDateFrom(dateString: String) -> Date {
//        let dateFormatter = getDateFormatter()
//        return dateFormatter.date(from: dateString)!
//    }
//    
//    func getDateFormatter() -> DateFormatter {
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(identifier: "GMT")
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.locale = Locale(identifier: "ru_RU")
//        return dateFormatter
//    }
}
