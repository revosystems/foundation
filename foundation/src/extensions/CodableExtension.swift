import Foundation

extension Encodable {
    public func encode(with encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
    
    public func json(with encoder: JSONEncoder = JSONEncoder()) throws -> String {
        return try String(data: encoder.encode(self), encoding: .utf8)!
    }
    
    @available(*, deprecated, renamed: "json")
    public func encodedString(with encoder: JSONEncoder = JSONEncoder()) throws -> String {
        try String(data: encoder.encode(self), encoding: .utf8)!
    }
}

extension Decodable {
    public static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
}

extension Encodable where Self: Decodable {
    public func copy() -> Self? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            return try JSONDecoder().decode(Self.self, from: jsonData)
        } catch {
            print("Error copying object: \(error)")
            return nil
        }
    }
}
