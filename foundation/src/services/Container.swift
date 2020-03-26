//
//  Container.swift
//  foundation
//
//  Created by Jordi Puigdellívol on 25/10/2019.
//  Copyright © 2019 Revo Systems. All rights reserved.
//


import Foundation

//https://laravel.com/docs/5.8/container

public func resolve<T>(_ type:T.Type = T.self) -> T  {
    try! Container.shared.make(type)
}

public func resolveOptional<T>(_ type:T.Type = T.self) -> T?  {
    try? Container.shared.make(type)
}

class Container {

    static var shared:Container = Container() //Already lazy
    
    enum ContainerError: Error {
        case runtimeError(String)
    }
    
    private var bindings:[String : () -> Any] = [:]
    private var singletons:[String : Any] = [:]
    private var extensions:[String : Any] = [:]
    
    // MARK: Resolvers
    /*public func resolve<T>(_ type:T.Type) -> T.Type {
        return type
    }*/
    
    public func make<T>(_ type:T.Type = T.self) throws -> T  {
        if let singleton = singletons[String(describing: type)] {
            if (singleton is T){
                return extendResolved(type, singleton as! T)
            }
            let value = (singleton as! (()->T))()
            singletons[String(describing: type)] = value
            return extendResolved(type, value)
        }
        if let bind = bindings[String(describing: type)] {
            return extendResolved(type, bind() as! T)
        }
        throw ContainerError.runtimeError("No binding for \(type)")
    }
    
    private func extendResolved<T,Z>(_ type:Z.Type, _ resolved:T)->T{
        guard let theExtension = extensions[String(describing: type)] else {
            return resolved
        }
        (theExtension as! (_ value:T)->Void)(resolved)
        return resolved
    }
    
    // MARK: Binders
    @discardableResult
    public func bind<T>(_ type:T.Type, bind:@escaping ()->T) -> Self {
        bindings[String(describing: type)] = bind
        return self
    }
    
    @discardableResult
    public func singleton<T>(_ type:T.Type, bind:@escaping ()->T) -> Self {
        singletons[String(describing: type)] = bind
        return self
    }
    
    @discardableResult
    public func instance<T>(_ type:T.Type, _ instance:T) -> Self{
        singletons[String(describing: type)] = instance
        return self
    }
    
    // MARK: Extend
    @discardableResult
    public func extend<T>(_ type:T.Type, theExtension:@escaping (_ resolved:T)->Void) -> Self{
        extensions[String(describing: type)] = theExtension
        return self
    }
    
}


@propertyWrapper
public struct Inject<Value> {
    
    public var wrappedValue: Value
    
    public init() {
        wrappedValue = try! Container.shared.make(Value.self)
    }
}
