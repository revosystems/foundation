import Foundation

@propertyWrapper
public struct ForcedBool : Codable {
    
    public var wrappedValue:Bool
    
    public init(wrappedValue:Bool){
        self.wrappedValue = wrappedValue
    }
    
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            self.wrappedValue = stringValue.lowercased() == "true"
            return
        }
        if let intValue = try? container.decode(Int.self) {
            self.wrappedValue = intValue == 1
            return
        }
        self.wrappedValue = (try? container.decode(Bool.self)) ?? false
    }
}

@propertyWrapper
public struct ForcedInt : Codable {
    
    public var wrappedValue:Int
    
    public init(wrappedValue:Int){
        self.wrappedValue = wrappedValue
    }
    
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            if let intValue = Int(stringValue) {
                self.wrappedValue = intValue
                return
            }
        }
        if let boolValue = try? container.decode(Bool.self) {
            self.wrappedValue = boolValue ? 1 : 0
            return
        }
        self.wrappedValue = (try? container.decode(Int.self)) ?? 0
    }
}


@propertyWrapper
public struct ForcedDecimal : Codable {
    
    public var wrappedValue:Decimal
    
    public init(wrappedValue:Decimal){
        self.wrappedValue = wrappedValue
    }
    
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            if let value = Decimal(string: stringValue) {
                self.wrappedValue = value
                return
            }
        }
        self.wrappedValue = (try? container.decode(Decimal.self)) ?? 0
    }
}

@propertyWrapper
public struct ForcedDouble : Codable {
    
    public var wrappedValue:Double
    
    public init(wrappedValue:Double){
        self.wrappedValue = wrappedValue
    }
    
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            if let value = Double(stringValue) {
                self.wrappedValue = value
                return
            }
        }
        self.wrappedValue = (try? container.decode(Double.self)) ?? 0
    }
}

@propertyWrapper
public struct ForcedString : Codable {
    
    public var wrappedValue:String
    
    public init(wrappedValue:String){
        self.wrappedValue = wrappedValue
    }
    
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Int.self) {
            self.wrappedValue = String(value)
            return
        }
        if let value = try? container.decode(Double.self) {
            self.wrappedValue = String(value)
            return
        }
        if let value = try? container.decode(Bool.self) {
            self.wrappedValue = value ? "true" : "false"
            return
        }
        self.wrappedValue = (try? container.decode(String.self)) ?? ""
    }
}

/*@propertyWrapper
public struct Forced<T:Codable>: Codable {
    
    public var wrappedValue:T
    
    public init(wrappedValue:T){
        self.wrappedValue = wrappedValue
    }
    
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            if let value = T(string: stringValue) {
                self.wrappedValue = value
                return
            }
        }
        self.wrappedValue = (try? container.decode(T.self)) ?? 0
    }
}*/


