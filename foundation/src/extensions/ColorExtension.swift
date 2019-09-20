import UIKit

extension UIColor {
    
    public func luminance() -> CGFloat {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0 ;
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let luminance = (red / 255.0) * 0.3 + (green / 255.0) * 0.59 + (blue / 255.0) * 0.11;
        return luminance * 100;
    }
}
