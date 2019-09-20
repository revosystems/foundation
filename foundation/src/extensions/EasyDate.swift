import UIKit

extension Date {

    public func toDatetimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "Y-MM-dd H:mm"
        return dateFormatter.string(from: self)
    }

    public func toUTCDatetimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "Y-MM-dd H:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
}
