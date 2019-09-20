import UIKit

public protocol Schedulable{
    func onScheduled();
    func onScheduledCanceled();
}

public class Scheduler: NSObject {

    static var _scheduled: Array<Scheduler> = Array<Scheduler>();
    
    var everySeconds:Double;
    let schedulable:Schedulable;
    
    public static func schedule(_ object:Schedulable) -> Scheduler{
        _scheduled.append(Scheduler(object, seconds:0));
        return _scheduled.last!;
    }
    
    init(_ object:Schedulable, seconds:Double){
        schedulable = object;
        everySeconds = seconds;
    }
    
    public func every(_ seconds :Double) -> Scheduler{
        self.everySeconds = seconds;
        return self.scheduleNext();
    }
    
    public func everyMinute() -> Scheduler{
        return self.every(60);
    }
    
    public func everyFiveMinutes() -> Scheduler{
        return self.every(60 * 5);
    }
    
    public func everyTenMinutes() -> Scheduler{
        return self.every(60 * 10);
    }
    
    public func every30Seconds() -> Scheduler{
        return self.every(30);
    }
        
    @discardableResult public func scheduleNext() -> Scheduler{
        self.cancel();
        self.perform(#selector(runScheduled), with: nil, afterDelay: self.everySeconds);
        return self;
    }
    
    public func run() -> Void {
        self.schedulable.onScheduled();
        self.scheduleNext();
    }

    @objc func runScheduled() -> Scheduler {
        if (UIApplication.shared.applicationState == .active) {
            self.schedulable.onScheduled();
        }
        return self.scheduleNext();
    }
    
    func cancel(){
        NSObject.cancelPreviousPerformRequests(withTarget: self);
    }
    
    func onScheduleCanceled(){
        self.schedulable.onScheduledCanceled();
    }
    
    public static func cancelAll() {
        _scheduled.forEach { scheduled in
            scheduled.cancel();
            scheduled.onScheduleCanceled();
        }
        _scheduled = Array<Scheduler>();
    }
}
