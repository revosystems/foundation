import Foundation

extension Array where Element : NSObject {

    /**
     * returns the first element where keyPath is the value
     */
    public func firstWhere(_ keyPath : String, value:Any) -> Element?{
        return self.first ( where: {
            ($0.value(forKeyPath: keyPath) as! NSObject).isEqual(value)
        })
    }
    
    /**
    * returns the first element where keyPath is the value, and in case none found, it returns the default value
    */
    public func firstWhere(_ keyPath : String, value:Any, _ defaultValue:Element?) -> Element?{
        return self.firstWhere(keyPath, value: value) ?? defaultValue
    }
}
