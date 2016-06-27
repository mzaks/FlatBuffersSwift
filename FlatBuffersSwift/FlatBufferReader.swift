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

    public static var maxInstanceCacheSize : UInt = 0 // max number of cached instances
    static var instancePool : [FlatBufferReader] = []
    
    public var config : BinaryReadConfig
    
    var buffer : UnsafeMutablePointer<UInt8> = nil
    public var objectPool : [Offset : AnyObject] = [:]
    
    func fromByteArray<T : Scalar>(position : Int) -> T{
        return UnsafePointer<T>(buffer.advancedBy(position)).memory
    }
    
    private var length : Int
    public var data : [UInt8] {
        return Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(buffer), count: length))
    }

    public init(buffer : [UInt8], config: BinaryReadConfig){
        self.buffer = UnsafeMutablePointer<UInt8>(buffer)
        self.config = config
        length = buffer.count
    }
    
    public init(bytes : UnsafeBufferPointer<UInt8>, config: BinaryReadConfig){
        self.buffer = UnsafeMutablePointer<UInt8>(bytes.baseAddress)
        self.config = config
        length = bytes.count
    }

    public init(bytes : UnsafeMutablePointer<UInt8>, count : Int, config: BinaryReadConfig){
        self.buffer = bytes
        self.config = config
        length = count
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
        length = 0
    }
    
    public static func create(buffer : [UInt8], config: BinaryReadConfig) -> FlatBufferReader {
        objc_sync_enter(instancePool)
        defer { objc_sync_exit(instancePool) }

        if (instancePool.count > 0)
        {
            let reader = instancePool.removeLast()
            
            reader.buffer = UnsafeMutablePointer<UInt8>(buffer)
            reader.config = config
            reader.length = buffer.count
            
            return reader
        }
        
        return FlatBufferReader(buffer: buffer, config: config)
    }
    
    public static func create(bytes : UnsafeBufferPointer<UInt8>, config: BinaryReadConfig) -> FlatBufferReader {
        objc_sync_enter(instancePool)
        defer { objc_sync_exit(instancePool) }

        if (instancePool.count > 0)
        {
            let reader = instancePool.removeLast()
            
            reader.buffer = UnsafeMutablePointer(bytes.baseAddress)
            reader.config = config
            reader.length = bytes.count
            
            return reader
        }
        
        return FlatBufferReader(bytes: bytes, config: config)
    }
    
    public static func create(bytes : UnsafeMutablePointer<UInt8>, count : Int, config: BinaryReadConfig) -> FlatBufferReader {
        objc_sync_enter(instancePool)
        defer { objc_sync_exit(instancePool) }

        if (instancePool.count > 0)
        {
            let reader = instancePool.removeLast()
            
            reader.buffer = bytes
            reader.config = config
            reader.length = count
            
            return reader
        }
        
        return FlatBufferReader(bytes: bytes, count: count, config: config)
    }

    public static func reuse(reader : FlatBufferReader) {
        objc_sync_enter(instancePool)
        defer { objc_sync_exit(instancePool) }

        if (UInt(instancePool.count) < maxInstanceCacheSize)
        {
            reader.reset()
            instancePool.append(reader)
        }
    }
}


// MARK: Fast Reader

public final class FlatBufferReaderFast {

    public static func fromByteArray<T : Scalar>(buffer : UnsafePointer<UInt8>, _ position : Int) -> T{
        return UnsafePointer<T>(buffer.advancedBy(position)).memory
    }

    public static func getPropertyOffset(buffer : UnsafePointer<UInt8>, _ objectOffset : Offset, propertyIndex : Int)->Int {
        let offset = Int(objectOffset)
        let localOffset : Int32 = fromByteArray(buffer, offset)
        let vTableOffset : Int = offset - Int(localOffset)
        let vTableLength : Int16 = fromByteArray(buffer, vTableOffset)
        if(vTableLength<=Int16(4 + propertyIndex * 2)) {
            return 0
        }
        let propertyStart = vTableOffset + 4 + (2 * propertyIndex)

        let propertyOffset : Int16 = fromByteArray(buffer, propertyStart)
        return Int(propertyOffset)
    }

    public static func getOffset(buffer : UnsafePointer<UInt8>, _ objectOffset : Offset, propertyIndex : Int) -> Offset?{
        let propertyOffset = getPropertyOffset(buffer, objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return nil
        }
        let position = objectOffset + propertyOffset
        let localObjectOffset : Int32 = fromByteArray(buffer, Int(position))
        let offset = position + localObjectOffset

        if localObjectOffset == 0 {
            return nil
        }
        return offset
    }

    public static func getVectorLength(buffer : UnsafePointer<UInt8>, _ vectorOffset : Offset?) -> Int {
        guard let vectorOffset = vectorOffset else {
            return 0
        }
        let vectorPosition = Int(vectorOffset)
        let length2 : Int32 = fromByteArray(buffer, vectorPosition)
        return Int(length2)
    }

