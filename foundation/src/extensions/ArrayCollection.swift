import Foundation

//https://www.swiftbysundell.com/articles/the-power-of-key-paths-in-swift/
//https://github.com/BadChoice/Collection/blob/master/Collection/Categories/NSArray%2BCollection/NSArray%2BCollection.m
//https://laravel.com/docs/5.8/collections#method-where

extension Array {
    
    enum ValidationError: Error {
        case NotSameSize
    }
    
    /**
     Returns a new array without the elements that return true to the block
     */
    public func reject(_ block:(_ v:Element) -> Bool) -> [Element] {
        self.filter { !block($0) }
    }
    
    /**
        passes the collection to the given callback, allowing you to "tap" into the collection at a specific point and do something with the items while not affecting the collection itself:
     */
    @discardableResult public func tap(_ block:([Element])->Void) -> Self{
        block(self)
        return self
    }
    
    /**
        passes the collection to the given callback and returns the result:
     */
    public func pipe<T>(_ block:([Element])->T) -> T{
        return block(self)
    }
        
        
    
    // MARK: Where
    
    /**
     * Returns the first element that the @keyPath is equal to the @value
     */
    public func firstWhere<T: Equatable>(_ keyPath:KeyPath<Element, T>, is value:T, defaultValue:Element? = nil) -> Element? {
        return self.first {
            $0[keyPath: keyPath] == value;
        } ?? defaultValue
    }
    
   
    /**
     * Returns an array with all the elements that the keypath value is @value
     */
    public func allWhere<T:Equatable>(_ keyPath:KeyPath<Element, T>, is value:T) -> [Element] {
        return self.filter{
            $0[keyPath: keyPath] == value;
        }
    }
    
    /**
     * Returns an array with all the elements that the keypath value is not @value
     */
    public func allWhere<T:Equatable>(_ keyPath:KeyPath<Element, T>, isNot value:T) -> [Element] {
        return self.filter{
            $0[keyPath: keyPath] != value;
        }
    }
    
    /**
     * Returns an array with all the elements that the keypath is nil
     */
    public func whereNil<T:Equatable>(_ keyPath:KeyPath<Element, T?>) -> [Element] {
        return self.filter{
            $0[keyPath: keyPath] == nil;
        }
    }
    
    
    /**
     * Returns an array with all the elements that the keypath is nil
     */
    public func whereNotNil<T:Equatable>(_ keyPath:KeyPath<Element, T?>) -> [Element] {
        return self.filter{
            $0[keyPath: keyPath] != nil;
        }
    }
        
    /**
     * Returns an array with all the elements that the keypath value is between @firstValue and @lastValue first and last included
     */
    public func whereBetween<T:Comparable>(_ keyPath:KeyPath<Element, T>, first:T, last:T) -> [Element] {
        return self.filter{
            let compare = $0[keyPath: keyPath]
            return compare >= first && compare <= last
        }
    }
    
    /**
     * Returns an array with all the elements that the keypath value is not between @firstValue and @lastValue first and last included
     */
    public func whereNotBetween<T:Comparable>(_ keyPath:KeyPath<Element, T>, first:T, last:T) -> [Element] {
        return self.filter{
            let compare = $0[keyPath: keyPath]
            return !(compare >= first && compare <= last)
        }
    }
    
    /**
     * Returns an array with all the element at the keypath value is in the @values array
     */
    public func whereIn<T:Equatable>(_ keyPath:KeyPath<Element, T>, in values:[T]) -> [Element] {
        return self.filter {
            values.contains($0[keyPath: keyPath])
        }
    }
    
    /**
     * Returns an array with all the element at the keypath value is in the @values array
     */
    public func whereNotIn<T:Equatable>(_ keyPath:KeyPath<Element, T>, in values:[T]) -> [Element] {
        return self.filter {
            !values.contains($0[keyPath: keyPath])
        }
    }

    // MARK: Others
    
