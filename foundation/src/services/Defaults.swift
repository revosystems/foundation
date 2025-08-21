import Foundation


extension UserDefaults : Resolvable {
}


open class Defaults {
    
    public let defaults:UserDefaults
    
    public init(_ defaults:UserDefaults = Container.shared.resolve(UserDefaults.self)!){
        self.defaults = defaults
    }

    @discardableResult
    public static func fake() -> Defaults{
        let fake = UserDefaults(suiteName: "fake")
        Container.shared.bind(instance: UserDefaults.self, fake)
        return Defaults()
    }
    
    open func set(value:Any?, key:String) {
        if value == nil {
            return remove(key)
        }
        defaults.setValue(value, forKey: key)
    }

    open func remove(_ key:String) {
        defaults.removeObject(forKey: key)
    }

    open func value(for key:String) -> Any? {
        defaults.value(forKey: key)
    }

}


@propertyWrapper
public struct UserDefault<Value> {
    public let key: String
    public let defaultValue: Value?
    public var defaults: Defaults
    
    
    public init(key: String, defaultValue: Value?, defaults: Defaults = Defaults()) {
        self.key = key
        self.defaultValue = defaultValue
        self.defaults = defaults
    }

    public var wrappedValue: Value? {
        get {
            return defaults.value(for: key) as? Value ?? defaultValue
        }
        set {
            guard let newValue else {
                defaults.remove(key)
                return
            }
            
            defaults.set(value: newValue, key: key)
        }
    }
}
