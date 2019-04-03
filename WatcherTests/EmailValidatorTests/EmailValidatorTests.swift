//
//  WathcerTests.swift
//  WathcerTests
//
//  Created by Петр Первухин on 13/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

@testable import Watcher
import XCTest

class EmailValidatorTests: XCTestCase {
    
    func testEmailValidatorWithEmptyString() {
        let result = EmailValidator.isValidEmail(email: "")
        XCTAssertEqual(result, false)
    }
    
    func testEmailValidatorWithNoAtSymbol() {
        let result = EmailValidator.isValidEmail(email: "badmailredMadRobot.com")
        XCTAssertEqual(result, false)
    }
    
    func testEmailValidatorWithNoDomain() {
        let result = EmailValidator.isValidEmail(email: "bad@mailredMadRobot")
        XCTAssertEqual(result, false)
    }
    
    func testEmailValidatorWithNoComponents() {
        let result = EmailValidator.isValidEmail(email: "badmailredMadRobot")
        XCTAssertEqual(result, false)
    }
    
    func testEmailValidatorWithMultipleValidEmails() {
        let result = EmailValidator.isValidEmail(email: "badmail@redMadRobot.com veryBadmail@redMadRobot.com")
        XCTAssertEqual(result, false)
    }
    
    func testEmailValidatorWithValidEmail() {
        let result = EmailValidator.isValidEmail(email: "badmail@redMadRobot.com")
        XCTAssertEqual(result, true)
    }
}
