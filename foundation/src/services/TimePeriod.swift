import Foundation


public class TimePeriod {
    
    // MARK: - Properties
    public var start: Date?
    public var end: Date?
    
    // MARK: - Constructors
    public init() {
    }
    
    public init(start: Date?, end: Date?) {
        self.start = start
        self.end = end
    }
    
    public init(start: Date, duration: TimeInterval) {
        self.start = start
        self.end = start + duration
    }
    
    public init(end: Date, duration: TimeInterval) {
        self.end = end
        self.start = end.addingTimeInterval(-duration)
    }
    
    // MARK: - Methods
    public func shifted(by timeInterval: TimeInterval) -> TimePeriod {
        let timePeriod = TimePeriod()
        timePeriod.start = self.start?.addingTimeInterval(timeInterval)
        timePeriod.end = self.end?.addingTimeInterval(timeInterval)
        return timePeriod
    }
    
}
