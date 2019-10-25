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

    /*func test_non_registered_class_returns_itself() {
        struct TestStruct{ }
        let container = Container()
        let result = container.resolve(TestStruct.self)
        XCTAssertTrue(result == TestStruct.self)
    }*/
    
    func test_can_make_non_registered_class(){
        struct TestStruct{ }
        let container = Container()
        let result = try? container.make(TestStruct.self)
        //TODO: Make this work so it doesn't return nil
        XCTAssertNil(result)
    }
    
    func test_can_bind_clousure(){
        struct TestStruct{ let name:String }
        let container = Container()
        
        container.bind(TestStruct.self) {
            TestStruct(name: "Sexy")
        }
        
        var result = try! container.make(TestStruct.self)
        XCTAssertEqual("Sexy", result.name)
        
        container.bind(TestStruct.self) {
            TestStruct(name: "Not Sexy")
        }
        result = try! container.make(TestStruct.self)
        XCTAssertEqual("Not Sexy", result.name)
    }
    
    func test_closure_binding_is_not_a_singleton(){
        class TestStruct{ let name:String = "Sexy" }
        let container = Container()
        
        container.bind(TestStruct.self) {
            TestStruct()
        }
        let result1 = try! container.make(TestStruct.self)
        let result2 = try! container.make(TestStruct.self)
        
        XCTAssertFalse(result1 === result2)
        
    }
    
    func test_can_bind_a_singleton() {
        class TestStruct{ let name:String = "Sexy" }
        let container = Container()
        
        container.singleton(TestStruct.self) {
            TestStruct()
        }
        let result1 = try! container.make(TestStruct.self)
        let result2 = try! container.make(TestStruct.self)
        
        XCTAssertTrue(result1 === result2)
    }
    
    func test_can_bind_an_instance(){
        class TestStruct{ let name:String = "Sexy" }
        let container = Container()
        
        let instance = TestStruct()
        container.instance(TestStruct.self, instance)
        
        let result1 = try! container.make(TestStruct.self)
        let result2 = try! container.make(TestStruct.self)
        
        XCTAssertTrue(result1 === instance)
        XCTAssertTrue(result2 === instance)
    }
    
    func test_can_extend_a_resolver(){
        class TestStruct{ var name:String = "Sexy" }
        let container = Container()
        
        let instance = TestStruct()
        container.instance(TestStruct.self, instance)
        
        container.extend(TestStruct.self) {
            $0.name = "Super Sexy"
        }
        
        let result = try! container.make(TestStruct.self)
        XCTAssertEqual("Super Sexy", result.name)
    }

    func test_can_bind_a_type(){
        class TestStruct{ var name:String = "Sexy" }
        class TestStruct2: TestStruct {  }
        let container = Container()
        
        container.bind(TestStruct.self, bind: TestStruct2.init)
        
        let result = try! container.make(TestStruct.self)
        XCTAssertTrue(result is TestStruct2)
    }
    
    
    func test_can_autoinject(){
        
        class TestStruct{ var name:String = "Sexy" }
        class TestStruct2: TestStruct {  }
        
        Container.shared.bind(TestStruct.self, bind: TestStruct2.init)
        
        class TestStruct3{
            @Inject var theStruct:TestStruct
        }
        
        let result = TestStruct3()
        XCTAssertTrue(result.theStruct is TestStruct2)
    }
    
    //TODO: Bind and resolve with tags
    
}
