//
//  AnnouncementUIViewController.swift
//  SpiderByteUITests
//
//  Created by Sadi Ashraful on 29/03/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import XCTest

class AnnouncementUIControllerTests: XCTestCase {
        
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
        app.otherElements.containing(.navigationBar, identifier:"SpiderByte.TabBarView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).tap()
        
        let careersButton = app.buttons["Careers"]
        careersButton.tap()
        
        let modulesButton = app.buttons["Modules"]
        modulesButton.tap()
        app.buttons["Important"].tap()
        careersButton.tap()
        modulesButton.tap()
        app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"please work")/*[[".cells.containing(.staticText, identifier:\"2 hours ago\")",".cells.containing(.staticText, identifier:\"please work\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .staticText).matching(identifier: "please work").element(boundBy: 0).tap()
        app.navigationBars["Announcement Detail"].buttons["Back"].tap()
        
        let spiderbyteTabbarviewNavigationBar = app.navigationBars["SpiderByte.TabBarView"]
        spiderbyteTabbarviewNavigationBar.buttons["Search"].tap()
        spiderbyteTabbarviewNavigationBar.buttons["Cancel"].tap()
        
        let organizeButton = spiderbyteTabbarviewNavigationBar.buttons["Organize"]
        organizeButton.tap()
        
        let pleaseSelectHowYouWouldLikeToSortSheet = app.sheets["Please select how you would like to sort"]
        pleaseSelectHowYouWouldLikeToSortSheet.buttons["Sort by date"].tap()
        organizeButton.tap()
        pleaseSelectHowYouWouldLikeToSortSheet.buttons["Sort alphabetically"].tap()
        organizeButton.tap()
        pleaseSelectHowYouWouldLikeToSortSheet.buttons["Sort by author"].tap()
        
        _ = XCUIApplication()
        _ = app.navigationBars["SpiderByte.TabBarView"]
        _ = spiderbyteTabbarviewNavigationBar.buttons["Organize"]
        organizeButton.tap()
        
        _ = app.sheets["Please select how you would like to sort"]
        pleaseSelectHowYouWouldLikeToSortSheet.buttons["Sort by date"].tap()
        organizeButton.tap()
        pleaseSelectHowYouWouldLikeToSortSheet.buttons["Sort alphabetically"].tap()
        organizeButton.tap()
        pleaseSelectHowYouWouldLikeToSortSheet.buttons["Sort by author"].tap()
        spiderbyteTabbarviewNavigationBar.buttons["Search"].tap()
        spiderbyteTabbarviewNavigationBar.searchFields.containing(.button, identifier:"Clear text").element.typeText("Example\r")
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Example PDF"]/*[[".cells.staticTexts[\"Example PDF\"]",".staticTexts[\"Example PDF\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Announcement Detail"].buttons["Back"].tap()
        
    }
    
}
