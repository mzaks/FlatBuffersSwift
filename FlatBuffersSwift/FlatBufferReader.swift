//
//  FlatBufferReader.swift
//  SwiftFlatBuffers
//
//  Created by Maxim Zaks on 21.11.15.
//  Copyright © 2015 maxim.zaks. All rights reserved.
//
import Foundation

func fromByteArray<T : Scalar>(value: ArraySlice<UInt8>) -> T {
    return value.withUnsafeBufferPointer {
        return UnsafePointer<T>($0.baseAddress).memory
    }
}

public class FlatBufferReader {

    let buffer : [UInt8]
    
    public init(buffer : [UInt8]){
        self.buffer = buffer
    }
    
    public var rootObjectOffset : ObjectOffset {
        let offset : Int32 = fromByteArray(buffer[0..<strideof(Int32)])
        return ObjectOffset(offset)
    }
    
    public func get<T : Scalar>(objectOffset : ObjectOffset, propertyIndex : Int, defaultValue : T) -> T{
        let propertyOffset = getPropertyOffset(objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return defaultValue
        }
        let position = Int(objectOffset.value) + Int(propertyOffset)
        return fromByteArray(buffer[position..<(position + strideof(T))])
    }
    
    public func getStructProperty<T : Scalar>(objectOffset : ObjectOffset, propertyIndex : Int, structPropertyOffset : Int, defaultValue : T) -> T {
        let propertyOffset = getPropertyOffset(objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return defaultValue
        }
        let position = Int(objectOffset.value) + Int(propertyOffset) + structPropertyOffset
        
        return fromByteArray(buffer[position..<(position + strideof(T))])
    }
    
    public func getOffset<T : Offset>(objectOffset : ObjectOffset, propertyIndex : Int) -> T?{
        let propertyOffset = getPropertyOffset(objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return nil
        }
        let position = Int(objectOffset.value) + Int(propertyOffset)
        let localObjectOffset : Int32 = fromByteArray(buffer[position..<(position + strideof(Int32))])
        let offset = position+Int(localObjectOffset)
        
        if(T.self == ObjectOffset.self){
            return ObjectOffset(offset) as? T
        } else if(T.self == VectorOffset.self){
            return VectorOffset(offset) as? T
        } else {
            return StringOffset(offset) as? T
        }
    }
    
    public func getString(stringOffset : StringOffset?) -> String? {
        guard let stringOffset = stringOffset else {
            return nil
        }
        let stringPosition = Int(stringOffset.value)
        let stringLenght : Int32 = fromByteArray(buffer[stringPosition..<(stringPosition + strideof(Int32))])
        let stringData = buffer[(stringPosition + strideof(Int32))..<(stringPosition + strideof(Int32) + Int(stringLenght))]
        return String.init(bytes: stringData, encoding: NSUTF8StringEncoding)
    }
    
    public func getVectorLength(vectorOffset : VectorOffset?) -> Int {
        guard let vectorOffset = vectorOffset else {
            return 0
        }
        let vectorPosition = Int(vectorOffset.value)
        let length : Int32 = fromByteArray(buffer[vectorPosition..<(vectorPosition + strideof(Int32))])
        return Int(length)
    }
    
    public func getVectorScalarElement<T : Scalar>(vectorOffset : VectorOffset, index : Int) -> T {
        let valueStartPosition = Int(vectorOffset.value + strideof(Int32) + (index * strideof(T)))
        let data = buffer[valueStartPosition..<(valueStartPosition + strideof(T))]
        return fromByteArray(data)
    }
    
    public func getVectorOffsetElement<T : Offset>(vectorOffset : VectorOffset, index : Int) -> T? {
        let valueStartPosition = Int(vectorOffset.value + strideof(Int32) + (index * strideof(Int32)))
        let data = buffer[valueStartPosition..<(valueStartPosition + strideof(Int32))]
        let localOffset : Int32 = fromByteArray(data)
        if(localOffset == 0){
            return nil
        }
        let offset : Int32 = localOffset + valueStartPosition
        if(T.self == ObjectOffset.self){
            return ObjectOffset(offset) as? T
        } else if(T.self == VectorOffset.self) {
            return VectorOffset(offset) as? T
        } else {
            return StringOffset(offset) as? T
        }
    }
    
    private func getPropertyOffset(objectOffset : ObjectOffset, propertyIndex : Int)->Int {
        let vTableOffset : Int32 = objectOffset.value - fromByteArray( buffer[Int(objectOffset.value)..<Int(objectOffset.value+4)])
        let vTableLength : Int16 = fromByteArray( buffer[Int(vTableOffset)..<Int(vTableOffset+2)])
        if(vTableLength<=Int16(4 + propertyIndex * 2)) {
            return 0
        }
        let propertyStart = vTableOffset + 4 + (2 * propertyIndex)
        
        let propertyOffset : Int16 = fromByteArray( buffer[Int(propertyStart)..<Int(propertyStart+2)])
        return Int(propertyOffset)
    }
}
