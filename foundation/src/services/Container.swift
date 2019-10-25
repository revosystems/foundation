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
    
    private var bindings:[String : () -> Any] = [:]
    private var singletons:[String : Any] = [:]
    
    // MARK: Resolvers
    public func resolve<T>(_ classType:T.Type) -> T.Type {
        return classType
    }
    
    public mutating func make<T>(_ classType:T.Type) -> T? {
        if let singleton = singletons[String(describing: classType)] {
            if (singleton is T){
                return singleton as? T
            }
            let value = (singleton as! (()->Any))()
            singletons[String(describing: classType)] = value
            return value as? T
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
    
}
