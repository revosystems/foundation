import Foundation

extension Double{
    public var toCents:Int{
        Int(Darwin.round(self*100))
    }
    
    public var toString:String {
        String(format: "%.2f", self)        
    }
}
