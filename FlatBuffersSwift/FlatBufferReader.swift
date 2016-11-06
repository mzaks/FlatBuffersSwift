//
//  Reader.swift
//  FBSwift3
//
//  Created by Maxim Zaks on 28.10.16.
//  Copyright © 2016 Maxim Zaks. All rights reserved.
//

import Foundation

public protocol FBReader {
    func fromByteArray<T : Scalar>(position : Int) throws -> T
    func buffer(position : Int, length : Int) throws -> UnsafeBufferPointer<UInt8>
    var cache : FBReaderCache? {get}
    func isEqual(other : FBReader) -> Bool
}


fileprivate enum FBReaderError : Error {
    case OutOfBufferBounds
    case CanNotSetProperty
}

public class FBReaderCache {
    public var objectPool : [Offset : AnyObject] = [:]
    func reset(){
        objectPool.removeAll(keepingCapacity: true)
    }
    public init(){}
}

public extension FBReader {
    
    private func getPropertyOffset(objectOffset : Offset, propertyIndex : Int) -> Int {
        guard propertyIndex >= 0 else {
            return 0
        }
        do {
            let offset = Int(objectOffset)
            let localOffset : Int32 = try fromByteArray(position: offset)
            let vTableOffset : Int = offset - Int(localOffset)
            let vTableLength : Int16 = try fromByteArray(position: vTableOffset)
            let objectLength : Int16 = try fromByteArray(position: vTableOffset + 2)
            let positionInVTable = 4 + propertyIndex * 2
            if(vTableLength<=Int16(positionInVTable)) {
                return 0
            }
            let propertyStart = vTableOffset + positionInVTable
            let propertyOffset : Int16 = try fromByteArray(position: propertyStart)
            if(objectLength<=propertyOffset) {
                return 0
            }
            return Int(propertyOffset)
        } catch {
            return 0 // Currently don't want to propagate the error
        }
    }
    
    public func getOffset(objectOffset : Offset, propertyIndex : Int) -> Offset? {
        
        let propertyOffset = getPropertyOffset(objectOffset: objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return nil
        }
        
        let position = objectOffset + propertyOffset
        do {
            let localObjectOffset : Int32 = try fromByteArray(position: Int(position))
            let offset = position + localObjectOffset
            
            if localObjectOffset == 0 {
                return nil
            }
            return offset
        } catch {
            return nil
        }
        
    }
    
    public func getVectorLength(vectorOffset : Offset?) -> Int {
        guard let vectorOffset = vectorOffset else {
            return 0
        }
        let vectorPosition = Int(vectorOffset)
        do {
            let length2 : Int32 = try fromByteArray(position: vectorPosition)
            return Int(length2)
        } catch {
            return 0
        }
    }
    
    public func getVectorOffsetElement(vectorOffset : Offset?, index : Int) -> Offset? {
        guard let vectorOffset = vectorOffset else {
            return nil
        }
        guard index >= 0 else{
            return nil
        }
        guard index < getVectorLength(vectorOffset: vectorOffset) else {
            return nil
        }
        let valueStartPosition = Int(vectorOffset + MemoryLayout<Int32>.stride + (index * MemoryLayout<Int32>.stride))
        do {
            let localOffset : Int32 = try fromByteArray(position: valueStartPosition)
            if(localOffset == 0){
                return nil
            }
            return localOffset + valueStartPosition
        } catch {
            return nil
        }
    }
    
    public func getVectorScalarElement<T : Scalar>(vectorOffset : Offset?, index : Int) -> T? {
        guard let vectorOffset = vectorOffset else {
            return nil
        }
        guard index >= 0 else{
            return nil
        }
        guard index < getVectorLength(vectorOffset: vectorOffset) else {
            return nil
        }
        
        let valueStartPosition = Int(vectorOffset + MemoryLayout<Int32>.stride + (index * MemoryLayout<T>.stride))
        
        do {
            return try fromByteArray(position: valueStartPosition) as T
        } catch {
            return nil
        }
    }
    
    public func get<T : Scalar>(objectOffset : Offset, propertyIndex : Int, defaultValue : T) -> T {
        let propertyOffset = getPropertyOffset(objectOffset: objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return defaultValue
        }
        let position = Int(objectOffset + propertyOffset)
        do {
            return try fromByteArray(position: position)
        } catch {
            return defaultValue
        }
    }
    
    public func get<T : Scalar>(objectOffset : Offset, propertyIndex : Int) -> T? {
        let propertyOffset = getPropertyOffset(objectOffset: objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return nil
        }
        let position = Int(objectOffset + propertyOffset)
        do {
            return try fromByteArray(position: position) as T
        } catch {
            return nil
        }
    }
    
