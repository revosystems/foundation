import XCTest
@testable import RevoFoundation

protocol MyProtocol : Resolvable {
    init()
    func hello() -> Bool
}

class ContainerTest: XCTestCase {

    class ImageDownloader : Resolvable {
        required init() {}
    }
    
    class Gravatar : Resolvable {
        required init() {}
    }
    
    class ImageDownloaderMock : ImageDownloader {
        required init() {}
    }
    
    override func setUp() {}

    override func tearDown() {}

   
    func test_it_can_resolve_a_class_from_container(){
           let resolved  = Container.shared.resolve(ImageDownloader.self)
           let resolved2 = Container.shared.resolve(Gravatar.self)
           
           XCTAssertTrue(resolved != nil)
           XCTAssertTrue(resolved2 != nil)
       }
       
       func test_it_can_register_a_resolver(){
           Container.shared.bind(ImageDownloader.self, ImageDownloaderMock.self)
           
           let resolved = Container.shared.resolve(ImageDownloader.self)
           
           XCTAssertTrue(resolved is ImageDownloaderMock)
       }
       
       func test_it_can_register_a_resolver_instance(){
           let mock = Container.shared.bind(ImageDownloader.self, ImageDownloaderMock.self())
           
           let resolved = Container.shared.resolve(ImageDownloader.self)
           
           XCTAssertTrue(resolved === mock)
       }
       
       func test_can_autoinject_a_depencency(){
           Container.shared.bind(ImageDownloader.self, ImageDownloaderMock.self)
           struct TestClass {
               @Inject var imageDownloader:ImageDownloader!
           }
           
           let image = TestClass()
           XCTAssertTrue(image.imageDownloader is ImageDownloaderMock)
           
       }
    
    func test_can_make_non_registered_class(){
        struct TestStruct{ }
        let container = Container()
        let result = container.resolve(TestStruct.self)
        //TODO: Make this work so it doesn't return nil
        XCTAssertNil(result)
    }
    
    func test_can_bind_clousure() {
        struct TestStruct{ let name:String }
        let container = Container()
        
        container.bind(TestStruct.self) {
            TestStruct(name: "Sexy")
        }
        
        var result = container.resolve(TestStruct.self)!
        XCTAssertEqual("Sexy", result.name)
        
        container.bind(TestStruct.self) {
            TestStruct(name: "Not Sexy")
        }
        result = container.resolve(TestStruct.self)!
        XCTAssertEqual("Not Sexy", result.name)
    }
    
    func test_closure_binding_is_not_a_singleton(){
        class TestStruct{ let name:String = "Sexy" }
        let container = Container()
        
        container.bind(TestStruct.self) {
            TestStruct()
        }
        let result1 = container.resolve(TestStruct.self)
        let result2 = container.resolve(TestStruct.self)
        
        XCTAssertFalse(result1 === result2)
    }
    
    
    func test_can_bind_a_singleton() {
        class TestStruct { let name:String = "Sexy" }
        let container = Container()
        
        container.bind(singleton: TestStruct.self) {
            TestStruct()
        }
        
        let result1 = container.resolve(TestStruct.self)
        let result2 = container.resolve(TestStruct.self)
        
        XCTAssertTrue(result1 === result2)
    }
    
    func test_can_bind_an_instance(){
        class TestStruct{ let name:String = "Sexy" }
        let container = Container()
        
        let instance = TestStruct()
        container.bind(instance: TestStruct.self, instance)
        
        let result1 = container.resolve(TestStruct.self)
        let result2 = container.resolve(TestStruct.self)
        
        XCTAssertTrue(result1 === instance)
        XCTAssertTrue(result2 === instance)
    }
        
    func test_can_extend_a_resolver(){
        class TestStruct{ var name:String = "Sexy" }
        let container = Container()
        
        let instance = TestStruct()
        container.bind(instance: TestStruct.self, instance)
        
        container.extend(TestStruct.self) {
            $0.name = "Super Sexy"
        }
        
        let result = container.resolve(TestStruct.self)!
        XCTAssertEqual("Super Sexy", result.name)
    }

    func test_can_bind_a_type(){
        class TestStruct{ var name:String = "Sexy" }
        class TestStruct2: TestStruct {  }
        let container = Container()
        
        container.bind(TestStruct.self, TestStruct2.init)
        
        let result = container.resolve(TestStruct.self)!
        XCTAssertTrue(result is TestStruct2)
    }
    
    /*func test_can_resolve_with_type_inference(){
        class TestStruct{ var name:String = "Sexy" }
        class TestStruct2: TestStruct {  }
        let container = Container()
        
        container.bind(TestStruct.self, TestStruct2.init)
        
        let result:TestStruct = container.resolve()
        XCTAssertTrue(result is TestStruct2)
    }*/
    
    
    func test_can_autoinject(){
        
        class TestStruct{ var name:String = "Sexy" }
        class TestStruct2: TestStruct {  }
        
        Container.shared.bind(TestStruct.self, TestStruct2.init)
        
        class TestStruct3{
            @Inject var theStruct:TestStruct?
        }
        
        let result = TestStruct3()
        XCTAssertTrue(result.theStruct is TestStruct2)
    }
    
    
    func test_can_resolve_protocol(){
        struct A : MyProtocol {
            func hello() -> Bool {
                false
            }
        }
        struct B : MyProtocol {
            func hello() -> Bool {
                true
            }
        }
        
        Container.shared.bind(A.self, B.self)
        
        let resolved = Container.shared.resolve(A.self)!
        
        XCTAssertTrue(resolved.hello())
    }
    
    /*func test_can_get_the_resolver(){
        struct A : MyProtocol {
            func hello() -> Bool {
                false
            }
        }
        struct B : MyProtocol {
            func hello() -> Bool {
                true
            }
        }
        
        Container.shared.bind(A.self, B.self)
        
        let resolver = Container.shared.resolve(A.self)
        
        //let resolver = Container.shared.resolver(for: A.self, ofProtocol:MyProtocol.self)!
        
        XCTAssertTrue(resolver.init() is B)
    }*/
    
    
    //TODO: Bind and resolve with tags
    
}
