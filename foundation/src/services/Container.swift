import Foundation

//https://laravel.com/docs/5.8/container

public protocol Resolvable{
    init()
}

public class Container {
    
    public static var shared = Container()
    
    var resolvers:[String : Any] = [:]
    var extensions:[String : Any] = [:]
    
    // MARK:- Binding
    public func bind<T:Resolvable, Z:Resolvable>(_ type:T.Type, _ resolver:Z.Type) {
        resolvers[String(describing: type)] = resolver
    }
    
    @discardableResult
    public func bind<T:Resolvable>(_ type:T.Type, _ resolver:T) -> T {
        resolvers[String(describing: type)] = resolver
        return resolver
    }
    
    public func bind<T>(_ type:T.Type, _ clousure:@escaping()->T) {
        resolvers[String(describing: type)] = clousure
    }
    
    public func bind<T>(singleton type:T.Type, _ clousure:@escaping()->T) {
        resolvers[String(describing: type)] = clousure()
    }
    
    public func bind<T, Z>(instance type:T.Type, _ resolver:Z) {
        resolvers[String(describing: type)] = resolver
    }
      
    // MARK:- Extension
    public func extend<T>(_ type:T.Type, theExtension:@escaping (_ resolved:T)->Void){
        extensions[String(describing: type)] = theExtension
    }
    
    func extend<T,Z>(for type:T.Type, resolved:Z) -> Z {
        guard let theExtension = extensions[String(describing: type)] else {
            return resolved
        }
        (theExtension as! (_ value:Z)->Void)(resolved)
        return resolved
    }
    
    // MARK:- Resolving
    public func resolve<T>(_ type:T.Type) -> T? {
        guard let resolved:T = resolve(withoutExtension:type) else { return nil }
        return extend(for:type, resolved:resolved)
    }
    
    public func resolve<T>(withoutExtension type:T.Type) -> T? {
        guard let resolver = resolvers[String(describing: type)] else {
            if type.self is Resolvable.Type {
                return (type as! Resolvable.Type).init() as? T
            }
            return nil
        }
        if let resolvable = resolver as? Resolvable.Type {
            return resolvable.init() as? T
        }
        if let resolvable = resolver as? T {
            return resolvable
        }
        if let resolvable = resolver as? (()->T) {
            return resolvable()
        }
        return nil
    }
}


@propertyWrapper
public struct Inject<Value>{
    public var wrappedValue: Value?
    
    public init() {
        wrappedValue = Container.shared.resolve(Value.self)
    }
}