    /**
     * Returns an array with all the elements[keypath]
     */
    public func pluck<T>(_ keyPath:KeyPath<Element, T>) -> [T] {
        return self.map { $0[keyPath: keyPath]}
    }
    
    
    public func zip<T>(_ with:[T]) throws ->  [Element:T] {
        if (self.count != with.count) {
            throw Array.ValidationError.NotSameSize
        }
        var result:[Element:T] = [:]
        self.eachWithIndex { (element, index) in
            result[element] = with[index]
        }
        return result
    }
        
    /**
     * Returns the collection sorted by the @keyPath, this one keeps the original array intact
     */
    public func sort<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { a, b in
            return a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
    
    /**
     The keyBy method keys the collection by the given key. If multiple items have the same key, only the last one will appear in the new collection:
     */
    public func keyBy<T>(_ keyPath:KeyPath <Element, T>) -> [T:Element] {
        var result:[T:Element] = [:]
        self.each {
            result[$0[keyPath: keyPath]] = $0
        }
        return result
    }
    
    /**
     The keyBy method keys the collection by the given key. If multiple items have the same key, only the last one will appear in the new collection:
     */
    public func keyBy<T>(_ key:(_ element:Element)->T) -> [T:Element] {
        var result:[T:Element] = [:]
        self.each {
            result[key($0)] = $0
        }
        return result
    }
    
    /**
     The partition method may be combined with the list PHP function to separate elements that pass a given truth test from those that do not
     */
    public func partition(_ check:(_ element:Element)->Bool) -> ([Element], [Element]) {
        var passing:[Element] = []
        var notPassing:[Element] = []
        
        self.each{
            if check($0) {
                passing.append($0)
            } else {
                notPassing.append($0)
            }
        }
        return (passing, notPassing)
    }
    
    // MARK: Loops
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
     * Runs the block for all elements and when they all finishes the allFinished is called.
     * To know the block is finished the then() must be called in the async block
     */
    public func eachAsync(_ body:(_ element:Element, _ index:Int, _ then:@escaping()->Void) -> Void, allFinished:@escaping(()->Void)){
        let group = DispatchGroup()
        for (index, element) in self.enumerated() {
            group.enter()
            body(element, index) {
                group.leave()
            }
        }
        group.notify(queue: .main) { allFinished() }
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
    

    /**
     * Returns a dictionary from the array with the tuple.0 as key and tuple.1 as value
     */
    public func mapToDictionary<T, Z>(_ block:(_ element:Element) -> (T,Z)) -> [T:Z]{
        var result:[T:Z] = [:]
        self.each {
            let tuple = block($0)
            result[tuple.0] = tuple.1
        }
        return result
    }
    
    
    // MARK: Math
    
    /**
     * Returns the element it's keypath is the max
     */
    public func maxElement<T:Comparable>(_ keyPath:KeyPath<Element, T>) -> Element? {
        var max:Element? = nil
        var maxValue:T? = nil
        self.each {
            let newElementMax = $0[keyPath: keyPath]
            if (maxValue == nil || newElementMax > maxValue!) {
                max = $0
                maxValue = newElementMax
            }
        }
        return max
    }
    
    /**
     * Returns the element it's keypath is the max
     */
    public func minElement<T:Comparable>(_ keyPath:KeyPath<Element, T>) -> Element? {
        var min:Element? = nil
        var minValue:T? = nil
        self.each {
            let newElementMin = $0[keyPath: keyPath]
            if (minValue == nil || newElementMin < minValue!) {
                min = $0
                minValue = newElementMin
            }
        }
        return min
    }
    
    /**
     * Returns the element it's keypath is the max
     */
    public func max<T:Comparable>(at keyPath:KeyPath<Element, T>) -> T? {
        var maxValue:T? = nil
        self.each {
            let newElementMax = $0[keyPath: keyPath]
            if (maxValue == nil || newElementMax > maxValue!) {
                maxValue = newElementMax
            }
        }
        return maxValue
    }
    
    /**
     * Returns the element it's keypath is the max
     */
    public func min<T:Comparable>(at keyPath:KeyPath<Element, T>) -> T? {
        var minValue:T? = nil
        self.each {
            let newElementMin = $0[keyPath: keyPath]
            if (minValue == nil || newElementMin < minValue!) {
                minValue = newElementMin
            }
        }
        return minValue
    }
    
    // MARK: Ranges
    
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
     * Returns elements from  @start and removes them from the original array
     */
    mutating public func splice(_ start:Int) -> [Element] {
        let chunk = self[start..<self.count]
        self.removeSubrange(start..<self.count)
        return Array(chunk);
    }
    
    /**
     * Returns @limit elements starting at @start  removes them from the original array
     */
    mutating public func splice(_ start:Int, limit:Int) -> [Element] {
        let end     = Swift.min(start + limit, self.count)
        let chunk   = self[start..<end]
        self.removeSubrange(start..<end)
        return Array(chunk);
    }
    
    /**
     * Returns @limit elements starting at @start  and replaces them with @replacing in the original array
     */
    mutating public func splice(_ start:Int, limit:Int, replaceWith:[Element]) -> [Element] {
        let end     = Swift.min(start + limit, self.count)
        let chunk   = self[start..<end]
        self.removeSubrange(start..<end)
        self.insert(contentsOf: replaceWith, at: start)
        return Array(chunk);
    }
    
    /**
     * Returns the first howMany Elements of the array, if @howMany is negative, it returns the lasts @howMany elements of the array
     */
    public func take(_ howMany:Int) -> [Element] {
        if (howMany > 0) {
            return Array(self[0..<Swift.min(howMany, self.count)])
        } else {
            return Array(self[Swift.max(0, self.count - (-howMany))..<self.count])
        }
    }
    
    /**
     method breaks a collection into the given number of groups:
     */
    public func split(_ howManyGroups: Int) -> [[Element]]{
        let chunkSize = ceil(Double(self.count) / Double(howManyGroups))
        return self.chunk(into: Int(chunkSize))
    }
    
    /**
     creates a new collection by invoking the callback a given amount of times:
     */
    static public func times<T>(_ times:Int, _ block:(_ index:Int)->T) -> [T] {
        return (0...times - 1).map { block($0) }
    }
    

    // MARK: Truth tests
    /**
     *The every method may be used to verify that all elements of a collection pass a given truth test:
     */
    public func every(_ truthTest:(_ element:Element)-> Bool) -> Bool {
        let nonPassingElement = self.first { !truthTest($0) }
        return nonPassingElement == nil
    }
    
    // MARK: Mutables
    // TODO: Make tests to see the difference with the other chunk
    /**
     * Returns an array of arrays with the elements separated by size
     */
    mutating public func chunk(_ size:Int) -> [[Element]] {
        var result: [[Element]] = []
        while (self.count > 0) {
            result.append(self.splice(size))
        }
        return result;
    }
    
    
    /**
     * Returns the first element of the array and removes it from itself
     */
    public mutating func pop() -> Element? {
        return self.splice(1).first;
    }
    
    /**
     iterates over the collection and calls the given callback with each item in the collection. The items in the collection will be replaced by the values returned by the callback:
     */
    @discardableResult mutating public func transform(_ block:(_ element:Element)->Element) -> [Element] {
        self.eachWithIndex { (element, index) in
            self[index] = block(element)
        }
        return self;
    }
    
    @discardableResult mutating public func pad(_ count:Int, _ value:Element) -> [Element] {
        let size = count - self.count
        guard size > 0 else { return self }
        for _ in 0..<size {
            self.append(value)
        }
        return self
    }
    
    @discardableResult mutating public func lpad(_ count:Int, _ value:Element) -> [Element] {
        let size = count - self.count
        guard size > 0 else { return self }
        for _ in 0..<size {
            self.insert(value, at: 0)
        }
        return self
    }
    
    
    // MARK: Conditionals
    /**
     will execute the given callback unless the first argument given to the method evaluates to true:
     */
    @discardableResult mutating public func unless( _ unless:Bool, block:(inout [Element])->Void) -> [Element]{
        if (!unless) { block(&self) }
        return self
    }
    
    /**
     will execute the given callback when the first argument given to the method evaluates to true:
     */
    @discardableResult mutating public func when( _ when:Bool, block:(inout [Element])->Void) -> [Element]{
        if (when) { block(&self) }
        return self
    }
    
    /**
     The whenEmpty method will execute the given callback when the collection is empty:
     */
    @discardableResult mutating public func whenEmpty( block:(inout [Element])->Void) -> [Element]{
        if (self.count == 0) { block(&self) }
        return self
    }
    
    /**
     The whenEmpty method will execute the given callback when the collection is not empty:
     */
    @discardableResult mutating public func whenNotEmpty( block:(inout [Element])->Void) -> [Element]{
        if (self.count != 0) { block(&self) }
        return self
    }
    
        
}

extension Array where Element:Equatable {

    /**
     returns all of the unique items in the collection. The returned collection keeps the original array keys, so in this example we'll use the values method to reset the keys to consecutively numbered indexes:
     */
    public func unique() -> [Element] {
        var result:[Element] = []
        self.each {
            if (!result.contains($0)){
                result.append($0)
            }
        }
        return result
    }
    
    /**
    returns all of the unique items in the collection. The returned collection keeps the original array keys, so in this example we'll use the values method to reset the keys to consecutively numbered indexes:
    */
    public func unique<T:Equatable>(_ block:(_ element:Element)->T) -> [Element] {
        var result:[Element] = []
        var temp:[T] = []
        self.each {
            let hash = block($0)
            if (!temp.contains(hash)){
                result.append($0)
                temp.append(hash)
            }
        }
        return result
    }
    
    /**
     * Remove first collection element that is equal to the given `object`:
     */
    public mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }
}

extension Array where Element:Comparable {
    
