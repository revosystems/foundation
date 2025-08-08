import Foundation

public class VersionMigrator {
        
    private let LAST_VERSION_KEY: String
    private let currentVersion: String
    private var lastVersion: String
    
    public init(lastVersionKey: String? = nil, currentVersion: String) {
        if let lastVersionKey {
            self.LAST_VERSION_KEY = lastVersionKey
        } else {
            self.LAST_VERSION_KEY = "\(Bundle.main.bundleIdentifier!)-lastVersion"
        }
        self.currentVersion = currentVersion
        self.lastVersion = ""
        self.lastVersion = getLastVersion()
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
    
    private func getLastVersion() -> String {
        Container.shared.resolve(UserDefaults.self)!.string(forKey: LAST_VERSION_KEY) ?? ""
    }
    
    private func saveLastVersion() {
        Container.shared.resolve(UserDefaults.self)!.set(currentVersion, forKey: LAST_VERSION_KEY)
    }
    
    private func resetLastVersion() {
        Container.shared.resolve(UserDefaults.self)!.removeObject(forKey: LAST_VERSION_KEY)
    }
}
