//
//  DicionaryCollectionTest.swift
//  foundationTests
//
//  Created by Jordi Puigdellívol on 14/11/22.
//  Copyright © 2022 Revo Systems. All rights reserved.
//

import XCTest

final class DicionaryCollectionTest: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func test_can_flip_a_dictionary(){
        let a = [
            "a" : 1,
            "b" : 2,
            "c" : 3
        ]
        
        let result = a.flip()
        
        XCTAssertEqual([1: "a", 2:"b", 3:"c"], result)
    }
    
    func test_can_flip_a_dictionary_with_duplicated_values(){
        let a = [
            "a" : 1,
            "b" : 2,
            "c" : 3,
            "d" : 3
        ]
        
        let result = a.flip()
        
        XCTAssertEqual([1: "a", 2:"b", 3:"d"], result)
    }

    func test_can_get_dictionary_except_keys(){
        let a = [
            "a" : 1,
            "b" : 2,
            "c" : 3,
            "d" : 3
        ]
        
        let result = a.except(["b", "d"])
        
        XCTAssertEqual(["a" : 1, "c": 3], result)
    }
    
    func test_can_get_dictionary_with_only_keys(){
        let a = [
            "a" : 1,
            "b" : 2,
            "c" : 3,
            "d" : 3
        ]
        
        let result = a.only(["b", "d"])
        
        XCTAssertEqual(["b" : 2, "d": 3], result)
    }
    
    func test_can_forget_keys(){
        var a = [
            "a" : 1,
            "b" : 2,
            "c" : 3,
            "d" : 3
        ]
        
        a.forget(["b", "c", "d"])
        
        XCTAssertEqual(["a" : 1], a)
    }
}
