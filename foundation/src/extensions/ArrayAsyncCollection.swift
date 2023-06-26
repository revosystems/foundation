import Foundation

extension Array {
    public func asyncEach(block:(_ object:Element) async -> Void) async {
        for object in self {
            await block(object)
        }
    }
    
    public func asyncMap<T>(block:(_ object:Element) async -> T) async -> [T] {
        var newObjects:[T] = []
        for object in self {
            newObjects.append(await block(object))
        }
        return newObjects
    }
    
    public func asyncCompactMap<T>(block:(_ object:Element) async -> T?) async -> [T] {
        var newObjects:[T] = []
        for object in self {
            if let newObject = await block(object) {
                newObjects.append(newObject)
            }
        }
        return newObjects
    }
}
