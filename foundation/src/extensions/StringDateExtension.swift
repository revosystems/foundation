import Foundation

extension String {
    
    public var toDate: Date? {
        Date(string: self)
    }
    
    public var toDateString:String {
        return String(self.prefix(10))
    }
}
