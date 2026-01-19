import Foundation

public extension Int {
    var asTimeWithSeconds: String {

        let (h,m,s) = (self / 3600, (self % 3600) / 60, (self % 3600) % 60)

        let h_string = h < 10 ? "0\(h)" : "\(h)"
        let m_string =  m < 10 ? "0\(m)" : "\(m)"
        let s_string =  s < 10 ? "0\(s)" : "\(s)"

        return "\(h_string):\(m_string):\(s_string)"
    }
    
    var asTimeForHumans:String {
        if self < 60 {
            return "\(self) min"
        }
        
        return asTime
    }
    
    var asTime:String {
        let hours   = "\(self / 60)".lpad(toLength: 2, withPad: "0")
        let minutes = "\(self % 60)".lpad(toLength: 2, withPad: "0")
        
        return "\(hours):\(minutes)"
    }
}
