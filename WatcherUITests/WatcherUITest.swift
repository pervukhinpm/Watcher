//
//  WatcherUITest.swift
//  WatcherUITests
//
//  Created by Петр Первухин on 31/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import XCTest

class WatcherUITest: XCTestCase {

    
    func testExample() {
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        snapshot("01")
        
        /*
        let emailTextField = app.textFields.matching(identifier: "emailIdentifier").firstMatch
        emailTextField.tap()
        emailTextField.typeText("test@mail.ru")
        
        let passwordTextField = app.secureTextFields.matching(identifier: "passwordIdentifier").firstMatch
        passwordTextField.tap()
        passwordTextField.typeText("password")
        
        let enterButton = app.buttons.matching(identifier: "enterIdentifier").firstMatch
        enterButton.tap()
    
        let setButton = app.buttons.matching(identifier: "setIdentifier").firstMatch
        setButton.tap()
        
        snapshot("02")
        
        let fiveButton = app.buttons.matching(identifier: "fivePinIdentifier").firstMatch
        
        fiveButton.tap()
        fiveButton.tap()
        fiveButton.tap()
        fiveButton.tap()
        app.buttons["Нет, спасибо"].tap()
        snapshot("03")
        */
        
    }

}
