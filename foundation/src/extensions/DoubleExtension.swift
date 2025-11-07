import Foundation

extension Double{
    public var toCents:Int{
        Int(Darwin.round(self*100))
    }
    
    public var toString:String {
        String(format: "%.2f", self)        
    }
    
    func formattedWithSuffix() -> String {
        let thousand = 1000.0
        let million  = thousand * 1000.0
        let billion  = million * 1000.0
        
        if self >= billion {
            return String(format: "%.1fB", self / billion).replacingOccurrences(of: ".0", with: "")
        } else if self >= million {
            return String(format: "%.1fM", self / million).replacingOccurrences(of: ".0", with: "")
        } else if self >= thousand {
            return String(format: "%.1fK", self / thousand).replacingOccurrences(of: ".0", with: "")
        }
        return String(format: "%.1f", self)
    }
}
