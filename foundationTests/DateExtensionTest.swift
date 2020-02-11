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
        XCTAssertEqual("2019-01-01 12:00:00 +0000", date?.description)
    }
    
    func test_can_init_from_date_string() {
        let date = Date(string: "2019-01-01")
        XCTAssertEqual("2019-01-01 00:00:00 +0000", date?.description)
    }
    
    func test_can_init_with_string_and_timezone(){
        let date = Date(string: "2019-01-01", timeZone: TimeZone(secondsFromGMT: 3600)!)
        XCTAssertEqual("2018-12-31 23:00:00 +0000", date?.description)
    }
    
    func test_can_convert_to_full_string(){
        let date = Date(string: "2019-01-01 15:45:23")
        XCTAssertEqual("2019-01-01 15:45:23", date?.toDatetime)
    }
    
    func test_can_convert_to_simple_date(){
        let date = Date(string: "2019-01-01 15:45:23")
        XCTAssertEqual("2019-01-01 15:45", date?.toDatetimeWithoutSeconds)
    }
    
    func test_can_convert_to_date_string(){
        let date = Date(string: "2019-01-01 15:45:23")
        XCTAssertEqual("2019-01-01", date?.toDate)
    }
    
    func test_can_convert_to_time_string(){
        let date = Date(string: "2019-01-01 15:45:23")
        XCTAssertEqual("15:45:23", date?.toTime)
    }

    func test_can_convert_to_localized_string(){
        let date = Date(string: "2019-01-01 15:45:23")
        XCTAssertEqual("1/1/19", date?.toDateTimeLocalized)
    }
    
    func test_can_convert_to_deviceTimeZone_string(){
        NSTimeZone.default = NSTimeZone(forSecondsFromGMT: 3600) as TimeZone
        
        let date = Date(string: "2019-01-01 15:45:23")
        XCTAssertEqual("2019-01-01 16:45:23", date?.toDeviceTimezone)
    }
    
    func test_can_convert_to_devicetimezone_format() {
        NSTimeZone.default = NSTimeZone(forSecondsFromGMT: 3600) as TimeZone
        
        let date = Date(string: "2019-01-01 23:12:00")
        XCTAssertEqual("2019-01-02", date?.toDeviceTimezone(.date))
    }
    
    func test_can_check_if_dates_are_same_day(){
        let date1 = Date(string: "2019-01-01 20:12:00")
        let date2 = Date(string: "2019-01-01 13:12:00")
        
        XCTAssertTrue(date1!.sameDayAs(date2!))
    }
    
    func test_can_check_if_dates_are_same_day_with_device_timezone(){
        NSTimeZone.default = NSTimeZone(forSecondsFromGMT: -3600) as TimeZone
        let date1 = Date(string: "2019-01-02 00:12:00")
        let date2 = Date(string: "2019-01-01 13:12:00")
                
        XCTAssertFalse(date1!.sameDayAs(date2!))
        
        let date3 = Date(string: "2019-01-02 00:12:00")
        let date4 = Date(string: "2019-01-01 23:12:00")
                
        XCTAssertTrue(date3!.sameDayAs(date4!))
    }
}
