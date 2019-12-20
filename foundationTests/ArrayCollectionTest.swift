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
    
    func test_key_by(){
        struct testStruct: Equatable {
            let name : String
            let value: Int
        }
        
        let collection = [
            testStruct(name: "b", value:1),
            testStruct(name: "c", value:2),
            testStruct(name: "a", value:3),
        ]
        
        let result = collection.keyBy(\.name)
        
        XCTAssertEqual([
            "a" : testStruct(name: "a", value:3),
            "b" : testStruct(name: "b", value:1),
            "c" : testStruct(name: "c", value:2),
        ], result)
    }
    
    func test_key_by_block(){
        struct testStruct: Equatable {
            let name : String
            let value: Int
        }
        
        let collection = [
            testStruct(name: "b", value:1),
            testStruct(name: "c", value:2),
            testStruct(name: "a", value:3),
        ]
        
        let result = collection.keyBy { $0.name }
        
        XCTAssertEqual([
            "a" : testStruct(name: "a", value:3),
            "b" : testStruct(name: "b", value:1),
            "c" : testStruct(name: "c", value:2),
        ], result)
    }
    
    func test_map_to_dicionary() {
        let collection = [1, 2, 3]
        let result = collection.mapToDictionary {
            return ($0, $0 * 2)
        }
        
        XCTAssertEqual([
            1 : 2,
            2 : 4,
            3 : 6
        ], result)
        
    }
    
    func test_max_element() {
        struct testStruct: Equatable {
            let name : String
            let value: Int
        }
        
        let collection = [
            testStruct(name: "b", value:1),
            testStruct(name: "c", value:2),
            testStruct(name: "a", value:3),
        ]
        
        let max = collection.maxElement(\.value)
        XCTAssertEqual(testStruct(name: "a", value:3), max)
    }
    
    func test_min_element() {
        struct testStruct: Equatable {
            let name : String
            let value: Int
        }
        
        let collection = [
            testStruct(name: "b", value:1),
            testStruct(name: "c", value:2),
            testStruct(name: "a", value:3),
        ]
        
        let min = collection.minElement(\.value)
        XCTAssertEqual(testStruct(name: "b", value:1), min)
    }
    
    func test_max() {
        struct testStruct: Equatable {
            let name : String
            let value: Int
        }
        
        let collection = [
            testStruct(name: "b", value:1),
            testStruct(name: "c", value:2),
            testStruct(name: "a", value:3),
        ]
        
        let max = collection.max(at: \.value)
        XCTAssertEqual(3, max)
    }
    
    func test_min() {
        struct testStruct: Equatable {
            let name : String
            let value: Int
        }
        
        let collection = [
            testStruct(name: "b", value:1),
            testStruct(name: "c", value:2),
            testStruct(name: "a", value:3),
        ]
        
        let min = collection.min(at: \.value)
        XCTAssertEqual(1, min)
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
    
    func test_allWhere(){
        struct testStruct {
            let boolean : Bool
        }
        
        let collection = [
            testStruct(boolean: true),
            testStruct(boolean: false),
            testStruct(boolean: true),
            testStruct(boolean: false),
            testStruct(boolean: true),
        ]
        
        let result = collection.allWhere(\.boolean)
        XCTAssertEqual(3, result.count);
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
    
    func test_implode(){
        let collection = ["hola", "que", "tal"]
        let result = collection.implode(" ")
        XCTAssertEqual("hola que tal", result)
    }
    
    func test_every(){
        let collection = [5, 6, 7, 8]
        
        let result = collection.every { $0 > 4 }
        let result2 = collection.every { $0 > 5 }
        
        XCTAssertTrue(result)
        XCTAssertFalse(result2)
    }
    
    func test_intersect(){
        let collection1 = ["a", "b", "c", "d", "e"]
        let collection2 = ["b", "c", "d", "x", "z"]
        
        let result = collection1.intersect(collection2)
        
        XCTAssertEqual(Set(["d", "b", "c"]), Set(result))
    }
    
    func test_union(){
        let collection1 = ["a", "b", "c", "d", "e"]
        let collection2 = ["b", "c", "d", "x", "z"]
        
        let result = collection1.union(collection2)
        
        XCTAssertEqual(Set(["b", "c", "x", "e", "d", "a", "z"]), Set(result))
    }
    
    func test_difference() {
        let collection1 = ["a", "b", "c", "d", "e"]
        let collection2 = ["b", "c", "d", "x", "z"]
        
        let result = collection1.difference(collection2)
        
        XCTAssertEqual(Set(["a", "e", "x", "z"]), Set(result))
    }
    
    func test_join() {
        XCTAssertEqual("a, b, c", ["a", "b", "c"].join(", "))
        XCTAssertEqual("a, b, and c", ["a", "b", "c"].join(", ", lastGlue:", and "))
        XCTAssertEqual("a and b", ["a", "b"].join(", ", lastGlue:" and "))
        XCTAssertEqual("a", ["a"].join(", ", lastGlue:" and "))
        XCTAssertEqual("", [].join(", ", lastGlue:" and "))
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
    
    func test_pad(){
        var collection = [1, 2, 3]
        XCTAssertEqual([1, 2, 3, 0, 0], collection.pad(5, 0))
        
        var collection2 = [1, 2, 3]
        XCTAssertEqual([1, 2, 3], collection2.pad(2, 0))
    }
    
    func test_lpad(){
        var collection = [1, 2, 3]
        XCTAssertEqual([0, 0, 1, 2, 3], collection.lpad(5, 0))
        
        var collection2 = [1, 2, 3]
        XCTAssertEqual([1, 2, 3], collection2.lpad(2, 0))
    }
    
    func test_partition(){
        let collection = [1, 2, 3, 4, 5, 6]
        
        let result = collection.partition {
            $0 < 4
        }
        
        XCTAssertEqual([1, 2, 3], result.0)
        XCTAssertEqual([4, 5, 6], result.1)
    }
    
    func test_can_substract_two_arrays(){
        let a = [1, 2, 3, 4]
        let b = [2, 4]
        
        let result = a - b
        
        XCTAssertEqual([1, 3], result.sorted())
    }

    
    /*func test_sum(){
        let collection = [1, 2, 3, 4, 5]
        
        XCTAssertEqual(15, collection.sum())
    }*/
    
    
}
