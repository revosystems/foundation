import Foundation

//https://www.swiftbysundell.com/articles/sorting-swift-collections/
struct SortDescriptor<Value> {
    var comparator: (Value, Value) -> ComparisonResult
}

extension SortDescriptor {
    static func keyPath<T: Comparable>(_ keyPath: KeyPath<Value, T>) -> Self {
        Self { rootA, rootB in
            let valueA = rootA[keyPath: keyPath]
            let valueB = rootB[keyPath: keyPath]

            guard valueA != valueB else {
                return .orderedSame
            }

            return valueA < valueB ? .orderedAscending : .orderedDescending
        }
    }
}

enum SortOrder {
    case ascending
    case descending
}

extension Sequence {
    func sorted(using descriptors: [SortDescriptor<Element>], order: SortOrder) -> [Element] {
        sorted { valueA, valueB in
            for descriptor in descriptors {
                let result = descriptor.comparator(valueA, valueB)

                switch result {
                case .orderedSame:
                    // Keep iterating if the two elements are equal,
                    // since that'll let the next descriptor determine
                    // the sort order:
                    break
                case .orderedAscending:
                    return order == .ascending
                case .orderedDescending:
                    return order == .descending
                }
            }

            // If no descriptor was able to determine the sort
            // order, we'll default to false (similar to when
            // using the '<' operator with the built-in API):
            return false
        }
    }
    
    func sorted(using descriptors: SortDescriptor<Element>...) -> [Element] {
        sorted(using: descriptors, order: .ascending)
    }
}

extension Array {
    /**
     * Returns the collection sorted by the @keyPath, this one keeps the original array intact
     */
    public func sort<T: Comparable>(by keyPath: KeyPath<Element, T?>, nilAtBeginning:Bool = false) -> [Element] {
        sorted { a, b in
            guard let first = a[keyPath: keyPath] else {
                return nilAtBeginning
            }
            guard let second = b[keyPath: keyPath] else {
                return !nilAtBeginning
            }
            return first < second
        }
    }

    public func sort<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { a, b in
            a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
}


extension Array where Element:Hashable {
    
    public func reordered(_ defaultOrder:[Element]) -> [Element] {
        return self.sorted { (a, b) -> Bool in
            if let first = defaultOrder.firstIndex(of: a), let second = defaultOrder.firstIndex(of: b) {
                return first < second
            }
            return false
        }
    }
}
