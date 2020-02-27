import Foundation

@objc public class Cache : NSObject {
    
    /**
     Stores the value until the validDate, it replaces the value if it already exists
     */
    @objc @discardableResult public static func put(_ key:String, value:Any, validUntil: Date) -> Any{
        let cacheValue = ["value" : value, "validUntil" : validUntil];
        UserDefaults.standard.set(cacheValue, forKey: cacheKey(key))
        return value
    }
    
    /**
     Stores the value for @validForSeconds, it replaces the value if it already exists
     */
    @objc @discardableResult public static func put(_ key:String, value:Any, validForSeconds: Int) -> Any {
        put(key, value:value, validUntil:Date().addingTimeInterval(TimeInterval(validForSeconds)))
    }
    /**
     The add method will only add the item to the cache if it does not already exist in the cache store. The method will return true if the item is actually added to the cache. Otherwise, the method will return false:
     */
    static public func add(_ key: String, value:Any, validUntil: Date) {
        if (has(key)) { return }
        put(key, value:value, validUntil: validUntil)
    }
    
    /**
     Retrieve & Store
     Sometimes you may wish to retrieve an item from the cache, but also store a default value if the requested item doesn't exist. For example, you may wish to retrieve all users from the cache or, if they don't exist, retrieve them from the database and add them to the cache. You may do this using the Cache::remember method:
     */
    @objc @discardableResult static public func remember(_ key:String, seconds:Int, whatToRemember:() -> Any) -> Any{
        remember(key, date: Date().addingTimeInterval(TimeInterval(seconds)), whatToRemember: whatToRemember)
    }
    
    /**
     Retrieve & Store
     Sometimes you may wish to retrieve an item from the cache, but also store a default value if the requested item doesn't exist. For example, you may wish to retrieve all users from the cache or, if they don't exist, retrieve them from the database and add them to the cache. You may do this using the Cache::remember method:
     */
    @objc @discardableResult static public func remember(_ key:String, date:Date, whatToRemember:() -> Any) -> Any{
        if let value = get(key) {
            return value
        }
        
        let value = whatToRemember();
        put(key, value:value, validUntil: date)
        return value
    }
    
    /**
     The get method on the Cache facade is used to retrieve items from the cache. If the item does not exist in the cache, null will be returned. If you wish, you may pass a second argument to the get method specifying the default value you wish to be returned if the item doesn't exist:
     */
    @objc public static func get(_ key: String) -> Any? {
        guard let cachedValue: [String: Any] = UserDefaults.standard.value(forKey: cacheKey(key)) as? [String: Any] else {
            return nil
        }
        let validUntil: Date = cachedValue["validUntil"] as! Date;
        if Date() > validUntil {
            forget(key)
            return nil
        }
        return cachedValue["value"]!
    }
    
    /**
     The get method on the Cache facade is used to retrieve items from the cache. If the item does not exist in the cache, null will be returned. If you wish, you may pass a second argument to the get method specifying the default value you wish to be returned if the item doesn't exist:
     */
    @objc static public func get(_ key: String, defaultValue:Any) -> Any? {
        get(key) ?? defaultValue;
    }
    
    /**
     The get method on the Cache facade is used to retrieve items from the cache. If the item does not exist in the cache, null will be returned. If you wish, you may pass a second argument to the get method specifying the default value you wish to be returned if the item doesn't exist:
     */
    static public func get(_ key: String, defaultValue:() -> Any ) -> Any{
        get(key) ?? defaultValue()
    }
    
    /**
     If you need to retrieve an item from the cache and then delete the item, you may use the pull method. Like the get method, null will be returned if the item does not exist in the cache:
     */
    static public func pull(_ key : String) -> Any?{
        let value = get(key);
        if value != nil {
            forget(key)
        }
        return value
    }
    
    /**
     The has method may be used to determine if an item exists in the cache. This method will return false if the value is null:
     */
    static public func has(_ key : String) -> Bool{
        UserDefaults.standard.value(forKey: cacheKey(key))  != nil;
    }
    
    /**
     You may remove items from the cache using the forget method:
     */
    @objc static public func forget(_ key : String){
        UserDefaults.standard.removeObject(forKey: cacheKey(key))
    }
    
    private static func cacheKey(_ key:String) -> String{
        "cache-\(key)"
    }
}
