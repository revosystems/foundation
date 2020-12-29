import XCTest
import RevoFoundation

class DictionaryTest: XCTestCase {

    func test_except() throws {
        
        let dict = [
            "key1" : "first key",
            "key2" : "second key",
            "key3" : "Third key"
        ]
        
        let result = dict.except(["key1", "key4"])
        XCTAssertEqual(
            ["key2" : "second key", "key3" : "Third key"],result
        )
    }
}
