import XCTest
@testable import RevoFoundation


class VersionMigratorTest: XCTestCase {
    
    private let testBundleId = "com.test.app"
    private var lastVersionKey: String!
    private var defaults = Defaults.fake()
    
    override func setUp() {
        super.setUp()
        lastVersionKey = "\(testBundleId)-lastVersion"
        defaults.remove(lastVersionKey)
    }
    
    override func tearDown() {
        defaults.remove(lastVersionKey)
        super.tearDown()
    }
    
    // MARK: - Fresh Install Tests
    
    func test_onFreshInstall_calls_closure_when_no_previous_version() {
        let migrator = VersionMigrator(bundleId: testBundleId, currentVersion: "1.0.0")
        var wasCalled = false
        
        migrator.onFreshInstall {
            wasCalled = true
        }
        
        XCTAssertTrue(wasCalled)
    }
    
    func test_onFreshInstall_does_not_call_closure_when_previous_version_exists() {
        defaults.defaults.set("0.9.0", forKey: lastVersionKey)
        let migrator = VersionMigrator(bundleId: testBundleId, currentVersion: "1.0.0")
        var wasCalled = false
        
        migrator.onFreshInstall {
            wasCalled = true
        }
        
        XCTAssertFalse(wasCalled)
    }
    
    // MARK: - Application Update Tests
    
    func test_onApplicationUpdated_calls_closure_when_version_changed() {
        defaults.defaults.set("1.0.0", forKey: lastVersionKey)
        let migrator = VersionMigrator(bundleId: testBundleId, currentVersion: "1.1.0")
        var wasCalled = false
        
        migrator.onApplicationUpdated {
            wasCalled = true
        }
        
        XCTAssertTrue(wasCalled)
    }
    
    func test_onApplicationUpdated_does_not_call_closure_when_version_same() {
        defaults.defaults.set("1.0.0", forKey: lastVersionKey)
        let migrator = VersionMigrator(bundleId: testBundleId, currentVersion: "1.0.0")
        var wasCalled = false
        
        migrator.onApplicationUpdated {
            wasCalled = true
        }
        
        XCTAssertFalse(wasCalled)
    }
    
    func test_onApplicationUpdated_does_not_call_closure_when_no_previous_version() {
        let migrator = VersionMigrator(bundleId: testBundleId, currentVersion: "1.0.0")
        var wasCalled = false
        
        migrator.onApplicationUpdated {
            wasCalled = true
        }
        
        XCTAssertFalse(wasCalled)
    }
    
    // MARK: - Migration Tests
    
    func test_migrateTo_calls_closure_when_migrating_to_current_version() {
        defaults.defaults.set("1.0.0", forKey: lastVersionKey)
        let migrator = VersionMigrator(bundleId: testBundleId, currentVersion: "1.1.0")
        var wasCalled = false
        
        migrator.onApplicationUpdated {
            migrator.migrateTo("1.1.0") {
                wasCalled = true
            }
        }
        
        XCTAssertTrue(wasCalled)
    }
    
    func test_migrateTo_does_not_call_closure_when_target_version_not_current() {
        defaults.defaults.set("1.0.0", forKey: lastVersionKey)
        let migrator = VersionMigrator(bundleId: testBundleId, currentVersion: "1.1.0")
        var wasCalled = false
        
        migrator.onApplicationUpdated {
            migrator.migrateTo("1.2.0") {
                wasCalled = true
            }
        }
        
        XCTAssertFalse(wasCalled)
    }
    
    func test_migrateTo_does_not_call_closure_when_current_version_not_greater_than_last() {
        defaults.defaults.set("1.1.0", forKey: lastVersionKey)
        let migrator = VersionMigrator(bundleId: testBundleId, currentVersion: "1.0.0")
        var wasCalled = false
        
        migrator.onApplicationUpdated {
            migrator.migrateTo("1.0.0") {
                wasCalled = true
            }
        }
        
        XCTAssertFalse(wasCalled)
    }
    
    func test_migrateTo_does_not_call_closure_when_no_previous_version() {
        let migrator = VersionMigrator(bundleId: testBundleId, currentVersion: "1.0.0")
        var wasCalled = false
        
        migrator.onApplicationUpdated {
            migrator.migrateTo("1.0.0") {
                wasCalled = true
            }
        }
        
        XCTAssertFalse(wasCalled)
    }
    
    // MARK: - Reset Tests
    
    func test_reset_clears_last_version() {
        defaults.defaults.set("1.0.0", forKey: lastVersionKey)
        let migrator = VersionMigrator(bundleId: testBundleId, currentVersion: "1.1.0")
        
        XCTAssertNotNil(defaults.defaults.string(forKey: lastVersionKey))
        
        migrator.reset()
        
        XCTAssertNil(defaults.defaults.string(forKey: lastVersionKey))
    }
}
