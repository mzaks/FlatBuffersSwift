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

extension Scalar {
    var littleEndian : Self {
        switch self {
        case let v as Int16 : return v.littleEndian as! Self
        case let v as UInt16 : return v.littleEndian as! Self
        case let v as Int32 : return v.littleEndian as! Self
        case let v as UInt32 : return v.littleEndian as! Self
        case let v as Int64 : return v.littleEndian as! Self
        case let v as UInt64 : return v.littleEndian as! Self
        case let v as Int : return v.littleEndian as! Self
        case let v as UInt : return v.littleEndian as! Self
        default : return self
        }
    }
}

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
    static var instancePool : [Self] { get set }
    init()
    func reset()
}

public extension PoolableInstances {
    
    // Optional preheat of instance pool
    public static func fillInstancePool(initialPoolSize : UInt) -> Void {
        while ((UInt(instancePool.count) < initialPoolSize) && (UInt(instancePool.count) < maxInstanceCacheSize))
        {
            instancePool.append(Self())
        }
    }
    
    public static func createInstance() -> Self {
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
        
        if (isUniquelyReferencedNonObjC(&instance) && (UInt(instancePool.count) < maxInstanceCacheSize))
        {
            instance.reset()
            instancePool.append(instance)
        }
    }
}
