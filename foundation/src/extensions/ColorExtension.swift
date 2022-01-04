import UIKit

extension UIColor {
    
    public func luminance() -> CGFloat {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0 ;
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let luminance = (red / 255.0) * 0.3 + (green / 255.0) * 0.59 + (blue / 255.0) * 0.11;
        return luminance * 100;
    }
    
    public func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        if #available(iOS 10.0, tvOS 10.0, *) {
            return UIGraphicsImageRenderer(size: size).image { rendererContext in
                setFill()
                rendererContext.fill(CGRect(origin: .zero, size: size))
            }
        }
        return nil
    }
    
    @objc public convenience init(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            var hexColor = String(hex[start...])

            if hexColor.count == 3 {
                hexColor = hexColor + hexColor + "ff"
            }
            
            if hexColor.count == 6 {
                hexColor = hexColor + "ff"
            }
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        self.init(red:0, green:0, blue:0, alpha:1)
    }
    
}

