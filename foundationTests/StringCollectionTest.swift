//
//  StringCollectionTest.swift
//  foundationTests
//
//  Created by Jordi Puigdellívol on 15/10/2019.
//  Copyright © 2019 Revo Systems. All rights reserved.
//

import XCTest

@testable import RevoFoundation

class StringCollectionTest: XCTestCase {

    override func setUp() {}

    override func tearDown() {}

    func test_lpad() {
        let string = "abc"
        let result = string.lpad(toLength:10, withPad:"0")
        
        XCTAssertEqual("0000000abc", result)
    }
    
    func test_rpad() {
        let string = "abc"
        let result = string.rpad(toLength:10, withPad:"0")
        
        XCTAssertEqual("abc0000000", result)
    }

}
