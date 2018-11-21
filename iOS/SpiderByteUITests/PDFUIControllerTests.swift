//
//  PDFUIControllerTests.swift
//  SpiderByteUITests
//
//  Created by Sadi Ashraful on 29/03/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import XCTest

class PDFUIControllerTests: XCTestCase {
        
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
        app.otherElements.containing(.navigationBar, identifier:"Announcement Detail").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).children(matching: .other).element.tap()
        
        let element = app.scrollViews.children(matching: .other).element.children(matching: .other).element
        element.tap()
        element.tap()
        app.navigationBars["Document"].buttons["Announcement Detail"].tap()
        
    }
    
}
