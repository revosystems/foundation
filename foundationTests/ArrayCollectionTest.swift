import XCTest

@testable import RevoFoundation

class ArrayCollectionTest: XCTestCase {

    override func setUp()   {}

    override func tearDown() {}

    func test_each() {
        let a = [1, 2, 3]
        var b:[Int] = []
        
        a.each{
            b.append($0)
        }
        
        XCTAssertEqual(a, b)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