    public static func getVectorOffsetElement(buffer : UnsafePointer<UInt8>, _ vectorOffset : Offset, index : Int) -> Offset? {
        let valueStartPosition = Int(vectorOffset + strideof(Int32) + (index * strideof(Int32)))
        let localOffset : Int32 = fromByteArray(buffer, valueStartPosition)
        if(localOffset == 0){
            return nil
        }
        return localOffset + valueStartPosition
    }

    public static func getVectorScalarElement<T : Scalar>(buffer : UnsafePointer<UInt8>, _ vectorOffset : Offset, index : Int) -> T {
        let valueStartPosition = Int(vectorOffset + strideof(Int32) + (index * strideof(T)))
        return UnsafePointer<T>(UnsafePointer<UInt8>(buffer).advancedBy(valueStartPosition)).memory
    }

    public static func get<T : Scalar>(buffer : UnsafePointer<UInt8>, _ objectOffset : Offset, propertyIndex : Int, defaultValue : T) -> T{
        let propertyOffset = getPropertyOffset(buffer, objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return defaultValue
        }
        let position = Int(objectOffset + propertyOffset)
        return fromByteArray(buffer, position)
    }

    public static func get<T : Scalar>(buffer : UnsafePointer<UInt8>, _ objectOffset : Offset, propertyIndex : Int) -> T?{
        let propertyOffset = getPropertyOffset(buffer, objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return nil
        }
        let position = Int(objectOffset + propertyOffset)
        return fromByteArray(buffer, position) as T
    }

    public static func getStringBuffer(buffer : UnsafePointer<UInt8>, _ stringOffset : Offset?) -> UnsafeBufferPointer<UInt8>? {
        guard let stringOffset = stringOffset else {
            return nil
        }
        let stringPosition = Int(stringOffset)
        let stringLength : Int32 = fromByteArray(buffer, stringPosition)
        let pointer = UnsafePointer<UInt8>(buffer).advancedBy((stringPosition + strideof(Int32)))
        return UnsafeBufferPointer<UInt8>.init(start: pointer, count: Int(stringLength))
    }

    public static func getString(buffer : UnsafePointer<UInt8>, _ stringOffset : Offset?) -> String? {
        guard let stringOffset = stringOffset else {
            return nil
        }
        let stringPosition = Int(stringOffset)
        let stringLength : Int32 = fromByteArray(buffer, stringPosition)

        let pointer = UnsafeMutablePointer<UInt8>(buffer).advancedBy((stringPosition + strideof(Int32)))
        let result = String.init(bytesNoCopy: pointer, length: Int(stringLength), encoding: NSUTF8StringEncoding, freeWhenDone: false)

        return result
    }

    public static func set<T : Scalar>(buffer : UnsafeMutablePointer<UInt8>, _ objectOffset : Offset, propertyIndex : Int, value : T) throws {
        let propertyOffset = getPropertyOffset(buffer, objectOffset, propertyIndex: propertyIndex)
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

    public static func setVectorScalarElement<T : Scalar>(buffer : UnsafeMutablePointer<UInt8>, _ vectorOffset : Offset, index : Int, value : T) {
        let valueStartPosition = Int(vectorOffset + strideof(Int32) + (index * strideof(T)))
        var v = value
        let c = strideofValue(v)
        withUnsafePointer(&v){
            buffer.advancedBy(valueStartPosition).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
    }
}






public final class FlatBufferFileReader {
    
    public var config : BinaryReadConfig
    
    let fileHandle : NSFileHandle
    public var objectPool : [Offset : AnyObject] = [:]
    
    func fromByteArray<T : Scalar>(position : Int) -> T{
        fileHandle.seekToFileOffset(UInt64(position))
        return UnsafePointer<T>(fileHandle.readDataOfLength(strideof(T)).bytes).memory
    }
    
    public init(filePath : String, config: BinaryReadConfig){
        self.config = config
        fileHandle = NSFileHandle.init(forUpdatingAtPath: filePath)!
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
        
        fileHandle.seekToFileOffset(UInt64(stringPosition + strideof(Int32)))
        let pointer = UnsafeMutablePointer<UInt8>(fileHandle.readDataOfLength(Int(stringLength)).bytes)
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
        
        fileHandle.seekToFileOffset(UInt64(stringPosition + strideof(Int32)))
        let pointer = UnsafeMutablePointer<UInt8>(fileHandle.readDataOfLength(Int(stringLength)).bytes)
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
        fileHandle.seekToFileOffset(UInt64(valueStartPosition))
        
        return UnsafePointer<T>(fileHandle.readDataOfLength(strideof(T)).bytes).memory
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

