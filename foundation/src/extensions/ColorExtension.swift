import UIKit

extension UIColor {
    
    public func luminance() -> CGFloat {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0 ;
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let luminance = (red / 255.0) * 0.3 + (green / 255.0) * 0.59 + (blue / 255.0) * 0.11;
        return luminance * 100;
    }
    
    public func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        if #available(iOS 10.0, tvOS 10.0, *) {
            return UIGraphicsImageRenderer(size: size).image { rendererContext in
                self.setFill()
                rendererContext.fill(CGRect(origin: .zero, size: size))
            }
        }
        return nil
    }
    
}