    public func getStringBuffer(stringOffset : Offset?) -> UnsafeBufferPointer<UInt8>? {
        guard let stringOffset = stringOffset else {
            return nil
        }
        let stringPosition = Int(stringOffset)
        do {
            let stringLength : Int32 = try fromByteArray(position: stringPosition)
            let stringCharactersPosition = stringPosition + MemoryLayout<Int32>.stride
            
            return try buffer(position: stringCharactersPosition, length: Int(stringLength))
        } catch {
            return nil
        }
    }
    
    public var rootObjectOffset : Offset? {
        do {
            return try fromByteArray(position: 0) as Offset
        } catch {
            return nil
        }
    }
}

public struct FBMemoryReader : FBReader {
    
    private let count : Int
    public let cache : FBReaderCache?
    private let buffer : UnsafeRawPointer
    
    public init(buffer : UnsafeRawPointer, count : Int, cache : FBReaderCache? = FBReaderCache()) {
        self.buffer = buffer
        self.count = count
        self.cache = cache
    }
    
    public init(data : Data, cache : FBReaderCache? = FBReaderCache()) {
        self.count = data.count
        self.cache = cache
        var pointer : UnsafePointer<UInt8>! = nil
        data.withUnsafeBytes { (u8Ptr: UnsafePointer<UInt8>) in
            pointer = u8Ptr
        }
        self.buffer = UnsafeRawPointer(pointer)
    }
    
    public func fromByteArray<T : Scalar>(position : Int) throws -> T {
        if position + MemoryLayout<T>.stride > count || position < 0 {
            throw FBReaderError.OutOfBufferBounds
        }
        
        return buffer.load(fromByteOffset: position, as: T.self)
    }
    
    public func buffer(position : Int, length : Int) throws -> UnsafeBufferPointer<UInt8> {
        if Int(position + length) > count {
            throw FBReaderError.OutOfBufferBounds
        }
        let pointer = buffer.advanced(by:position).bindMemory(to: UInt8.self, capacity: length)
        return UnsafeBufferPointer<UInt8>.init(start: pointer, count: Int(length))
    }
    
    public func isEqual(other: FBReader) -> Bool{
        guard let other = other as? FBMemoryReader else {
            return false
        }
        return self.buffer == other.buffer
    }
}

public struct FBFileReader : FBReader {
    
    private let fileSize : UInt64
    private let fileHandle : FileHandle
    public let cache : FBReaderCache?
    
    public init(fileHandle : FileHandle, cache : FBReaderCache? = FBReaderCache()){
        self.fileHandle = fileHandle
        fileSize = fileHandle.seekToEndOfFile()
        
        self.cache = cache
    }
    
    public func fromByteArray<T : Scalar>(position : Int) throws -> T {
        let seekPosition = UInt64(position)
        if seekPosition + UInt64(MemoryLayout<T>.stride) > fileSize {
            throw FBReaderError.OutOfBufferBounds
        }
        fileHandle.seek(toFileOffset: seekPosition)
        let data = fileHandle.readData(ofLength:MemoryLayout<T>.stride)
        let pointer = UnsafeMutablePointer<T>.allocate(capacity: MemoryLayout<T>.stride)
        let t : UnsafeMutableBufferPointer<T> = UnsafeMutableBufferPointer(start: pointer, count: 1)
        _ = data.copyBytes(to: t)
        if let result = t.baseAddress?.pointee {
            pointer.deinitialize()
            return result
        }
        throw FBReaderError.OutOfBufferBounds
    }
    
    public func buffer(position : Int, length : Int) throws -> UnsafeBufferPointer<UInt8> {
        if UInt64(position + length) > fileSize {
            throw FBReaderError.OutOfBufferBounds
        }
        fileHandle.seek(toFileOffset: UInt64(position))
        let data = fileHandle.readData(ofLength:Int(length))
        let pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: 1)
        let t : UnsafeMutableBufferPointer<UInt8> = UnsafeMutableBufferPointer(start: pointer, count: length)
        _ = data.copyBytes(to: t)
        pointer.deinitialize()
        return UnsafeBufferPointer<UInt8>(start: t.baseAddress, count: length)
    }
    
    public func isEqual(other: FBReader) -> Bool{
        guard let other = other as? FBFileReader else {
            return false
        }
        return self.fileHandle === other.fileHandle
    }
}

postfix operator §

public postfix func §(value: UnsafeBufferPointer<UInt8>) -> String? {
    return String.init(bytesNoCopy: UnsafeMutablePointer<UInt8>(mutating: value.baseAddress!), length: value.count, encoding: String.Encoding.utf8, freeWhenDone: false)
}
