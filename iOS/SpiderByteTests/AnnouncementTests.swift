//
//  AnnouncementTests.swift
//  SpiderByteTests
//
//  Created by Sadi Ashraful on 28/03/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import XCTest
import Foundation
@testable import SpiderByte
class AnnouncementTests: XCTestCase {
    var announcement : Announcement
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidAnnouncementWithAllFields() {
        announcement = Announcement(author: "Test", title: "TestTitle", content: "**Content**", tag: "General", dateTime: "2018-03-20 18:40:00", mailingList: ["all"], readingList: ["none"], pdf: "", priority: -1, hasEvent: 0)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
