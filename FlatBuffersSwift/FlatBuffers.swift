//
//  FlatBuffers.swift
//  SwiftFlatBuffers
//
//  Created by Maxim Zaks on 21.11.15.
//  Copyright © 2015 maxim.zaks. All rights reserved.
//

public protocol Offset {
    var value : Int32 {get}
}

public struct StringOffset : Offset {
    let _value : Int32
    init(_ value : Int32){
        _value = value
    }
    init(_ value : Int){
        self.init(Int32(value))
    }
    public var value : Int32 {return _value}
}

public struct VectorOffset : Offset {
    let _value : Int32
    init(_ value : Int32){
        _value = value
    }
    init(_ value : Int){
        self.init(Int32(value))
    }
    
    public var value : Int32 {return _value}
}

public struct ObjectOffset : Offset {
    let _value : Int32
    init(_ value : Int32){
        _value = value
    }
    init(_ value : Int){
        self.init(Int32(value))
    }
    public var value : Int32 {return _value}
}


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
