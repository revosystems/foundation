import XCTest

final class IntExtensionTest: XCTestCase {
    
    func test_asTime_formats_duration_equal_to_60_minutes() throws {
        XCTAssertEqual(60.asTime, "01:00")
    }
    
    func test_asTime_formats_durations_greater_than_60_minutes() throws {
        XCTAssertEqual(61.asTime, "01:01")
        XCTAssertEqual(90.asTime, "01:30")
        XCTAssertEqual(120.asTime, "02:00")
        XCTAssertEqual(150.asTime, "02:30")
        XCTAssertEqual(600.asTime, "10:00")
        XCTAssertEqual(1440.asTime, "24:00")
    }

}
