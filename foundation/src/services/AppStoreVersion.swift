import Foundation
import UIKit

extension String {
    func versionCompare(_ otherVersion: String) -> ComparisonResult {
        self.compare(otherVersion, options: .numeric)
    }
}

struct AppStoreVersion {
    
    let bundleId:String
    let appId:String
    
    init(bundleId:String? = nil, appId:String){
        self.bundleId = bundleId ?? Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        self.appId    = appId
    }
    
    struct ITunesResult: Codable {
        let currentVersionReleaseDate: String
        let version: String
    }

    struct ITunesResponse: Codable {
        let results: [ITunesResult]
    }

    func isThereAnUpdate(daysMargin: Int = 15, country:String = "es", then: @escaping (_ isThereAnUpdate: Bool?) -> Void) {                
        getAppStoreVersion(country:country) { result in
            guard let result = result else { return then(false) }
            guard result.version > currentVersion() else      { return then(false) }
            let thresholdDate = ISO8601DateFormatter().date(from: result.currentVersionReleaseDate)?.add(days:daysMargin)
            then((thresholdDate ?? Date()) < Date())
        }
    }
    
    func getAppStoreVersion(country:String = "es", then:@escaping(_ result:ITunesResult?) -> Void) {
        
        let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleId)&country=\(country)&limit=1")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return then(nil) }
            
            guard let itunesResponse = try? JSONDecoder().decode(ITunesResponse.self, from: data) else {
                return then(nil)
            }
            guard let result = itunesResponse.results.first else { return then(nil) }
            then(result)
        }
        task.resume()
    }

    
    func currentVersion() -> String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    func openAppStore(){
        if let url = URL(string: "itms-apps://apple.com/app/id\(appId)") {
            UIApplication.shared.open(url)
        }
    }
}
