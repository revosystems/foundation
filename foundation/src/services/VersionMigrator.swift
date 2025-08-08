import Foundation

public class VersionMigrator {
    
    private lazy var LAST_VERSION_KEY: String = {
        "\(bundleId)-lastVersion"
    }()
        
    private let bundleId: String
    private let currentVersion: String
    private var lastVersion: String
    
    public init(bundleId: String? = nil, currentVersion: String) {
        self.bundleId = bundleId ?? Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
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
