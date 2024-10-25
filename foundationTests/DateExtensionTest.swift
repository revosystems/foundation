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
    
    func test_can_init_with_iso8601_string(){
        let date = Date(string: "2020-06-25T11:48:46.000000Z")
        XCTAssertEqual("2020-06-25 11:48:46 +0000", date?.description)
        
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
                
        XCTAssertTrue(date1!.sameDayAs(date2!))
        
        let date3 = Date(string: "2019-01-02 04:12:00")
        let date4 = Date(string: "2019-01-01 00:12:00")
                
        XCTAssertFalse(date3!.sameDayAs(date4!))
    }
    
    func test_can_find_difference_in_hours(){
        
        let date1 = Date(string: "2024-10-25 15:50:00")
        let date2 = Date(string: "2024-10-25 16:54:00")
        
        XCTAssertEqual(1, date1!.diffInHours(date2!))
    }
    
    func test_can_find_difference_in_minutes(){
        
        let date1 = Date(string: "2024-10-25 15:50:00")
        let date2 = Date(string: "2024-10-25 15:54:00")
        
        XCTAssertEqual(4, date1!.diffInMinutes(date2!))
    }
    
    func test_can_find_difference_in_seconds(){
        
        let date1 = Date(string: "2024-10-25 15:50:00")
        let date2 = Date(string: "2024-10-25 15:54:10")
        
        XCTAssertEqual(4 * 60 + 10,  date1!.diffInSeconds(date2!))
        
    }
}
