//
//  FlatBuffers.swift
//  SwiftFlatBuffers
//
//  Created by Maxim Zaks on 21.11.15.
//  Copyright © 2015 maxim.zaks. All rights reserved.
//

import Foundation

public typealias Offset = Int32

public protocol Scalar : Equatable {}

extension Bool : Scalar {}
extension Int8 : Scalar {}
extension UInt8 : Scalar {}
extension Int16 : Scalar {}
extension UInt16 : Scalar {}
extension Int32 : Scalar {}
extension UInt32 : Scalar {}
extension Int64 : Scalar {}
extension UInt64 : Scalar {}
extension Int : Scalar {}
extension UInt : Scalar {}
extension Float32 : Scalar {}
extension Float64 : Scalar {}

public protocol PoolableInstances : AnyObject {
    static var maxInstanceCacheSize : UInt { get set }
    static var instancePool : ContiguousArray<Self> { get set }
    static var instancePoolMutex : pthread_mutex_t { get set } /// Should be initialized to setupInstancePoolMutex
    init()
    func reset()
}

public extension PoolableInstances {
    
    // Must be called to initialize mutex
    public static func setupInstancePoolMutex() -> pthread_mutex_t
    {
        var mtx = pthread_mutex_t()
        pthread_mutex_init(&mtx, nil)
        return mtx
    }
    
    // Optional preheat of instance pool
    public static func fillInstancePool(initialPoolSize : UInt) -> Void {
        pthread_mutex_lock(&instancePoolMutex)
        defer { pthread_mutex_unlock(&instancePoolMutex) }

        while ((UInt(instancePool.count) < initialPoolSize) && (UInt(instancePool.count) < maxInstanceCacheSize))
        {
            instancePool.append(Self())
        }
    }
    
    public static func createInstance() -> Self {
        guard maxInstanceCacheSize > 0 else // avoid taking the mutex if not using pool
        {
            return Self()
        }
        
        pthread_mutex_lock(&instancePoolMutex)
        defer { pthread_mutex_unlock(&instancePoolMutex) }

        if (instancePool.count > 0)
        {
            let instance = instancePool.removeLast()
            return instance
        }
        return Self()
    }
    
    // reuseInstance can be called when we believe we are about to zero out
    // the final strong reference we hold ourselves to put the instance in for reuse
    public static func reuseInstance(inout instance : Self) {
        guard maxInstanceCacheSize > 0 else // avoid taking the mutex if not using pool
        {
            return // don't pool
        }

        pthread_mutex_lock(&instancePoolMutex)
        defer { pthread_mutex_unlock(&instancePoolMutex) }
        
        if (isUniquelyReferencedNonObjC(&instance) && (UInt(instancePool.count) < maxInstanceCacheSize))
        {
            instance.reset()
            instancePool.append(instance)
        }
    }
}
