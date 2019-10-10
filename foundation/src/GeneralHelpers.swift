import UIKit

func SBController(_ storyBoard:String, _ identifier:String) -> UIViewController{
    let sb = UIStoryboard(name: storyBoard, bundle: nil)
    return sb.instantiateViewController(withIdentifier: identifier)
}

func isIpad() -> Bool{
    UIDevice().userInterfaceIdiom == .pad
}

