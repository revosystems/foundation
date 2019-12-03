import Foundation

extension Double{
    public var toCents:Int{
        Int(Darwin.round(self*100))
    }
}
