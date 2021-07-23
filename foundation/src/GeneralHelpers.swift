import UIKit

public func SBController<T>(_ storyBoard:String, _ identifier:String) -> T{
    let sb = UIStoryboard(name: storyBoard, bundle: nil)
    return sb.instantiateViewController(withIdentifier: identifier) as! T
}

public func topVc() -> UIViewController?{
    guard var topVc = UIApplication.shared.keyWindow?.rootViewController else { return nil }
    
    while (topVc.presentedViewController != nil) {
        topVc = topVc.presentedViewController!
    }
    
    return topVc
}


public func isIpad() -> Bool{
    UIDevice().userInterfaceIdiom == .pad
}

public func runAfter(_ seconds:Double, block:@escaping() -> Void){
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
         block()
     }
}

@discardableResult
public func tap<T>(_ value:T, _ block:(_ value:T) -> Void) -> T{
    block(value)
    return value
}

func retry<T>(tries:Int = 1, delayMs:UInt32 = 0, block:() throws -> T) throws -> T {
    do {
        return try block()
    } catch {
        guard tries > 0 else {
            throw error
        }
        usleep(delayMs)
        return try retry(tries: tries - 1, block: block)
    }
}

func retry(tries:Int = 1, delayMs:UInt32 = 0, block:() -> Bool) {
    guard tries >= 0 else {
        return
    }
    guard block() else {
        usleep(delayMs)
        return retry(tries: tries - 1, block: block)
    }
}

// Retry with completion
func retry(tries:Int = 1, delayMs:UInt32 = 0, block:@escaping(_ succeeded:@escaping(_ succeeded:Bool)->Void) -> Void) {
    guard tries >= 0 else { return }
    
    block { succedeed in
        if succedeed { return }
        usleep(delayMs)
        return retry(tries: tries - 1, block: block)
    }
}


