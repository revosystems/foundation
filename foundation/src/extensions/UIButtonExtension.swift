import UIKit

extension UIButton {
    public func temporaryDisable(during seconds:Double = 0.8){
        isEnabled = false
        runAfter(seconds) { [weak self] in
            runOnUi {
                self?.isEnabled = true
            }
        }
    }
}
