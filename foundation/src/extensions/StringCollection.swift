import Foundation

public func str(_ format:String, _ arguments:CVarArg...) -> String {
    String(format:format, arguments: arguments)
}

extension String{

    public func match(_ regex: String) -> [[String]] {
        let nsString = self as NSString
        return (try? NSRegularExpression(pattern: regex, options: []))?.matches(in: self, options: [], range: NSMakeRange(0, count)).map { match in
            (0..<match.numberOfRanges).map { match.range(at: $0).location == NSNotFound ? "" : nsString.substring(with: match.range(at: $0)) }
        } ?? []
    }

    public func toDict() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    public func urlEncoded() -> String? {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }

    public func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    public func toBase64() -> String {
        Data(self.utf8).base64EncodedString()
    }

    public static func fromDict(_ dict: Dictionary<String, Codable?>) -> String {
        if let theJSONData = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            let theJSONText = String(data: theJSONData, encoding: .ascii)
            return theJSONText ?? ""
        }
        return ""
    }

    public func replace(_ what:String, _ with:String) -> String {
        replacingOccurrences(of: what, with: with)
    }

    public func trim(_ what:String = " ") -> String {
        trimmingCharacters(in: CharacterSet(charactersIn: what))
    }
    
    public func lpad(toLength:Int, withPad:String = " ") -> String {
        let size = toLength - self.count
        return Array<String>.times(size, { _ in withPad }).reduce("", +) + self
    }
    
    public func rpad(toLength:Int, withPad:String = " ") -> String {
        self.padding(toLength: toLength, withPad: withPad, startingAt: 0)
    }
    
    public func limit(_ limit:Int, ending:String = "") -> String {
        guard count > limit else { return self }
        return prefix(limit) + ending
    }
    
    public func ucFirst() -> String {
      prefix(1).uppercased() + dropFirst()
    }
}
