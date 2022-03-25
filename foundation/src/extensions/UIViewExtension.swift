import UIKit

extension UIView {
    
    public func fadeIn() {
        self.alpha = 0;
        UIView.animate(withDuration: 0.2) { self.alpha = 1 }
    }
    
    public func fadeOut() {
        UIView.animate(withDuration: 0.2) { self.alpha = 0 }
    }
    
    func fadeAndScaleOut(duration:TimeInterval = 0.2){
        UIView.animate(withDuration: duration,
                       delay:0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5,
                       options: .curveEaseOut)
        { [unowned self] in
            transform = CGAffineTransform.identity.scaledBy(x: 0.4, y: 0.4)
            alpha     = 0
        } completion: { [unowned self] _ in
            isHidden = true
        }
    }
    
    func fadeAndScaleIn(duration:TimeInterval = 0.2){
        isHidden = false
        UIView.animate(withDuration: duration, delay:0,
                       usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5,
                       options: .curveEaseOut) { [unowned self] in
            transform = CGAffineTransform.identity
            alpha     = 1
        }
    }
    
    public func shake(){
        DispatchQueue.main.async {
            //let duration = 0.3
            let shakeValues:[Double] = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
            
            let translation             = CAKeyframeAnimation(keyPath: "transform.translation.x");
            translation.timingFunction  = CAMediaTimingFunction(name: .linear)
            translation.values          = shakeValues
            
            let rotation    = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            rotation.values = shakeValues.map { (Double.pi * $0) / 180.0 }
            
            let shakeGroup          = CAAnimationGroup()
            shakeGroup.animations   = [translation, rotation]
            shakeGroup.duration     = 0.5
            self.layer.add(shakeGroup, forKey: "shakeIt")
        }
    }
    
    @discardableResult public func shadow(scale: Bool = true) -> Self {
        layer.masksToBounds = false
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset  = CGSize(width: 0, height: 4)
        layer.shadowRadius  = 4
        
        layer.shadowPath            = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize       = true
        layer.rasterizationScale    = scale ? UIScreen.main.scale : 1
        return self;
    }
    
    @discardableResult public func round(_ radius: CGFloat = 10) -> Self{
        layer.cornerRadius = radius
        return self
    }
    
    @discardableResult public func roundCorners(corners:UIRectCorner, radius: CGFloat) -> Self {
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
        return self
    }
    
    @discardableResult public func circle() -> Self{
        clipsToBounds = true
        layer.cornerRadius = bounds.size.width / 2
        return self
    }
    
    @discardableResult public func border(_ color:UIColor = .white, size:CGFloat = 1) -> Self {
        layer.borderWidth   = size
        layer.borderColor   = color.cgColor
        return self
    }
    
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        }
        if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        }
        return nil
    }
}
