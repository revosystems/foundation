import UIKit

@objc extension UIImage {    
            
    public convenience init?(barcode: String, size:CGFloat = 4) {
        self.init(text:barcode, filter:"CICode128BarcodeGenerator", size:size)
    }
    
    public convenience init?(qrcode: String, size:CGFloat = 7) {
        self.init(text:qrcode, filter:"CIQRCodeGenerator", size:size)
    }
    
    public convenience init?(text:String, filter:String, size:CGFloat){
        let data = text.data(using: .ascii)
        guard let filter = CIFilter(name: filter) else {
            return nil
        }
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: size, y: size)
        guard let ciImage = filter.outputImage?.transformed(by: transform) else {
            return nil
        }
        self.init(ciImage: ciImage)
    }
    
    
    public func base64() -> String{
        //compressionQuality: 0..1 (0 more compression, 1 less compression).
        let strBase64 =  self.jpegData(compressionQuality: 1)?.base64EncodedString()
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
    
    public func scaledWithMax(width value:CGFloat) -> UIImage? {
        
        let width = self.size.width
        let height = self.size.height
                
        let newWidth = value
        var newHeight = value
        
        newHeight = height * (newWidth/width)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, 0)
        
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    public func scaledWithMax(height value:CGFloat) -> UIImage? {
        
        let width = self.size.width
        let height = self.size.height
                
        var newWidth = value
        let newHeight = value
        
        newWidth = width * (newHeight/height)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, 0)
        
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    public func withExpandedWidth(_ width: CGFloat) -> UIImage? {
        let height = size.height

        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), true, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        UIGraphicsPushContext(context)
                
        context.setFillColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))

        // Now we can draw anything we want into this new context.
        let origin = CGPoint(x: (width - size.width) / 2.0, y: 0)

        draw(at: origin)

        // Clean up and get the new image.
        UIGraphicsPopContext()
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
    public func scaled(withScale scale: CGFloat) -> UIImage? {
        
        let size = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }

    public func resized(to size: CGSize) -> UIImage {
        if #available(iOS 10.0, *) {
            return UIGraphicsImageRenderer(size: size).image { _ in
                draw(in: CGRect(origin: .zero, size: size))
            }
        }
        
        return self
    }

    public func cropped(size : CGSize) -> UIImage{
        let refWidth : CGFloat = CGFloat(self.cgImage!.width)
        let refHeight : CGFloat = CGFloat(self.cgImage!.height)
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        let cropRect = CGRect(x: x, y: y, width: size.width, height: size.height)
        let imageRef = self.cgImage!.cropping(to: cropRect)
        let cropped : UIImage = UIImage(cgImage: imageRef!, scale: 0, orientation: self.imageOrientation)
        return cropped
    }
}
