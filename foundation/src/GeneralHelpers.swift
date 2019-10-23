import UIKit

public func SBController(_ storyBoard:String, _ identifier:String) -> UIViewController{
    let sb = UIStoryboard(name: storyBoard, bundle: nil)
    return sb.instantiateViewController(withIdentifier: identifier)
}

public func isIpad() -> Bool{
    UIDevice().userInterfaceIdiom == .pad
}

public func runAfter(_ seconds:Double, block:@escaping() -> Void){
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
         block()
     }
}

public func tap<T>(_ value:T, _ block:(_ value:T) -> Void) -> T{
    block(value)
    return value
}


