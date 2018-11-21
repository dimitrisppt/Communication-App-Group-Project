//
//  CalendarViewControllerTests.swift
//  SpiderByteTests
//
//  Created by Sadi Ashraful on 28/03/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import XCTest
@testable import SpiderByte
class CalendarViewControllerTests: XCTestCase {
    
    var cvc: CalendarViewController!
    
    internal func testInit_SetOutsideMonthColor(){
        
        let oMonthColor = UIColor(hexString: "#E6E6E6")
        XCTAssertEqual(cvc.outsideMonthColor, oMonthColor)
    }
    
    internal func testInit_SetMonthColor(){
        
        let mColor = UIColor(colorWithHexValue: 0x584a66)
        XCTAssertEqual(cvc.monthColor, mColor)
    }
    
    internal func testInit_SetSelectedMonthColor(){
        
        let sMonthColor = UIColor.white
        XCTAssertEqual(cvc.selectedMonthColor, sMonthColor)
    }
    
    internal func testInit_SetCurrentDateSelectedViewColor(){
      
        let cdsViewColor = UIColor.blue
        XCTAssertEqual(cvc.currentDateSelectedViewColor, cdsViewColor)
    }
    
    internal func testInit_SetIdentifier(){
       
        let i : String = "event"
        XCTAssertEqual(cvc.identifier, i)
    }
    

    
    internal func testInit_SetEventsFromTheServer(){
        
        let event: [String : String] = [:]
        XCTAssertEqual(cvc.eventsFromtheServer, event)
    }
    
    
    internal func testInit_SetAvailableEvents(){
        
        let av : NSMutableArray = []
        XCTAssertEqual(cvc.availableEvents, av)
    }
    
    internal func testInit_SetHiddenCells(){
      
        let hiddenC : NSMutableArray = []
        XCTAssertEqual(cvc.hiddenCells, hiddenC)
    }
    
    internal func testInit_SetFilteredEvents(){
      
        let fEvents = [Event]()
        XCTAssertEqual(cvc.filteredEvents, fEvents)
    }
    
    internal func testInit_SetAllEvents(){
        
        let allEvent = [Event]()
        XCTAssertEqual(cvc.allEvents, allEvent)
    }
    
//    internal func testInit_SetGivenCell(){
//      
//        let givenC = CustomCell ()
//        XCTAssertEqual(cvc.givenCell, givenC)
//    }
    
    override func setUp() {
        super.setUp()
        cvc = CalendarViewController ()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
