import XCTest

@testable import RevoFoundation

class ArrayCollectionTest: XCTestCase {

    override func setUp()   {}

    override func tearDown() {}

    func test_each() {
        let a       = [1, 2, 3]
        var b:[Int] = []
        
        a.each { b.append($0) }
        
        XCTAssertEqual(a, b)
    }

    
    func test_slice() {
        let collection = [1, 2, 3, 4]
        let slice      = collection.slice(3)
        
        XCTAssertEqual([4], slice)
        XCTAssertEqual([1, 2, 3, 4], collection)
        
        
        let slice2      = collection.slice(6)
        XCTAssertEqual([], slice2)
        
    }

    func test_slice_with_count() {
        let collection = [1, 2, 3, 4, 5]
        let slice      = collection.slice(2, howMany: 2)
        
        XCTAssertEqual([3, 4], slice)
        XCTAssertEqual([1, 2, 3, 4, 5], collection)
        
        let slice2      = collection.slice(2, howMany: 6)
        XCTAssertEqual([3, 4, 5], slice2)
    }
    
    func test_sort(){
        var collection = [6, 5, 7, 8 , 1]
            collection.sort()
        XCTAssertEqual([1, 5, 6, 7, 8], collection)
    }
    
    func test_sort_by(){
        struct testStruct {
            let name : String
        }
        
        let collection = [
            testStruct(name: "b"),
            testStruct(name: "c"),
            testStruct(name: "a"),
        ]
        
        let result = collection.sort(by: \.name)
        XCTAssertEqual("a", result.first!.name)
    }
    
    func test_firstWhere() {
        struct testStruct {
            let name : String
        }
        
        let collection = [
            testStruct(name: "b"),
            testStruct(name: "c"),
            testStruct(name: "a"),
        ]
        
        let value = collection.firstWhere(\.name, is: "c")
        let notFound = collection.firstWhere(\.name, is: "x")
        
        XCTAssertEqual("c", value!.name)
        XCTAssertNil(notFound)
    }
    
    func test_firstWhere_with_default() {
        struct testStruct {
            let name : String
        }
        
        let collection = [
            testStruct(name: "b"),
            testStruct(name: "c"),
            testStruct(name: "a"),
        ]
        
        let value = collection.firstWhere(\.name, is: "c")
        let notFound = collection.firstWhere(\.name, is: "x", defaultValue: testStruct(name: "z"))
        
        XCTAssertEqual("c", value!.name)
        XCTAssertEqual("z", notFound!.name)
    }
    
    func test_splice(){
        var collection = [1, 2, 3, 4, 5]
        let splice     = collection.splice(2)
        
        XCTAssertEqual([1, 2], collection)
        XCTAssertEqual([3, 4, 5], splice)
    }
    
    func test_splice_with_limit(){
        var collection = [1, 2, 3, 4, 5]
        let splice     = collection.splice(2, limit:2)
        
        XCTAssertEqual([1, 2, 5], collection)
        XCTAssertEqual([3, 4], splice)
    }
    
    func test_splice_with_limit_and_replace(){
        var collection = [1, 2, 3, 4, 5]
        let splice     = collection.splice(2, limit:2, replaceWith:[10, 11])
        
        XCTAssertEqual([1, 2, 10, 11, 5], collection)
        XCTAssertEqual([3, 4], splice)
    }
    
    func test_split(){
        let collection = [1, 2, 3, 4, 5]
        let splitted = collection.split(2)
        
        XCTAssertEqual([[1, 2, 3],[4, 5]] , splitted)
        
    }
    
    func test_take(){
        let collection = [1, 2, 3, 4, 5]
        let chunk = collection.take(3)
        
        XCTAssertEqual([1, 2, 3], chunk)
    }
    
    func test_take_negative(){
        let collection = [1, 2, 3, 4, 5]
        let chunk = collection.take(-2)
        
        XCTAssertEqual([4, 5], chunk)
    }
    
    func test_tap(){
        var called = false
        let collection = [1, 2, 3, 4, 5]
        collection.tap{
            XCTAssertEqual(collection, $0)
            called = true
        }
        XCTAssertTrue(called)
    }
    
    /*func test_sum(){
        let collection = [1, 2, 3, 4, 5]
        
        XCTAssertEqual(15, collection.sum())
    }*/
    
    
}
