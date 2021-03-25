import XCTest
@testable import RevoFoundation

class CanValidateAppVersion: XCTestCase {

    override func setUpWithError() throws { }

    override func tearDownWithError() throws {    }

    func test_can_get_app_store_version() throws {
        let expectation = XCTestExpectation(description: "request")
        
        AppStoreVersion(bundleId:"works.revo.Revo", appId:"942396398").getAppStoreVersion { version in
        
            XCTAssertEqual("3.2.4", version!.version)
            XCTAssertEqual("2020-12-17T08:49:06Z", version!.currentVersionReleaseDate)
            XCTAssertNotNil(ISO8601DateFormatter().date(from: version!.currentVersionReleaseDate))
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_can_check_if_new_version_is_available() throws {
        
        let expectation = XCTestExpectation(description: "request")
        
        AppStoreVersion(bundleId:"works.revo.Revo", appId:"942396398").isThereAnUpdate(daysMargin: 0) { isThereAnUpdate in
            XCTAssertTrue(isThereAnUpdate!)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_can_check_if_new_version_is_available_with_days_margin() throws {
        
        let expectation = XCTestExpectation(description: "request")
        
        AppStoreVersion(bundleId:"works.revo.Revo", appId:"942396398").isThereAnUpdate(daysMargin: 5000) { isThereAnUpdate in
            XCTAssertFalse(isThereAnUpdate!)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }


}
