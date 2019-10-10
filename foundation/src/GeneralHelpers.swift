import UIKit

public func SBController(_ storyBoard:String, _ identifier:String) -> UIViewController{
    let sb = UIStoryboard(name: storyBoard, bundle: nil)
    return sb.instantiateViewController(withIdentifier: identifier)
}

public func isIpad() -> Bool{
    UIDevice().userInterfaceIdiom == .pad
}

