//
//  Container.swift
//  foundation
//
//  Created by Jordi Puigdellívol on 25/10/2019.
//  Copyright © 2019 Revo Systems. All rights reserved.
//


import Foundation

//https://laravel.com/docs/5.8/container

struct Container {
    
    private lazy var bindings:[String : () -> Any] = [:]
    private lazy var singletons:[String : Any] = [:]
    private lazy var extensions:[String: (_ resolved:Any)->Void] = [:]
    
    // MARK: Resolvers
    public func resolve<T>(_ classType:T.Type) -> T.Type {
        return classType
    }
    
    public mutating func make<T>(_ classType:T.Type) -> T? {
        if let singleton = singletons[String(describing: classType)] {
            if (singleton is T){
                return singleton as? T
            }
            let value = (singleton as! (()->T))()
            singletons[String(describing: classType)] = value
            return value
        }
        if let bind = bindings[String(describing: classType)] {
            return bind() as? T
        }
        return nil
        
    }
    
    // MARK: Binders
    public mutating func bind<T>(_ classType:T.Type, bind:@escaping ()->T) {
        bindings[String(describing: classType)] = bind
    }
    
    public mutating func singleton<T>(_ classType:T.Type, bind:@escaping ()->T) {
        singletons[String(describing: classType)] = bind
    }
    
    public mutating func instance<T>(_ classType:T.Type, _ instance:T) {
        singletons[String(describing: classType)] = instance
    }
    
    // MARK: Extend
    public mutating func extend<T>(_ classType:T.Type, theExtension:@escaping (_ resolved:T)->Void) {
        extensions[String(describing: classType)] = theExtension
    }
    
}
