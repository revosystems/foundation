import Foundation

extension Array where Element : NSObject {

    public func firstWhere(_ keyPath : String, value:Any) -> Element?{
        return self.first ( where: { ($0.value(forKeyPath: keyPath) as! NSObject).isEqual(value) })
    }

    /**
    * Returns the first @count element of the array
    */
    public func slice(_ count: Int) -> ArraySlice<Element>{
        return self.prefix(count);
    }
    
    
    /**
     * Splits the array into chucks of size @size and returns an array of arrays
     */
    public func chunk(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }

    /**
    * Divides the array into chucks of size @size, and calls the @block with each splitted array
    */
    public func chunk(into size: Int, _ block: (ArraySlice<Element>) -> Void  ) {
        stride(from: 0, to: count, by: size).forEach {
            block(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
    @discardableResult public func each (_ body:(_ element:Element) -> Void) -> [Element] {
        self.forEach(body)
        return self;
    }
    
    @discardableResult public func eachWithIndex (_ body:(_ element:Element, _ index:Int) -> Void) -> [Element] {
        for (index, element) in self.enumerated() {
            body(element, index)
        }
        return self;
    }
    @discardableResult public func mapWithIndex<T>(_ body:(_ element:Element, _ index:Int) -> T) -> [T] {
        var result:[T] = []
        for (index, element) in self.enumerated() {
            result.append(body(element, index))
        }
        return result;
    }
    
    
    // TODO: Make tests to see the difference with the other chunk
    mutating func chunk(_ size:Int) -> [[Element]] {
        var result: [[Element]] = []
        while (self.count > 0) {
            result.append(self.splice(size))
        }
        return result;
    }
    
    mutating public func splice(_ howMany:Int) -> [Element] {
        let chunk = self.take(howMany);
        self.removeSubrange(0..<Swift.min(howMany, self.count))
        return chunk;
    }
    
    public func take(_ howMany:Int) -> [Element] {
        if (howMany > 0) {
            return Array(self[0..<Swift.min(howMany, self.count)])
        } else {
            let start = Swift.max(0, self.count + howMany)
            let end = Swift.min(-howMany, self.count)
            return Array(self[start..<end])
        }
    }
    
    public mutating func pop() -> Element? {
        return self.splice(1).first;
    }
    
}
