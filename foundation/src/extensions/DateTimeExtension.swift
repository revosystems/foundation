import Foundation

@available(iOS 10.0, tvOS 10.0, *)
extension DateInterval {
    
    public func toDates(every minutes:Int = 30) -> [Date] {
        var result:[Date] = []
        var iterator      = start.roundToHalf()
        while iterator <= end {
            result.append(iterator)
            iterator = iterator.add(minutes: minutes)!
        }
        return result
    }
}
