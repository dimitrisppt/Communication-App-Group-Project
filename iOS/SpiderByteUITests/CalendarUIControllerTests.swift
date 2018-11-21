//
//  CalendarUIControllerTests.swift
//  SpiderByteUITests
//
//  Created by Sadi Ashraful on 29/03/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import XCTest

class CalendarUIControllerTests: XCTestCase {
        
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
        app.tabBars.buttons["Calendar"].tap()
        
        let collectionViewsQuery2 = app.collectionViews
        let collectionViewsQuery = collectionViewsQuery2
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["29\r ."]/*[[".cells.staticTexts[\"29\\r .\"]",".staticTexts[\"29\\r .\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["30\r ."]/*[[".cells.staticTexts[\"30\\r .\"]",".staticTexts[\"30\\r .\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Important Meeting"]/*[[".cells.staticTexts[\"Important Meeting\"]",".staticTexts[\"Important Meeting\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let cellsQuery = collectionViewsQuery2.cells
        cellsQuery.otherElements.containing(.staticText, identifier:"31\r .").element.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["You must vote by this date"]/*[[".cells.staticTexts[\"You must vote by this date\"]",".staticTexts[\"You must vote by this date\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        cellsQuery.otherElements.containing(.staticText, identifier:"21\r .").element/*@START_MENU_TOKEN@*/.swipeLeft()/*[[".swipeDown()",".swipeLeft()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        let cell = collectionViewsQuery2.children(matching: .cell).element(boundBy: 32)
        cell.otherElements.containing(.staticText, identifier:"25\r .").element.swipeUp()
        collectionViewsQuery2.children(matching: .cell).element(boundBy: 1).otherElements.containing(.staticText, identifier:"2\r .").element.swipeRight()
        collectionViewsQuery2.children(matching: .cell).element(boundBy: 10).staticTexts["11\r ."].tap()
        
        let staticText = collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["19\r ."]/*[[".cells.staticTexts[\"19\\r .\"]",".staticTexts[\"19\\r .\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        staticText.tap()
        
        let cell2 = collectionViewsQuery2.children(matching: .cell).element(boundBy: 33)
        cell2.otherElements.containing(.staticText, identifier:"4\r .").element.swipeLeft()
        cell.otherElements.containing(.staticText, identifier:"27\r .").element.swipeUp()
        
        let cell3 = collectionViewsQuery2.children(matching: .cell).element(boundBy: 16)
        cell3.staticTexts["19\r ."].swipeRight()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["14\r ."]/*[[".cells.staticTexts[\"14\\r .\"]",".staticTexts[\"14\\r .\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["18\r ."]/*[[".cells.staticTexts[\"18\\r .\"]",".staticTexts[\"18\\r .\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        cell2.otherElements.containing(.staticText, identifier:"29\r .").element.swipeLeft()
        cellsQuery.otherElements.containing(.staticText, identifier:"24\r .").element.swipeUp()
        cell3.otherElements.containing(.staticText, identifier:"16\r .").element.swipeRight()
        
        let element = cellsQuery.otherElements.containing(.staticText, identifier:"26\r .").element
        element.tap()
        cellsQuery.otherElements.containing(.staticText, identifier:"13\r .").element.swipeLeft()
        collectionViewsQuery2.children(matching: .cell).element(boundBy: 11).staticTexts["4\r ."].tap()
        collectionViewsQuery2.children(matching: .cell).element(boundBy: 27).staticTexts["18\r ."].tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["20\r ."]/*[[".cells.staticTexts[\"20\\r .\"]",".staticTexts[\"20\\r .\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
        collectionViewsQuery2.children(matching: .cell).element(boundBy: 38).otherElements.containing(.staticText, identifier:"28\r .").element.swipeLeft()
        cell.otherElements.containing(.staticText, identifier:"29\r .").element/*@START_MENU_TOKEN@*/.swipeRight()/*[[".swipeUp()",".swipeRight()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        staticText.tap()
        element.swipeLeft()
        
        _ = XCUIApplication().collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 40).otherElements.containing(.staticText, identifier:"4\r .").element/*@START_MENU_TOKEN@*/.swipeRight()/*[[".swipeUp()",".swipeRight()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["24\r ."]/*[[".cells.staticTexts[\"24\\r .\"]",".staticTexts[\"24\\r .\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["28\r ."]/*[[".cells.staticTexts[\"28\\r .\"]",".staticTexts[\"28\\r .\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
}
