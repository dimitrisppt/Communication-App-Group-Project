//
//  SettingsViewControllerTests.swift
//  SpiderByteTests
//
//  Created by Sadi Ashraful on 28/03/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import Foundation
import XCTest
@testable import SpiderByte


class SettingsViewControllerTests: XCTestCase {
    
    var svc: SettingsViewController!
    
    
    override func setUp() {
        super.setUp()
        svc = SettingsViewController ()
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
