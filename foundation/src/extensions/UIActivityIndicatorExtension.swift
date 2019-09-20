extension UIActivityIndicatorView {
    
    func start(_ button:UIButton? = nil){
        DispatchQueue.main.async {
            self.startAnimating()
            self.isHidden     = false
            button?.isEnabled = false
        }
    }
    
    func stop(_ button:UIButton? = nil){
        DispatchQueue.main.async {
            self.stopAnimating()
            self.isHidden       = true
            button?.isEnabled   = true
        }
    }
}
