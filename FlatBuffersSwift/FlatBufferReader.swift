//
//  FlatBufferReader.swift
//  SwiftFlatBuffers
//
//  Created by Maxim Zaks on 21.11.15.
//  Copyright © 2015 maxim.zaks. All rights reserved.
//
import Foundation

public class FlatBufferReader {

    let buffer : UnsafePointer<UInt8>
    
    func fromByteArray<T : Scalar>(position : Int) -> T{
        return UnsafePointer<T>(buffer.advancedBy(position)).memory
    }

    public init(buffer : [UInt8]){
        self.buffer = UnsafePointer<UInt8>(buffer)
    }
    
    public init(bytes : UnsafePointer<UInt8>){
        self.buffer = bytes
    }
    
    public var rootObjectOffset : ObjectOffset {
        let offset : Int32 = fromByteArray(0)
        return ObjectOffset(offset)
    }
    
    public func get<T : Scalar>(objectOffset : ObjectOffset, propertyIndex : Int, defaultValue : T) -> T{
        let propertyOffset = getPropertyOffset(objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return defaultValue
        }
        let position = Int(objectOffset.value) + Int(propertyOffset)
        return fromByteArray(position)
    }
    
    public func getStructProperty<T : Scalar>(objectOffset : ObjectOffset, propertyIndex : Int, structPropertyOffset : Int, defaultValue : T) -> T {
        let propertyOffset = getPropertyOffset(objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return defaultValue
        }
        let position = Int(objectOffset.value) + Int(propertyOffset) + structPropertyOffset
        
        return fromByteArray(position)
    }
    
    public func hasProperty(objectOffset : ObjectOffset, propertyIndex : Int) -> Bool {
        return getPropertyOffset(objectOffset, propertyIndex: propertyIndex) != 0
    }
    
    public func getOffset<T : Offset>(objectOffset : ObjectOffset, propertyIndex : Int) -> T?{
        let propertyOffset = getPropertyOffset(objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return nil
        }
        let position = Int(objectOffset.value) + Int(propertyOffset)
        let localObjectOffset : Int32 = fromByteArray(position)
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
        let stringLenght : Int32 = fromByteArray(stringPosition)
        let pointer = UnsafeMutablePointer<UInt8>(buffer).advancedBy((stringPosition + strideof(Int32)))
        return String.init(bytesNoCopy: pointer, length: Int(stringLenght), encoding: NSUTF8StringEncoding, freeWhenDone: false)
    }
    
    public func getVectorLength(vectorOffset : VectorOffset?) -> Int {
        guard let vectorOffset = vectorOffset else {
            return 0
        }
        let vectorPosition = Int(vectorOffset.value)
        let length2 : Int32 = fromByteArray(vectorPosition)
        return Int(length2)
    }
    
    public func getVectorScalarElement<T : Scalar>(vectorOffset : VectorOffset, index : Int) -> T {
        let valueStartPosition = Int(vectorOffset.value + strideof(Int32) + (index * strideof(T)))
        return UnsafePointer<T>(UnsafePointer<UInt8>(buffer).advancedBy(valueStartPosition)).memory
    }
    
    public func getVectorStructElement<T : Scalar>(vectorOffset : VectorOffset, vectorIndex : Int, structSize : Int, structElementIndex : Int) -> T {
        let valueStartPosition = Int(vectorOffset.value + strideof(Int32) + (vectorIndex * structSize) + structElementIndex)
        return UnsafePointer<T>(UnsafePointer<UInt8>(buffer).advancedBy(valueStartPosition)).memory
    }
    
    public func getVectorOffsetElement<T : Offset>(vectorOffset : VectorOffset, index : Int) -> T? {
        let valueStartPosition = Int(vectorOffset.value + strideof(Int32) + (index * strideof(Int32)))
        let localOffset : Int32 = fromByteArray(valueStartPosition)
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
        let offset = Int(objectOffset.value)
        let localOffset : Int32 = fromByteArray(offset)
        let vTableOffset : Int = offset - Int(localOffset)
        let vTableLength : Int16 = fromByteArray(vTableOffset)
        if(vTableLength<=Int16(4 + propertyIndex * 2)) {
            return 0
        }
        let propertyStart = vTableOffset + 4 + (2 * propertyIndex)
        
        let propertyOffset : Int16 = fromByteArray(propertyStart)
        return Int(propertyOffset)
    }
}
