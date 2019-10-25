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
    
    internal var bindings:[String : ()->Any] = [:]
    
    // MARK: Resolvers
    public func resolve<T>(_ classType:T.Type) -> T.Type {
        return classType
    }
    
    public func make<T>(_ classType:T.Type) -> T? {
        guard let bind = bindings[String(describing: classType)] else {
            return nil
        }
        return bind() as? T
    }
    
    // MARK: Binders
    public mutating func bind<T>(_ classType:T.Type, bind:@escaping ()->T) {
        bindings[String(describing: classType)] = bind
    }
    
}
