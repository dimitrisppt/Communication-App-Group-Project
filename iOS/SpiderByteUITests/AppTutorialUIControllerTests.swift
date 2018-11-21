//
//  AppTutorialUIController.swift
//  SpiderByteUITests
//
//  Created by Sadi Ashraful on 29/03/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import XCTest

class AppTutorialUIControllerTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        
        
        let app = XCUIApplication()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2)
        element.swipeLeft()
        element.swipeLeft()
        element.swipeLeft()
        element.swipeLeft()
        element.swipeLeft()
        
        
        let element2 = app.otherElements.containing(.button, identifier:"GET STARTED ").children(matching: .other).element.children(matching: .other).element(boundBy: 2)
        element2.swipeRight()
        element2.swipeRight()
       
        app.buttons["GET STARTED "].tap()
        
        
    }
    
}
