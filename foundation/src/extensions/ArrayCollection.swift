import Foundation

extension Array {
    
    /**
     * Returns the first element that the @keyPath is equal to the @value
     */
    public func firstWhere<T: Equatable>(_ keyPath:KeyPath<Element, T>, is value:T, defaultValue:Element? = nil) -> Element? {
        return self.first {
            return $0[keyPath: keyPath] == value;
        } ?? defaultValue
    }
    
    /**
    * Returns a slice of the collection starting at the given index without modifiying the original one
    */
    public func slice(_ from: Int) -> ArraySlice<Element>{
        if ( from > self.count) { return [] }
        return self.suffix(from: from)
    }
    
    /**
    * Returns a slice of the collection starting of length @howMany at the given index without modifiying the original one
    */
    public func slice(_ from: Int, howMany: Int) -> ArraySlice<Element>{
        if ( count > self.count) { return [] }
        return self[from...Swift.min(from+howMany - 1, self.count - 1)]
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
    
    /**
     * Returns the collection sorted by the @keyPath, this one keeps the original array intact
     */
    func sort<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { a, b in
            return a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
    
    /**
     * Wrapper for the swif foreach function
     */
    @discardableResult public func each (_ body:(_ element:Element) -> Void) -> [Element] {
        self.forEach(body)
        return self;
    }
    
    /**
     * Wrapper for the swif foreach function but providing the index of the element in the array
     */
    @discardableResult public func eachWithIndex (_ body:(_ element:Element, _ index:Int) -> Void) -> [Element] {
        for (index, element) in self.enumerated() {
            body(element, index)
        }
        return self;
    }
    
    /**
     * Same as map but providing the index of the element in the array
     */
    @discardableResult public func mapWithIndex<T>(_ body:(_ element:Element, _ index:Int) -> T) -> [T] {
        var result:[T] = []
        for (index, element) in self.enumerated() {
            result.append(body(element, index))
        }
        return result;
    }
    
    
    // TODO: Make tests to see the difference with the other chunk
    /**
     * Returns an array of arrays with the elements separated by size
     */
    mutating func chunk(_ size:Int) -> [[Element]] {
        var result: [[Element]] = []
        while (self.count > 0) {
            result.append(self.splice(size))
        }
        return result;
    }
    
    /**
     * Returns the firsts @howMany elements of the array and removes them from the original array
     */
    mutating public func splice(_ howMany:Int) -> [Element] {
        let chunk = self.take(howMany);
        self.removeSubrange(0..<Swift.min(howMany, self.count))
        return chunk;
    }
    
    /**
     * Returns the first howMany Elements of the array, if @howMany is negative, it returns the lasts @howMany elements of the array
     */
    public func take(_ howMany:Int) -> [Element] {
        if (howMany > 0) {
            return Array(self[0..<Swift.min(howMany, self.count)])
        } else {
            let start = Swift.max(0, self.count + howMany)
            let end = Swift.min(-howMany, self.count)
            return Array(self[start..<end])
        }
    }
    
    /**
     * Returns the first element of the array and removes it from itself
     */
    public mutating func pop() -> Element? {
        return self.splice(1).first;
    }
    
}
