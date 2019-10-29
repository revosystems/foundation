import UIKit

public func SBController<T>(_ storyBoard:String, _ identifier:String) -> T{
    let sb = UIStoryboard(name: storyBoard, bundle: nil)
    return sb.instantiateViewController(withIdentifier: identifier) as! T
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


