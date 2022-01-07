import Foundation

extension NSNumber: Comparable {
    public static func <(lhs: NSNumber, rhs: NSNumber) -> Bool {
        lhs.doubleValue < rhs.doubleValue
    }
    
    public static func ==(lhs: NSNumber, rhs: NSNumber) -> Bool {
        lhs.doubleValue == rhs.doubleValue
    }
}
