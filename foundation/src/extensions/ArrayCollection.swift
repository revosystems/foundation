import Foundation

extension Array where Element : NSObject {

    func firstWhere(_ keyPath : String, value:Any) -> Element?{
        return self.first ( where: { ($0.value(forKeyPath: keyPath) as! NSObject).isEqual(value) })
    }

    /**
    * Returns the first @count element of the array
    */
    func slice(_ count: Int) -> ArraySlice<Element>{
        return self.prefix(count);
    }

    /**
    * Splits the array into chucks of size @size and returns an array of arrays
    */
    func chunk(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }

    /**
    * Divides the array into chucks of size @size, and calls the @block with each splitted array
    */
    func chunk(into size: Int, _ block: (ArraySlice<Element>) -> Void  ) {
        stride(from: 0, to: count, by: size).forEach {
            block(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}