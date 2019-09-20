import Foundation

extension String {
    
    public var toDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self)
    }
    
    public var toDateString:String {
        return String(self.prefix(10))
    }
}
