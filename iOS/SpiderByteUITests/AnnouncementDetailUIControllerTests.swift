//
//  AnnouncementDetailUIViewController.swift
//  SpiderByteUITests
//
//  Created by Sadi Ashraful on 29/03/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import XCTest

class AnnouncementDetailUIControllerTestsm : XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        
        
        let app = XCUIApplication()
        app.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Hello, I have attached the information for the Robotics Event next week"]/*[[".cells.staticTexts[\"Hello, I have attached the information for the Robotics Event next week\"]",".staticTexts[\"Hello, I have attached the information for the Robotics Event next week\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let element3 = app.otherElements.containing(.navigationBar, identifier:"Announcement Detail").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let element = element3.children(matching: .other).element(boundBy: 1)
        element.tap()
        
        let element2 = element3.children(matching: .other).element(boundBy: 2).children(matching: .other).element
        element2.tap()
        app.alerts["Robotics Meetup"].buttons["Close"].tap()
        
        let backButton = app.navigationBars["Announcement Detail"].buttons["Back"]
        backButton.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Coursework PDF"]/*[[".cells.staticTexts[\"Coursework PDF\"]",".staticTexts[\"Coursework PDF\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        element.tap()
        element2.tap()
        app.navigationBars["Document"].buttons["Announcement Detail"].tap()
        backButton.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["KCL Logo"]/*[[".cells.staticTexts[\"KCL Logo\"]",".staticTexts[\"KCL Logo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        backButton.tap()
        
        
        
        
        
    }
    
}
