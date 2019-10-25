//
//  ContainerTest.swift
//  foundationTests
//
//  Created by Jordi Puigdellívol on 25/10/2019.
//  Copyright © 2019 Revo Systems. All rights reserved.
//

import XCTest
@testable import RevoFoundation

class ContainerTest: XCTestCase {

    override func setUp() {}

    override func tearDown() {}

    func test_non_registered_class_returns_itself() {
        struct TestStruct{ }
        let container = Container()
        let result = container.resolve(TestStruct.self)
        XCTAssertTrue(result == TestStruct.self)
    }
    
    func test_can_make_non_registered_class(){
        struct TestStruct{ }
        var container = Container()
        let result = container.make(TestStruct.self)
        //TODO: Make this work so it doesn't return nil
        XCTAssertNil(result)
    }
    
    func test_can_bind_clousure(){
        struct TestStruct{ let name:String }
        var container = Container()
        
        container.bind(TestStruct.self) {
            TestStruct(name: "Sexy")
        }
        
        var result = container.make(TestStruct.self)!
        XCTAssertEqual("Sexy", result.name)
        
        container.bind(TestStruct.self) {
            TestStruct(name: "Not Sexy")
        }
        result = container.make(TestStruct.self)!
        XCTAssertEqual("Not Sexy", result.name)
    }
    
    func test_closure_binding_is_not_a_singleton(){
        class TestStruct{ let name:String = "Sexy" }
        var container = Container()
        
        container.bind(TestStruct.self) {
            TestStruct()
        }
        let result1 = container.make(TestStruct.self)!
        let result2 = container.make(TestStruct.self)!
        
        XCTAssertFalse(result1 === result2)
        
    }
    
    func test_can_bind_a_singleton() {
        class TestStruct{ let name:String = "Sexy" }
        var container = Container()
        
        container.singleton(TestStruct.self) {
            TestStruct()
        }
        let result1 = container.make(TestStruct.self)!
        let result2 = container.make(TestStruct.self)!
        
        XCTAssertTrue(result1 === result2)
    }

}
