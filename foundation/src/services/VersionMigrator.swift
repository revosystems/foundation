import Foundation

public class VersionMigrator {
    
    private static let LAST_VERSION_KEY = "\(Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String)-lastVersion"
    
    private let currentVersion: String
    private let lastVersion: String
    
    public init(currentVersion: String) {
        self.currentVersion = currentVersion
        self.lastVersion = Self.getLastVersion()
        debugPrint("[MIGRATOR] Current version: \(self.currentVersion)")
        debugPrint("[MIGRATOR] Last version:    \(self.lastVersion)")
    }
    
    public func onFreshInstall(_ then: @escaping () -> Void) {
        guard lastVersion.isEmpty else { return }
        
        debugPrint("[MIGRATOR] First install")
        then()
        saveLastVersion()
    }

    public func onApplicationUpdated(_ then: @escaping () -> Void) {
        guard !lastVersion.isEmpty, lastVersion != currentVersion else { return }
        
        debugPrint("[MIGRATOR] Application updated")
        then()
        saveLastVersion()
    }
    
    public func migrateTo(_ version: String, then: @escaping () -> Void) {
        guard currentVersion.versionCompare(lastVersion) == .orderedDescending,
            currentVersion == version else { return }
        
        debugPrint("[MIGRATOR] Migrating to \(version)")
        then()
    }
    
    public func reset() {
        resetLastVersion()
    }
    
    private static func getLastVersion() -> String {
        UserDefaults.standard.string(forKey: Self.LAST_VERSION_KEY) ?? ""
    }
    
    private func saveLastVersion() {
        UserDefaults.standard.setValue(currentVersion, forKey: Self.LAST_VERSION_KEY)
    }
    
    private func resetLastVersion() {
        UserDefaults.standard.setValue(nil, forKey: Self.LAST_VERSION_KEY)
    }
}
