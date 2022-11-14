import Foundation

public extension Dictionary {
    //Group by
    //Merge
    
    func flip() -> [Value:Key] where Value:Hashable {
        var result:[Value:Key] = [:]
        Array(keys).eachWithIndex { key, index in
            let newKey = Array(values)[index]
            result[newKey] = key
        }
        return result
    }
    
    func except(_ keysToRemove:[Key]) -> [Key:Value]{
        var newDict = self
        keysToRemove.each {
            newDict.removeValue(forKey: $0)
        }
        return newDict
    }
    
    func only(_ keysToKeep:[Key]) -> [Key:Value]{
        var newDict:[Key:Value] = [:]
        keysToKeep.each {
            newDict[$0] = self[$0]
        }
        return newDict
    }
    
    @discardableResult
    mutating func forget(_ keys:[Key]) -> Self {
        keys.each {
            self.removeValue(forKey: $0)
        }
        return self
    }
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
