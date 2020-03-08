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
    
    public func replaceFirst(_ what:String, _ with:String) -> String {
        if let range = range(of: what) {
            var newString = self
            newString.replaceSubrange(range, with: with)
            return newString
        }
        return self
    }
    
    /**
     The replaceMatches method replaces all portions of a string matching a given pattern with the given replacement string:
     */
    public func replaceMatches(_ pattern:String, with:String) -> String {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1\(with)$2") ?? self
    }

    /**
     The trim method trims the given string:
     */
    public func trim(_ what:String = " ") -> String {
        trimmingCharacters(in: CharacterSet(charactersIn: what))
    }
    
    /**
     The trim method trims the given string just the left side
     */
    /*public func ltrim(_ what:String = " ") -> String {
        trimmingCharacters(in: CharacterSet(charactersIn: what))
    }*/
    
    /**
     The trim method trims the given string, just the right side
     */
    /*public func rtrim(_ what:String = " ") -> String {
        trimmingCharacters(in: CharacterSet(charactersIn: what))
    }*/
    
    public func lpad(toLength:Int, withPad:String = " ") -> String {
        let size = toLength - self.count
        return Array<String>.times(size, { _ in withPad }).reduce("", +) + self
    }
    
    public func rpad(toLength:Int, withPad:String = " ") -> String {
        self.padding(toLength: toLength, withPad: withPad, startingAt: 0)
    }
    
    /*
     The limit method truncates the given string at the specified length:
     */
    public func limit(_ limit:Int, ending:String = "") -> String {
        guard count > limit else { return self }
        return prefix(limit) + ending
    }
    
    /**
     The explode method splits the string by the given delimiter and returns a collection containing each section of the split string:
     */
    public func explode(_ separator:String) -> [String] {
        components(separatedBy: separator)
    }
    
    public func ucFirst() -> String {
      prefix(1).uppercased() + dropFirst()
    }
    
    public func lcFirst() -> String {
      prefix(1).lowercased() + dropFirst()
    }
    
    public func ucWords(_ separator:String = " ") -> String{
        explode(separator).map { $0.ucFirst() }.implode(separator)
    }
    
    /**
     The whenEmpty method invokes the given Closure if the string is empty. If the Closure returns a value, that value will also be returned by the whenEmpty method. If the Closure does not return a value, the fluent string instance will be returned:
     */
    public func whenEmpty<T>(block:(_ string:String)->T?) -> T?{
        if isEmpty { return block(self) }
        return nil
    }
    
    @discardableResult
    public func whenEmpty(block:(_ string:String) -> Void) -> String{
        if isEmpty { block(self) }
        return self
    }
    
    /**
     The after method returns everything after the given value in a string. The entire string will be returned if the value does not exist within the string:
     */
    public func after(_ what:String) -> String {
        guard let found = range(of: what) else { return self }
        let start = index(found.upperBound, offsetBy: 0)
        return String(self[start...])
    }
    
    /**
     The before method returns everything before the given value in a string:
     */
    public func before(_ what:String) -> String {
        guard let found = range(of: what) else { return self }
        let start = index(found.lowerBound, offsetBy: -1)
        return String(self[...start])
    }
    
    /**
     The Str::containsAll method determines if the given string contains all array values:
     */
    public func containsAll(_ what:[String]) -> Bool{
        what.allSatisfy { self.contains($0) }
    }
    
    /**
     The words method limits the number of words in a string:
     */
    public func words(_ howMany:Int, ending:String = "" ) -> String {
        explode(" ").take(howMany).implode(" ") + ending
    }
    
    // MARK: Start / End
    
    /**
     The startsWith method determines if the given string begins with the given value:
     */
    public func startsWith(_ what:String) -> Bool{
        hasPrefix(what)
    }
    
    /**
     The Str::endsWith method determines if the given string ends with the given value:
     */
    public func endsWith(_ what:String) -> Bool{
        hasSuffix(what)
    }
    
    /**
     The Str::finish method adds a single instance of the given value to a string if it does not already end with the value:
     */
    public func finish(_ with:String) -> String {
        if endsWith(with) { return self }
        return self + with
    }
    
    /**
     The Str::start method adds a single instance of the given value to a string if it does not already start with the value:
     */
    public func start(_ with:String) -> String {
        if startsWith(with) { return self }
        return with + self
    }
    
    public func prepend(_ with:String) -> String {
        with + self
    }
    
    public func append(_ with:String) -> String {
        self + with
    }
    
    // MARK: Case types
    /**
     The studly method converts the given string to StudlyCase: foo_bar => FooBar
     */
    public func studly() -> String {
        explode("_").map { $0.ucFirst() }.implode("")
    }
    
    /**
    The Str::camel method converts the given string to camelCase: foo_bar => fooBar
    */
    public func camel() -> String {
       studly().lcFirst()
    }
    
    /**
     The snake method converts the given string to snake_case: fooBar => foo_bar
     https://gist.github.com/dmsl1805/ad9a14b127d0409cf9621dc13d237457
     */
    public func snake(_ glue:String = "_") -> String {
        let pattern = "([a-z0-9])([A-Z])"

        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1\(glue)$2").lowercased() ?? self
    }

    /**
    The kebab method converts the given string to kebab-case: kebabKase => kebab-case
    */
    public func kebab() -> String {
        snake("-")
    }
}
