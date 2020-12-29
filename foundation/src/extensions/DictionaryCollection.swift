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
