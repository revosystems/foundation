import Foundation

extension Dictionary {
    
    //Only
    //Except
    //Flip
    //Forget
    //Group by
    //Merge
}

public extension Dictionary where Key == String {
    
    func except(_ exclude:[String]) -> Self{
        var copy = self
        exclude.forEach { key in
            copy.removeValue(forKey: key)
        }
        return copy
    }
}

// Dot notation get for a dictionary
public extension Dictionary where Key:Hashable, Value:Any{
    func get(_ path:String, _ defaultValue:Any) -> Any {
        get(path) ?? defaultValue
    }

    func get(_ path:String) -> Any? {
        let components = path.components(separatedBy: ".")
        var currentData:Any? = self

        components.forEach { key in
            if let data = currentData as? [AnyHashable:Any] {
                currentData = data[key]
            } else {
                currentData = nil
            }
        }
        return currentData
    }
}
