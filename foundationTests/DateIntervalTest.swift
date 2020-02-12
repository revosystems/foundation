//
//  DateIntervalTest.swift
//  foundationTests
//
//  Created by Jordi Puigdellívol on 12/02/2020.
//  Copyright © 2020 Revo Systems. All rights reserved.
//

import XCTest

class DateIntervalTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_can_get_spaced_dates_from_interval() {
        let interval = DateInterval(start: Date(string: "2020-02-11 09:32:00")!,
                                    end:   Date(string: "2020-02-11 13:32:00")!)
        
        let result = interval.toDates(every: 30)
        
        let expectation = [
            Date(string: "2020-02-11 10:00:00"),
            Date(string: "2020-02-11 10:30:00"),
            Date(string: "2020-02-11 11:00:00"),
            Date(string: "2020-02-11 11:30:00"),
            Date(string: "2020-02-11 12:00:00"),
            Date(string: "2020-02-11 12:30:00"),
            Date(string: "2020-02-11 13:00:00"),
            Date(string: "2020-02-11 13:30:00"),
        ]
        
        XCTAssertEqual(expectation, result)
    }

}
