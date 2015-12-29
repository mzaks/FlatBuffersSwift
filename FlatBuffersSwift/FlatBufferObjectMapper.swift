//
//  FlatBufferObjectMapper.swift
//  SwiftFlatBuffers
//
//  Created by Maxim Zaks on 22.11.15.
//  Copyright © 2015 maxim.zaks. All rights reserved.
//


public protocol Table {}

extension FlatBufferBuilder {
    public func addObject(table : Table) throws -> ObjectOffset {
        
        let mirror = Mirror(reflecting: table)
        
        var index = 0
        try openObject(Int(mirror.children.count))
        for child in mirror.children {
            switch child.value {
            case let v as Bool : try addPropertyToOpenObject(index, value: v, defaultValue: false)
            case let v as Int16 : try addPropertyToOpenObject(index, value: v, defaultValue: 0)
            case let v as UInt16 : try addPropertyToOpenObject(index, value: v, defaultValue: 0)
            case let v as Int32 : try addPropertyToOpenObject(index, value: v, defaultValue: 0)
            case let v as UInt32 : try addPropertyToOpenObject(index, value: v, defaultValue: 0)
            case let v as Int64 : try addPropertyToOpenObject(index, value: v, defaultValue: 0)
            case let v as UInt64 : try addPropertyToOpenObject(index, value: v, defaultValue: 0)
            case let v as Int : try addPropertyToOpenObject(index, value: v, defaultValue: 0)
            case let v as UInt : try addPropertyToOpenObject(index, value: v, defaultValue: 0)
            case let v as Float32 : try addPropertyToOpenObject(index, value: v, defaultValue: 0)
            case let v as Float64 : try addPropertyToOpenObject(index, value: v, defaultValue: 0)
            case let v as Offset : try addPropertyOffsetToOpenObject(index, offset: v)
            default : throw FlatBufferBuilderError.UnsupportedType
            }
            index++
        }
        return try closeObject()
    }
}

extension Table {
    
    func get<S: Scalar>(reader : FlatBufferReader, var myOffset : ObjectOffset? = nil,  propertyName : String) -> S? {
        
        if myOffset == nil {
            myOffset = reader.rootObjectOffset
        }
        
        let index = findIndex(propertyName)
        if(index == -1) {
            return nil
        }
        
        if(S.self == Bool.self){
            let _value : Bool = reader.get(myOffset!, propertyIndex: index, defaultValue: false)
            return _value as? S
        } else if(S.self == Int8.self){
            let _value : Int8 = reader.get(myOffset!, propertyIndex: index, defaultValue: 0)
            return _value as? S
        } else if(S.self == UInt8.self){
            let _value : UInt8 = reader.get(myOffset!, propertyIndex: index, defaultValue: 0)
            return _value as? S
        } else if(S.self == Int16.self){
            let _value : Int16 = reader.get(myOffset!, propertyIndex: index, defaultValue: 0)
            return _value as? S
        } else if(S.self == UInt16.self){
            let _value : UInt16 = reader.get(myOffset!, propertyIndex: index, defaultValue: 0)
            return _value as? S
        } else if(S.self == Int32.self){
            let _value : Int32 = reader.get(myOffset!, propertyIndex: index, defaultValue: 0)
            return _value as? S
        } else if(S.self == UInt32.self){
            let _value : UInt32 = reader.get(myOffset!, propertyIndex: index, defaultValue: 0)
            return _value as? S
        } else if(S.self == Int64.self){
            let _value : Int64 = reader.get(myOffset!, propertyIndex: index, defaultValue: 0)
            return _value as? S
        } else if(S.self == UInt64.self){
            let _value : UInt64 = reader.get(myOffset!, propertyIndex: index, defaultValue: 0)
            return _value as? S
        } else if(S.self == Int.self){
            let _value : Int = reader.get(myOffset!, propertyIndex: index, defaultValue: 0)
            return _value as? S
        } else if(S.self == UInt.self){
            let _value : UInt = reader.get(myOffset!, propertyIndex: index, defaultValue: 0)
            return _value as? S
        } else if(S.self == Float32.self){
            let _value : Float32 = reader.get(myOffset!, propertyIndex: index, defaultValue: 0)
            return _value as? S
        } else if(S.self == Float64.self){
            let _value : Float64 = reader.get(myOffset!, propertyIndex: index, defaultValue: 0)
            return _value as? S
        }
        
        return nil
    }
    
    func findIndex(propertyName : String) -> Int {
        let mirror = Mirror(reflecting: self)
        var index = 0
        for child in mirror.children {
            if child.label == propertyName {
                return index
            }
            index++
        }
        return -1
    }
}