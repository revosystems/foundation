import Foundation


public class CodableTransformer<T: Codable>: ValueTransformer {
    
    public static func register(type: T.Type, name: String) {
        ValueTransformer.setValueTransformer(CodableTransformer<T>(), forName: NSValueTransformerName(name))
    }
    
    public override func transformedValue(_ value: Any?) -> Any? {
        guard let value = value as? T else { return nil }
        
        do {
            let kk = try JSONEncoder().encode(value)
            print(kk)
            return kk
        } catch {
            print("Error encoding \(T.self): \(error)")
            return nil
        }
    }

    public override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Error decoding \(T.self): \(error)")
            return nil
        }
    }
    
}
