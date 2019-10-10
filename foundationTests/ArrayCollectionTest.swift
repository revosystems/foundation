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

    func test_reject(){
        let collection = [1, 2, 3, 4, 5]
        let result = collection.reject {
            $0 % 2 == 0
        }
        XCTAssertEqual([1, 2, 3, 4, 5], collection)
        XCTAssertEqual([1, 3, 5], result)
    }
    
    func test_remove(){
        var collection = [1, 2, 3, 4, 1, 2]
        collection.remove(object: 1)
        XCTAssertEqual([2, 3, 4, 1, 2], collection)
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
    
    func test_where_is(){
        struct testStruct {
            let name : String
        }
        
        let collection = [
            testStruct(name: "b"),
            testStruct(name: "c"),
            testStruct(name: "x"),
            testStruct(name: "a"),
            testStruct(name: "a"),
        ]
        
        let result = collection.allWhere(\.name, is:"a")
        XCTAssertEqual(2, result.count);
    }
    
    func test_where_is_not(){
        struct testStruct {
            let name : String
        }
        
        let collection = [
            testStruct(name: "b"),
            testStruct(name: "x"),
            testStruct(name: "c"),
            testStruct(name: "a"),
            testStruct(name: "a"),
        ]
        
        let result = collection.allWhere(\.name, isNot:"a")
        XCTAssertEqual(3, result.count);
    }
    
    func test_where_nil(){
        struct testStruct {
            let name : String?
        }
        
        let collection = [
            testStruct(name: "b"),
            testStruct(name: "c"),
            testStruct(name: "x"),
            testStruct(name: nil),
            testStruct(name: nil),
        ]
        
        let result = collection.whereNil(\.name)
        XCTAssertEqual(2, result.count);
    }
    
    func test_where_not_nil(){
        struct testStruct {
            let name : String?
        }
        
        let collection = [
            testStruct(name: "b"),
            testStruct(name: "c"),
            testStruct(name: "x"),
            testStruct(name: nil),
            testStruct(name: nil),
        ]
        
        let result = collection.whereNotNil(\.name)
        XCTAssertEqual(3, result.count);
    }
    
    func test_where_between(){
        let collection = [1, 2, 3, 4, 5, 6, 7, 8]
        let result     = collection.whereBetween(4, and:7)
        
        XCTAssertEqual([4, 5, 6, 7], result)
    }
    
    
    func test_where_between_with_keypath(){
        struct testStruct {
            let name : String
        }
        
        let collection = [
            testStruct(name: "a"),
            testStruct(name: "b"),
            testStruct(name: "c"),
            testStruct(name: "d"),
            testStruct(name: "e"),
        ]
        
        let result = collection.whereBetween(\.name, first: "b", last: "d")
        
        XCTAssertEqual(["b", "c", "d"], result.pluck(\.name))
    }
    
    func test_where_not_between_with_keypath(){
        struct testStruct {
            let name : String
        }
        
        let collection = [
            testStruct(name: "a"),
            testStruct(name: "b"),
            testStruct(name: "c"),
            testStruct(name: "d"),
            testStruct(name: "e"),
        ]
        
        let result = collection.whereNotBetween(\.name, first: "b", last: "d")
        
        XCTAssertEqual(["a", "e"], result.pluck(\.name))
    }
    
    func test_where_in() {
        struct testStruct {
            let name : String
        }
        
        let collection = [
            testStruct(name: "a"),
            testStruct(name: "b"),
            testStruct(name: "c"),
            testStruct(name: "d"),
            testStruct(name: "e"),
        ]
        
        let result = collection.whereIn(\.name, in: ["b","d"])
        
        XCTAssertEqual(["b","d"], result.pluck(\.name))
    }
    
    func test_where_not_in() {
        struct testStruct {
            let name : String
        }
        
        let collection = [
            testStruct(name: "a"),
            testStruct(name: "b"),
            testStruct(name: "c"),
            testStruct(name: "d"),
            testStruct(name: "e"),
        ]
        
        let result = collection.whereNotIn(\.name, in: ["b","d"])
        
        XCTAssertEqual(["a","c", "e"], result.pluck(\.name))
    }
    
    func test_zip(){
        let collection = [1, 2, 3]
        let collection2 = ["a", "b", "c"]
        
        let result = try! collection.zip(collection2)
        
        XCTAssertEqual([1:"a", 2:"b", 3:"c"], result)
    }
    
    func test_pluck(){
        struct testStruct {
            let name : String
        }
        
        let collection = [
            testStruct(name: "a"),
            testStruct(name: "b"),
            testStruct(name: "c"),
            testStruct(name: "d"),
            testStruct(name: "e"),
        ]
        
        let result = collection.pluck(\.name)
        
        XCTAssertEqual(["a", "b", "c", "d", "e"], result)
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
    
    func test_pipe(){        
        let collection = [1, 2, 3, 4, 5]
        let result = collection.pipe {
            return $0.reduce(0, +)
        }
        XCTAssertEqual(15, result)
    }
    
    func test_times() {
        let result = Array<String>.times(5) {index in
            return "a \(index)"
        }
        XCTAssertEqual(["a 0", "a 1", "a 2", "a 3", "a 4"], result)
    }
    
    func test_transform() {
        var collection = [1, 2, 3, 4, 5]
        collection.transform {
            $0 * 2
        }
        XCTAssertEqual([2, 4, 6, 8, 10], collection)
    }
    
    func test_unique() {
        let collection = [1, 2, 3, 4, 5, 1 ,2 ,3 ,4 , 2, 3]
        let unique = collection.unique()
        
        XCTAssertEqual([1, 2, 3, 4, 5], unique)
    }
    
    func test_unique_with_block() {
        let collection = [1, 2, 3, 4, 5, 1 ,2 ,3 ,4 , 2, 3]
        let unique = collection.unique {
            $0 % 3
        }
        
        XCTAssertEqual([1, 2, 3], unique)
    }
    
    func test_unless() {
        var collection = [1, 2, 3];

        collection.unless(true) {
            $0.append(4)
        }

        collection.unless(false) {
            $0.append(5)
        }

        XCTAssertEqual([1, 2, 3, 5], collection)
    }
    
    func test_when() {
        var collection = [1, 2, 3];

        collection.when(false) {
            $0.append(4)
        }

        collection.when(true) {
            $0.append(5)
        }

        XCTAssertEqual([1, 2, 3, 5], collection)
    }
    
    /*func test_sum(){
        let collection = [1, 2, 3, 4, 5]
        
        XCTAssertEqual(15, collection.sum())
    }*/
    
    
}
