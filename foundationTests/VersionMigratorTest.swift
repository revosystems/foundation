import XCTest
@testable import RevoFoundation


class VersionMigratorTest: XCTestCase {
    
    private var lastVersionKey: String!
    private var defaults = Defaults.fake()
    
    override func setUp() {
        super.setUp()
        lastVersionKey = "com.test.app-lastVersion"
        defaults.remove(lastVersionKey)
    }
    
    override func tearDown() {
        defaults.remove(lastVersionKey)
        super.tearDown()
    }
    
    // MARK: - Fresh Install Tests
    
    func test_onFreshInstall_calls_closure_when_no_previous_version() {
        let migrator = VersionMigrator(lastVersionKey: lastVersionKey, currentVersion: "1.0.0")
        var wasCalled = false
        
        migrator.whenFreshInstall {
            wasCalled = true
        }
        
        XCTAssertTrue(wasCalled)
    }
    
    func test_onFreshInstall_does_not_call_closure_when_previous_version_exists() {
        defaults.set(value: "0.9.0", key: lastVersionKey)
        let migrator = VersionMigrator(lastVersionKey: lastVersionKey, currentVersion: "1.0.0")
        var wasCalled = false
        
        migrator.whenFreshInstall {
            wasCalled = true
        }
        
        XCTAssertFalse(wasCalled)
    }
    
    // MARK: - Application Update Tests
    
    func test_onApplicationUpdated_calls_closure_when_version_changed() {
        defaults.set(value: "1.0.0", key: lastVersionKey)
        let migrator = VersionMigrator(lastVersionKey: lastVersionKey, currentVersion: "1.1.0")
        var wasCalled = false
        
        migrator.whenApplicationUpdated {
            wasCalled = true
        }
        
        XCTAssertTrue(wasCalled)
    }
    
    func test_onApplicationUpdated_does_not_call_closure_when_version_same() {
        defaults.set(value: "1.0.0", key: lastVersionKey)
        let migrator = VersionMigrator(lastVersionKey: lastVersionKey, currentVersion: "1.0.0")
        var wasCalled = false
        
        migrator.whenApplicationUpdated {
            wasCalled = true
        }
        
        XCTAssertFalse(wasCalled)
    }
    
    func test_onApplicationUpdated_does_not_call_closure_when_no_previous_version() {
        let migrator = VersionMigrator(lastVersionKey: lastVersionKey, currentVersion: "1.0.0")
        var wasCalled = false
        
        migrator.whenApplicationUpdated {
            wasCalled = true
        }
        
        XCTAssertFalse(wasCalled)
    }
    
    // MARK: - Migration Tests
    
    func test_migrateTo_calls_closure_when_migrating_to_current_version() {
        defaults.set(value: "1.0.0", key: lastVersionKey)
        let migrator = VersionMigrator(lastVersionKey: lastVersionKey, currentVersion: "1.1.0")
        var wasCalled = false
        
        migrator.whenApplicationUpdated {
            migrator.migrateTo("1.1.0") {
                wasCalled = true
            }
        }
        
        XCTAssertTrue(wasCalled)
    }
    
    func test_migrateTo_does_not_call_closure_when_target_version_not_current() {
        defaults.set(value: "1.0.0", key: lastVersionKey)
        let migrator = VersionMigrator(lastVersionKey: lastVersionKey, currentVersion: "1.1.0")
        var wasCalled = false
        
        migrator.whenApplicationUpdated {
            migrator.migrateTo("1.2.0") {
                wasCalled = true
            }
        }
        
        XCTAssertFalse(wasCalled)
    }
    
    func test_migrateTo_does_not_call_closure_when_current_version_not_greater_than_last() {
        defaults.set(value: "1.1.0", key: lastVersionKey)
        let migrator = VersionMigrator(lastVersionKey: lastVersionKey, currentVersion: "1.0.0")
        var wasCalled = false
        
        migrator.whenApplicationUpdated {
            migrator.migrateTo("1.0.0") {
                wasCalled = true
            }
        }
        
        XCTAssertFalse(wasCalled)
    }
    
    func test_migrateTo_does_not_call_closure_when_no_previous_version() {
        let migrator = VersionMigrator(lastVersionKey: lastVersionKey, currentVersion: "1.0.0")
        var wasCalled = false
        
        migrator.whenApplicationUpdated {
            migrator.migrateTo("1.0.0") {
                wasCalled = true
            }
        }
        
        XCTAssertFalse(wasCalled)
    }
    
    // MARK: - Reset Tests
    
    func test_reset_clears_last_version() {
        defaults.set(value: "1.0.0", key: lastVersionKey)
        let migrator = VersionMigrator(lastVersionKey: lastVersionKey, currentVersion: "1.1.0")
        
        XCTAssertNotNil(defaults.defaults.string(forKey: lastVersionKey))
        
        migrator.reset()
        
        XCTAssertNil(defaults.defaults.string(forKey: lastVersionKey))
    }
}