    /**
     * Returns an array with all the elements between @firstValue and @lastValue first and last included
     */
    public func whereBetween(_ first:Element, and last:Element) -> [Element] {
        return self.filter{
            return $0 >= first && $0 <= last
        }
    }
    
}

extension Array where Element:Hashable {
    
    // MARK: Sets
    public func intersect(_ secondArray:[Element]) -> [Element] {
        let set1:Set<Element> = Set(self)
        let set2:Set<Element> = Set(secondArray)
        return Array(set1.intersection(set2))
    }
    
    public func union(_ secondArray:[Element]) -> [Element] {
        let set1:Set<Element> = Set(self)
        let set2:Set<Element> = Set(secondArray)
        return Array(set1.union(set2))
    }
    
    public func difference(_ secondArray:[Element]) -> [Element] {
        let set1:Set<Element> = Set(self)
        let set2:Set<Element> = Set(secondArray)
        return Array(set1.symmetricDifference(set2))
    }
    
    public func minus(_ secondArray:[Element]) -> [Element] {
        return Array(Set<Element>(self).subtracting(Set<Element>(secondArray)))
    }
}

/*extension Array where Element:AdditiveArithmetic{
    public func sum() -> Element {
        return self.reduce(0, +)
    }
}*/

extension Array where Element == String {
    public func implode(_ glue:String) -> String {
        return self.joined(separator: glue)
    }
    
    /**
    * The join method joins the collection's values with a string:
     */
    public func join(_ glue:String, lastGlue:String? = nil) -> String {
        if self.isEmpty { return "" }
        if self.count == 1 { return self.first! }
        guard let lastGlue = lastGlue else { return self.implode(glue) }
        let exceptLast = self.take(self.count - 1).implode(glue)
        return exceptLast + lastGlue + self.take(-1).first!
    }
}

public func - <Element: Hashable>(lhs: [Element], rhs: [Element]) -> [Element]
{
    return Array(lhs.minus(rhs))
}
