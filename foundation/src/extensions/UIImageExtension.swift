import UIKit

@objc extension UIImage {
    
    public func base64() -> String{
        //let strBase64 =  self.pngData()?.base64EncodedString()
        let strBase64 =  self.jpegData(compressionQuality: 5)?.base64EncodedString()
        return strBase64!
    }
    
    public func scaledWithMaxWidthOrHeightValue(value: CGFloat) -> UIImage? {
        
        let width = self.size.width
        let height = self.size.height
        
        let ratio = width/height
        
        var newWidth = value
        var newHeight = value
        
        if ratio > 1 {
            newWidth = width * (newHeight/height)
        } else {
            newHeight = height * (newWidth/width)
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, 0)
        
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    public func scaled(withScale scale: CGFloat) -> UIImage? {
        
        let size = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}
