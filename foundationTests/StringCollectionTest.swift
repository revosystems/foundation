//
//  StringCollectionTest.swift
//  foundationTests
//
//  Created by Jordi Puigdellívol on 15/10/2019.
//  Copyright © 2019 Revo Systems. All rights reserved.
//

import XCTest

// https://laravel.com/docs/7.x/helpers#method-fluent-str-limit

@testable import RevoFoundation

class StringCollectionTest: XCTestCase {

    override func setUp() {}

    override func tearDown() {}

    func test_lpad() {
        let string = "abc"
        let result = string.lpad(toLength:10, withPad:"0")
        
        XCTAssertEqual("0000000abc", result)
    }
    
    func test_lpad_when_not_needed() {
        let string = "abc"
        let result = string.lpad(toLength:3, withPad:"0")
        
        XCTAssertEqual("abc", result)
    }
    
    func test_rpad() {
        let string = "abc"
        let result = string.rpad(toLength:10, withPad:"0")
        
        XCTAssertEqual("abc0000000", result)
    }
    
    
    func test_rpad_when_not_needed() {
        let string = "abc"
        let result = string.rpad(toLength:3, withPad:"0")
        
        XCTAssertEqual("abc", result)
    }
    
    func test_explode(){
        let result = "abc:def:jk".explode(":")
        XCTAssertEqual(["abc", "def", "jk"], result)
    }
    
    func test_uc_first(){
        XCTAssertEqual("HolA", "holA".ucFirst())
    }
    
    func test_lc_first(){
        XCTAssertEqual("holA", "HolA".lcFirst())
    }
    
    func test_uc_words(){
        XCTAssertEqual("My Little TowN", "my little towN".ucWords())
        XCTAssertEqual("My-Little-TowN", "my-little-towN".ucWords("-"))
    }
    
    func test_after(){
        XCTAssertEqual("this is my name", "this is my name".after("not in the string"))
        XCTAssertEqual(" my name", "this is my name".after("this is"))
    }
    
    func test_before(){
        XCTAssertEqual("this is my name", "this is my name".before("not in the string"))
        XCTAssertEqual("this is ", "this is my name".before("my name"))
    }
    
    func test_trim(){
        XCTAssertEqual("hello", "  hello  ".trim() )
        XCTAssertEqual("hello", "...hello...".trim(".") )
    }
    
    /*func test_ltrim(){
        XCTAssertEqual("hello   ", "  hello  ".ltrim() )
        XCTAssertEqual("hello...", "...hello...".ltrim(".") )
    }
    
    func test_rtrim(){
        XCTAssertEqual("   hello", "  hello  ".rtrim() )
        XCTAssertEqual("...hello", "...hello...".rtrim(".") )
    }*/
    
    func test_studly(){
        //XCTAssertEqual("FooBar", "foo_bar".camel())
    }
    
    func test_camel(){
        XCTAssertEqual("fooBar", "foo_bar".camel())
    }
    
    func test_snake(){
        XCTAssertEqual("foo_bar", "fooBar".snake())
    }
    
    func test_kebab(){
        XCTAssertEqual("foo-bar", "fooBar".kebab())
    }
    
    func test_contains_all(){
        XCTAssertTrue("my name".containsAll(["my", "name"]))
        XCTAssertFalse("my name".containsAll(["my", "name", "is"]))
    }
    
    func test_starts_with(){
        XCTAssertTrue("my potateo".startsWith("my"))
        XCTAssertFalse("my potateo".startsWith("potateo"))
    }
    
    func test_ends_with(){
        XCTAssertFalse("my potateo".endsWith("my"))
        XCTAssertTrue("my potateo".endsWith("potateo"))
    }
    
    func test_finish(){
        XCTAssertEqual("route/", "route".finish("/"))
        XCTAssertEqual("route/", "route/".finish("/"))
    }
    
    func test_start(){
        XCTAssertEqual("/route", "route".start("/"))
        XCTAssertEqual("/route/", "/route/".start("/"))
    }
    
    /*func test_prepend(){
        XCTAssertEqual("my name", "name".prepend("my "))
    }
    
    func test_append(){
        XCTAssertEqual("my name", "my".append(" name"))
    }*/
    
    func test_replace(){
        XCTAssertEqual("my other name", "my real name".replace("real", "other"))
    }
    
    func test_replace_first(){
        XCTAssertEqual("my other real name", "my real real name".replaceFirst("real", "other"))
    }
    
    func test_replace_matches(){
        XCTAssertEqual("15015551000", "(+1) 501-555-1000".replaceMatches("/[^A-Za-z0-9]++/", with: ""))
    }
    
    
    func test_remove(){
        XCTAssertEqual("hol que tl", "hola que tal".remove("a"))
    }
    
    func test_remove_with_string(){
        XCTAssertEqual("holquetl", "hola que tal".remove(["a", " "]))
    }
    
    func test_match(){
        
    }
    
    func test_substr(){
        
    }
    
    func test_when_empty_without_returning(){
        let called = XCTestExpectation(description: "not called")
        "".whenEmpty { string in
            called.fulfill()
        }
        
        "not empty".whenEmpty { string in
            XCTFail("as not empty")
        }
        wait(for: [called], timeout: 1)
    }
    
    func test_words(){
        XCTAssertEqual("Perfectly balanced, as >>>", "Perfectly balanced, as all things should be.".words(3, ending:" >>>"))
    }
    
    func test_limit(){
        XCTAssertEqual("Perfectly bal...", "Perfectly balanced, as all things should be.".limit(13, ending:"..."))
    }
    
    func test_string_subscripts(){
        let string = "hola que tal"
        let result = string[String.Index(encodedOffset: 2)...]
        XCTAssertEqual("la que tal", result)
    }
    
    func test_chunked(){
        let string = "abcdefghijklmn"
        let result = string.chunked(4)
        XCTAssertEqual(["abcd", "efgh", "ijkl", "mn"], result)
        
        let string2 = "ab"
        let result2 = string2.chunked(4)
        XCTAssertEqual(["ab"], result2)
        
        let string3 = "abcd"
        let result3 = string3.chunked(4)
        XCTAssertEqual(["abcd"], result3)
        
        let string4 = "abcdefgh"
        let result4 = string4.chunked(4)
        XCTAssertEqual(["abcd","efgh"], result4)
        
        let string5 = ""
        let result5 = string5.chunked(4)
        XCTAssertEqual([], result5)
    }
    
    func test_can_word_wrap(){
        let text = "this is a very long text that should be word wrapped"
        
        let result = text.lineWrap(maxSize: 10)
        XCTAssertEqual([
            "this is a",
            "very long",
            "text that",
            "should be",
            "word",
            "wrapped"
        ], result)
    }

}
