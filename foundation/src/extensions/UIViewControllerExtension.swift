import UIKit

@objc extension UIViewController {
    public func disableModalDismissGesture() {
        presentationController?.presentedView?.gestureRecognizers?.first?.isEnabled = false
    }
}
