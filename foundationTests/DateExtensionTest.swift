//
//  DateExtensionTest.swift
//  foundationTests
//
//  Created by Jordi Puigdellívol on 11/10/2019.
//  Copyright © 2019 Revo Systems. All rights reserved.
//

import XCTest

class DateExtensionTest: XCTestCase {

    override func setUp() { }
    override func tearDown() { }

    func test_can_init_from_dateTime_string() {
        let date = Date(string: "2019-01-01 12:00:00")
        XCTAssertEqual("2019-01-01 11:00:00 +0000", date?.description)
    }
    
    /*func test_can_init_from_date_string() {
        let date2 = Date(string: "2019-01-01")
        XCTAssertEqual("2019-01-01 00:00:00 +0000", date2?.description)
    }*/
    
    func test_can_convert_to_full_string(){
        let date = Date(string: "2019-01-01 15:45:23")
        XCTAssertEqual("2019-01-01 15:45:23", date?.toDatetimeString)
    }
    
    func test_can_convert_to_simple_date(){
        let date = Date(string: "2019-01-01 15:45:23")
        XCTAssertEqual("2019-01-01 15:45", date?.toSimpleDatetimeString)
    }
    
    func test_can_convert_to_date_string(){
        let date = Date(string: "2019-01-01 15:45:23")
        XCTAssertEqual("2019-01-01", date?.toDateString)
    }
    
    func test_can_convert_to_time_string(){
        let date = Date(string: "2019-01-01 15:45:23")
        XCTAssertEqual("15:45:23", date?.toTimeString)
    }

    func test_can_convert_to_localized_string(){
        let date = Date(string: "2019-01-01 15:45:23")
        XCTAssertEqual("1/1/19", date?.toDateTimeLocalized)
    }
}
