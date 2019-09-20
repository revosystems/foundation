import UIKit

protocol Schedulable{
    func onScheduled();
    func onScheduledCanceled();
}

class Scheduler: NSObject {

    static var _scheduled: Array<Scheduler> = Array<Scheduler>();
    
    var everySeconds:Double;
    let schedulable:Schedulable;
    
    static func schedule(_ object:Schedulable) -> Scheduler{
        _scheduled.append(Scheduler(object, seconds:0));
        return _scheduled.last!;
    }
    
    init(_ object:Schedulable, seconds:Double){
        schedulable = object;
        everySeconds = seconds;
    }
    
    func every(_ seconds :Double) -> Scheduler{
        self.everySeconds = seconds;
        return self.scheduleNext();
    }
    
    func everyMinute() -> Scheduler{
        return self.every(60);
    }
    
    func everyFiveMinutes() -> Scheduler{
        return self.every(60 * 5);
    }
    
    func everyTenMinutes() -> Scheduler{
        return self.every(60 * 10);
    }
    
    func every30Seconds() -> Scheduler{
        return self.every(30);
    }
        
    @discardableResult func scheduleNext() -> Scheduler{
        self.cancel();
        self.perform(#selector(runScheduled), with: nil, afterDelay: self.everySeconds);
        return self;
    }
    
    func run() -> Void {
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
    
    static func cancelAll() {
        _scheduled.forEach { scheduled in
            scheduled.cancel();
            scheduled.onScheduleCanceled();
        }
        _scheduled = Array<Scheduler>();
    }
}
