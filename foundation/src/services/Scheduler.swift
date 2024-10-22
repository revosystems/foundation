import UIKit

public protocol Schedulable{
    func onScheduled();
    func onScheduledCanceled();
}

@objc public class Scheduler: NSObject {

    static var _scheduled: Array<Scheduler> = Array<Scheduler>();
    
    var everySeconds:Double;
    let schedulable:Schedulable;
    
    public static func schedule(_ object:Schedulable) -> Scheduler{
        _scheduled.append(Scheduler(object, seconds:0));
        return _scheduled.last!;
    }
    
    public init(_ object:Schedulable, seconds:Double){
        schedulable = object;
        everySeconds = seconds;
    }
    
    @objc public func every(_ seconds :Double) -> Scheduler{
        self.everySeconds = seconds;
        return self.scheduleNext();
    }
    
    @objc public func everyMinute() -> Scheduler{
        return self.every(60);
    }
    
    @objc public func everyFiveMinutes() -> Scheduler{
        return self.every(60 * 5);
    }
    
    @objc public func everyTenMinutes() -> Scheduler{
        return self.every(60 * 10);
    }
    
    @objc public func every30Seconds() -> Scheduler{
        return self.every(30);
    }
        
    @objc @discardableResult public func scheduleNext() -> Scheduler{
        self.cancel();
        DispatchQueue.main.asyncAfter(deadline: .now() +
            Double(self.everySeconds)) { [unowned self] in
            self.runScheduled()
        }
        return self;
    }
    
    public func run() -> Void {
        self.schedulable.onScheduled();
        self.scheduleNext();
    }

    @discardableResult
    @objc func runScheduled() -> Scheduler {
        if (UIApplication.shared.applicationState == .active) {
            self.schedulable.onScheduled();
        }
        return self.scheduleNext();
    }
    
    @objc func cancel(){
        NSObject.cancelPreviousPerformRequests(withTarget: self);
    }
    
    @objc func onScheduleCanceled(){
        self.schedulable.onScheduledCanceled();
    }
    
    @objc public static func cancelAll() {
        _scheduled.forEach { scheduled in
            scheduled.cancel();
            scheduled.onScheduleCanceled();
        }
        _scheduled = Array<Scheduler>();
    }
}
