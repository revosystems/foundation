import Foundation

public class VersionMigrator {
    
    private static let LAST_APP_VERSION_KEY = "\(Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String)-lastAppVersion"
    
    private let currentVersion: String
    
    private let lastAppVersion: String
    
    public init(currentVersion: String) {
        self.currentVersion = currentVersion
        self.lastAppVersion = Self.getLastAppVersion()
        debugPrint("[MIGRATOR] Current version:  \(self.currentVersion)")
        debugPrint("[MIGRATOR] Last app version: \(self.lastAppVersion)")
    }
    
    public func onFreshInstall(_ then: @escaping () -> Void) {
        guard lastAppVersion.isEmpty else { return }
        
        debugPrint("[MIGRATOR] First install")
        then()
        saveLastAppVersion()
    }

    public func onApplicationUpdated(_ then: @escaping () -> Void) {
        guard !lastAppVersion.isEmpty, lastAppVersion != currentVersion else { return }
        
        debugPrint("[MIGRATOR] Application updated")
        then()
        saveLastAppVersion()
    }
    
    public func migrateTo(_ version: String, then: @escaping () -> Void) {
        guard currentVersion.versionCompare(lastAppVersion) == .orderedDescending,
            currentVersion == version else { return }
        
        debugPrint("[MIGRATOR] Migrating to \(version)")
        then()
    }
    
    public func reset() {
        resetLastAppVersion()
    }
    
    private static func getLastAppVersion() -> String {
        UserDefaults.standard.string(forKey: Self.LAST_APP_VERSION_KEY) ?? ""
    }
    
    private func saveLastAppVersion() {
        UserDefaults.standard.setValue(currentVersion, forKey: Self.LAST_APP_VERSION_KEY)
    }
    
    private func resetLastAppVersion() {
        UserDefaults.standard.setValue(nil, forKey: Self.LAST_APP_VERSION_KEY)
    }
}
