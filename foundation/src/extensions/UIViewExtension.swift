import UIKit

extension UIView {
    
    public func fadeIn() {
        self.alpha = 0;
        UIView.animate(withDuration: 0.2) { self.alpha = 1 }
    }
    
    public func fadeOut() {
        UIView.animate(withDuration: 0.2) { self.alpha = 0 }
    }
    
}
