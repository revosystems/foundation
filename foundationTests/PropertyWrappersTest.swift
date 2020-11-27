import XCTest
import RevoFoundation

class PropertyWrappersTest: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func test_force_bolean_works_with_string() throws {
        struct TestStruct : Codable {
            @ForcedBool var theBoolean:Bool
        }
        
        var json = """
        {
            "theBoolean" : "true",
        }
        """.data(using: .utf8)!

        var decoded = try! JSONDecoder().decode(TestStruct.self, from: json)
        XCTAssertTrue(decoded.theBoolean)
        
        json = """
        {
            "theBoolean" : "false",
        }
        """.data(using: .utf8)!

        decoded = try! JSONDecoder().decode(TestStruct.self, from: json)
        XCTAssertFalse(decoded.theBoolean)
    }
    
    func test_force_bolean_works_with_int() throws {
        struct TestStruct : Codable {
            @ForcedBool var theBoolean:Bool
        }
        
        var json = """
        {
            "theBoolean" : 1,
        }
        """.data(using: .utf8)!

        var decoded = try! JSONDecoder().decode(TestStruct.self, from: json)
        XCTAssertTrue(decoded.theBoolean)
        
        json = """
        {
            "theBoolean" : 0,
        }
        """.data(using: .utf8)!

        decoded = try! JSONDecoder().decode(TestStruct.self, from: json)
        XCTAssertFalse(decoded.theBoolean)
    }
    
    func test_force_bolean_works_with_boolean() throws {
        struct TestStruct : Codable {
            @ForcedBool var theBoolean:Bool
        }
        
        var json = """
        {
            "theBoolean" : true,
        }
        """.data(using: .utf8)!

        var decoded = try! JSONDecoder().decode(TestStruct.self, from: json)
        XCTAssertTrue(decoded.theBoolean)
        
        json = """
        {
            "theBoolean" : false,
        }
        """.data(using: .utf8)!

        decoded = try! JSONDecoder().decode(TestStruct.self, from: json)
        XCTAssertFalse(decoded.theBoolean)
    }
    
    func test_force_bolean_works_with_null() throws {
        struct TestStruct : Codable {
            @ForcedBool var theBoolean:Bool
        }
        
        let json = """
        {
            "theBoolean" : null,
        }
        """.data(using: .utf8)!

        let decoded = try! JSONDecoder().decode(TestStruct.self, from: json)
        XCTAssertFalse(decoded.theBoolean)
    }
    
    func test_force_boolean_can_be_encoded(){
        struct TestStruct : Codable {
            @ForcedBool var theBoolean:Bool
        }
        let sut = TestStruct(theBoolean: true)
        let encoded = String(data: try! JSONEncoder().encode(sut), encoding: .utf8)
        XCTAssertEqual("""
        {"theBoolean":true}
        """, encoded)
    }
    
    func test_force_int_works_with_string() throws {
        struct TestStruct : Codable {
            @ForcedInt var theInt:Int
        }
        
        var json = """
        {
            "theInt" : "15",
        }
        """.data(using: .utf8)!

        var decoded = try! JSONDecoder().decode(TestStruct.self, from: json)
        XCTAssertEqual(15, decoded.theInt)
        
        json = """
        {
            "theInt" : "abc",
        }
        """.data(using: .utf8)!

        decoded = try! JSONDecoder().decode(TestStruct.self, from: json)
        XCTAssertEqual(0, decoded.theInt)
        
        json = """
        {
            "theInt" : 110,
        }
        """.data(using: .utf8)!

        decoded = try! JSONDecoder().decode(TestStruct.self, from: json)
        XCTAssertEqual(110, decoded.theInt)
    }

    func test_force_int_can_be_encoded(){
        struct TestStruct : Codable {
            @ForcedInt var theInt:Int
        }
        let sut = TestStruct(theInt: 1500)
        let encoded = String(data: try! JSONEncoder().encode(sut), encoding: .utf8)
        XCTAssertEqual("""
        {"theInt":1500}
        """, encoded)
    }
    
    func test_force_decimal_and_double_works_with_string() throws {
        struct TestStruct : Codable {
            @ForcedDecimal var theDecimal:Decimal
            @ForcedDouble var theDouble:Double
        }
        
        var json = """
        {
            "theDecimal" : "15.50",
            "theDouble" : "15.50"
        }
        """.data(using: .utf8)!

        var decoded = try! JSONDecoder().decode(TestStruct.self, from: json)
        XCTAssertEqual(15.50, decoded.theDecimal)
        XCTAssertEqual(15.50, decoded.theDouble)
        
        json = """
        {
            "theDecimal" : "abc",
            "theDouble" : "abc"
        }
        """.data(using: .utf8)!

        decoded = try! JSONDecoder().decode(TestStruct.self, from: json)
        XCTAssertEqual(0, decoded.theDecimal)
        XCTAssertEqual(0, decoded.theDouble)
        
        json = """
        {
            "theDecimal" : 15.50,
            "theDouble" : 15.50
        }
        """.data(using: .utf8)!

        decoded = try! JSONDecoder().decode(TestStruct.self, from: json)
        XCTAssertEqual(15.50, decoded.theDecimal)
        XCTAssertEqual(15.50, decoded.theDouble)
    }
    
    func test_force_strings_works_with_numbers_and_bools() throws {
        struct TestStruct : Codable {
            @ForcedString var theString:String
        }
        
        var json = """
        {
            "theString" : 10,
        }
        """.data(using: .utf8)!

        var decoded = try! JSONDecoder().decode(TestStruct.self, from: json)
        XCTAssertEqual("10", decoded.theString)
        
        json = """
        {
            "theString" : 10.10,
        }
        """.data(using: .utf8)!

        decoded = try! JSONDecoder().decode(TestStruct.self, from: json)
        XCTAssertEqual("10.1", decoded.theString)
        
        json = """
        {
            "theString" : true,
        }
        """.data(using: .utf8)!

        decoded = try! JSONDecoder().decode(TestStruct.self, from: json)
        XCTAssertEqual("true", decoded.theString)
        
        json = """
        {
            "theString" : "an string",
        }
        """.data(using: .utf8)!

        decoded = try! JSONDecoder().decode(TestStruct.self, from: json)
        XCTAssertEqual("an string", decoded.theString)
        
        json = """
        {
            "theString" : null,
        }
        """.data(using: .utf8)!

        decoded = try! JSONDecoder().decode(TestStruct.self, from: json)
        XCTAssertEqual("", decoded.theString)
    }
}
