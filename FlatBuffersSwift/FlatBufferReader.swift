//
//  FlatBufferReader.swift
//  SwiftFlatBuffers
//
//  Created by Maxim Zaks on 21.11.15.
//  Copyright © 2015 maxim.zaks. All rights reserved.
//
import Foundation

public enum FlatBufferReaderError : ErrorType {
    case CanOnlySetNonDefaultProperty
}

public final class FlatBufferReader {

    public static var maxInstanceCacheSize : UInt = 1000 // max number of cached instances
    static var instancePool : [FlatBufferReader] = []
    
    public var config : BinaryReadConfig
    
    var buffer : UnsafeMutablePointer<UInt8> = nil
    public var objectPool : [Offset : AnyObject] = [:]
    
    func fromByteArray<T : Scalar>(position : Int) -> T{
        return UnsafePointer<T>(buffer.advancedBy(position)).memory
    }

    public init(buffer : [UInt8], config: BinaryReadConfig){
        self.buffer = UnsafeMutablePointer<UInt8>(buffer)
        self.config = config
    }
    
    public init(bytes : UnsafePointer<UInt8>, config: BinaryReadConfig){
        self.buffer = UnsafeMutablePointer(bytes)
        self.config = config
    }
    
    public var rootObjectOffset : Offset {
        let offset : Int32 = fromByteArray(0)
        return offset
    }
    
    public func get<T : Scalar>(objectOffset : Offset, propertyIndex : Int, defaultValue : T) -> T{
        let propertyOffset = getPropertyOffset(objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return defaultValue
        }
        let position = Int(objectOffset + propertyOffset)
        return fromByteArray(position)
    }
    
    public func get<T : Scalar>(objectOffset : Offset, propertyIndex : Int) -> T?{
        let propertyOffset = getPropertyOffset(objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return nil
        }
        let position = Int(objectOffset + propertyOffset)
        return fromByteArray(position) as T
    }
    
    public func set<T : Scalar>(objectOffset : Offset, propertyIndex : Int, value : T) throws {
        let propertyOffset = getPropertyOffset(objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            throw FlatBufferReaderError.CanOnlySetNonDefaultProperty
        }
        var v = value
        let position = Int(objectOffset + propertyOffset)
        let c = strideofValue(v)
        withUnsafePointer(&v){
            buffer.advancedBy(position).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
    }
    
    public func hasProperty(objectOffset : Offset, propertyIndex : Int) -> Bool {
        return getPropertyOffset(objectOffset, propertyIndex: propertyIndex) != 0
    }
    
    public func getOffset(objectOffset : Offset, propertyIndex : Int) -> Offset?{
        let propertyOffset = getPropertyOffset(objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return nil
        }
        let position = objectOffset + propertyOffset
        let localObjectOffset : Int32 = fromByteArray(Int(position))
        let offset = position + localObjectOffset
        
        if localObjectOffset == 0 {
            return nil
        }
        return offset
    }
    
    var stringCache : [Int32:String] = [:]
    
    public func getString(stringOffset : Offset?) -> String? {
        guard let stringOffset = stringOffset else {
            return nil
        }
        if config.uniqueStrings {
            if let result = stringCache[stringOffset]{
                return result
            }
        }
        
        let stringPosition = Int(stringOffset)
        let stringLength : Int32 = fromByteArray(stringPosition)
        
        let pointer = UnsafeMutablePointer<UInt8>(buffer).advancedBy((stringPosition + strideof(Int32)))
        let result = String.init(bytesNoCopy: pointer, length: Int(stringLength), encoding: NSUTF8StringEncoding, freeWhenDone: false)
        
        if config.uniqueStrings {
            stringCache[stringOffset] = result
        }
        return result
    }
    
    public func getStringBuffer(stringOffset : Offset?) -> UnsafeBufferPointer<UInt8>? {
        guard let stringOffset = stringOffset else {
            return nil
        }
        let stringPosition = Int(stringOffset)
        let stringLength : Int32 = fromByteArray(stringPosition)
        let pointer = UnsafePointer<UInt8>(buffer).advancedBy((stringPosition + strideof(Int32)))
        return UnsafeBufferPointer<UInt8>.init(start: pointer, count: Int(stringLength))
    }
    
    public func getVectorLength(vectorOffset : Offset?) -> Int {
        guard let vectorOffset = vectorOffset else {
            return 0
        }
        let vectorPosition = Int(vectorOffset)
        let length2 : Int32 = fromByteArray(vectorPosition)
        return Int(length2)
    }
    
    public func getVectorScalarElement<T : Scalar>(vectorOffset : Offset, index : Int) -> T {
        let valueStartPosition = Int(vectorOffset + strideof(Int32) + (index * strideof(T)))
        return UnsafePointer<T>(UnsafePointer<UInt8>(buffer).advancedBy(valueStartPosition)).memory
    }
    
    public func setVectorScalarElement<T : Scalar>(vectorOffset : Offset, index : Int, value : T) {
        let valueStartPosition = Int(vectorOffset + strideof(Int32) + (index * strideof(T)))
        var v = value
        let c = strideofValue(v)
        withUnsafePointer(&v){
            buffer.advancedBy(valueStartPosition).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
    }
    
    public func getVectorOffsetElement(vectorOffset : Offset, index : Int) -> Offset? {
        let valueStartPosition = Int(vectorOffset + strideof(Int32) + (index * strideof(Int32)))
        let localOffset : Int32 = fromByteArray(valueStartPosition)
        if(localOffset == 0){
            return nil
        }
        return localOffset + valueStartPosition
    }
    
    private func getPropertyOffset(objectOffset : Offset, propertyIndex : Int)->Int {
        let offset = Int(objectOffset)
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

public extension FlatBufferReader {
    
    public func reset ()
    {
        buffer = nil
        objectPool.removeAll(keepCapacity: true)
        stringCache.removeAll(keepCapacity: true)
    }
    
    public static func create(buffer : [UInt8], config: BinaryReadConfig) -> FlatBufferReader {
        if (instancePool.count > 0)
        {
            let reader = instancePool.removeLast()
            
            reader.buffer = UnsafeMutablePointer<UInt8>(buffer)
            reader.config = config
            
            return reader
        }
        
        return FlatBufferReader(buffer: buffer, config: config)
    }
    
    public static func create(bytes : UnsafePointer<UInt8>, config: BinaryReadConfig) -> FlatBufferReader {
        if (instancePool.count > 0)
        {
            let reader = instancePool.removeLast()
            
            reader.buffer = UnsafeMutablePointer(bytes)
            reader.config = config
            
            return reader
        }
        
        return FlatBufferReader(bytes: bytes, config: config)
    }
    
    public static func reuse(reader : FlatBufferReader) {
        if (UInt(instancePool.count) < maxInstanceCacheSize)
        {
            reader.reset()
            instancePool.append(reader)
        }
    }
}
