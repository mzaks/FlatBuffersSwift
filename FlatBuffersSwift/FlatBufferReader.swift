//
//  Reader.swift
//  FBSwift3
//
//  Created by Maxim Zaks on 28.10.16.
//  Copyright © 2016 Maxim Zaks. All rights reserved.
//

import Foundation

public protocol FBReader {
    var cache : FBReaderCache? {get}

    /**
     Access a scalar value directly from the underlying reader buffer.
     
     - parameters:
         - offset: The offset to read from in the buffer
     
     - Returns: a scalar value at a given offset from the buffer.
     */
    func getScalar<T : Scalar>(at offset: Int) throws -> T

    /**
     Access a subrange from the underlying reader buffer
     
     - parameters:
     - offset: The offset to read from in the buffer
     - length: The amount of data to include from the buffer
     
     - Returns: a direct pointer to a subrange from the underlying reader buffer.
     */
    func bytes(at offset : Int, length : Int) throws -> UnsafeBufferPointer<UInt8>
    func isEqual(other : FBReader) -> Bool
}


fileprivate enum FBReaderError : Error {
    case outOfBufferBounds     /// Trying to address outside of the bounds of the underlying buffer
    case canNotSetProperty
}

public class FBReaderCache {
    public var objectPool : [Offset : AnyObject] = [:]
    func reset(){
        objectPool.removeAll(keepingCapacity: true)
    }
    public init(){}
}

public extension FBReader {
    /**
     Retrieve the offset of a property from the vtable.
     
     - parameters:
         - objectOffset: The offset of the object
         - propertyIndex: The property to extract
     
     - Returns: the object-local offset of a given property by looking it up in the vtable
     */
    private func getPropertyOffset(objectOffset : Offset, propertyIndex : Int) -> Int {
        guard propertyIndex >= 0 else {
            return 0
        }
        do {
            let offset = Int(objectOffset)
            let localOffset : Int32 = try getScalar(at: offset)
            let vTableOffset : Int = offset - Int(localOffset)
            let vTableLength : Int16 = try getScalar(at: vTableOffset)
            let objectLength : Int16 = try getScalar(at: vTableOffset + 2)
            let positionInVTable = 4 + propertyIndex * 2
            if(vTableLength<=Int16(positionInVTable)) {
                return 0
            }
            let propertyStart = vTableOffset + positionInVTable
            let propertyOffset : Int16 = try getScalar(at: propertyStart)
            if(objectLength<=propertyOffset) {
                return 0
            }
            return Int(propertyOffset)
        } catch {
            return 0 // Currently don't want to propagate the error
        }
    }
    
    /// **Returns** the final offset in the reader buffer to access a given property for a given object-offset
    public func getOffset(objectOffset : Offset, propertyIndex : Int) -> Offset? {
        
        let propertyOffset = getPropertyOffset(objectOffset: objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return nil
        }
        
        let position = objectOffset + propertyOffset
        do {
            let localObjectOffset : Int32 = try getScalar(at: Int(position))
            let offset = position + localObjectOffset
            
            if localObjectOffset == 0 {
                return nil
            }
            return offset
        } catch {
            return nil
        }
        
    }
    
    /// **Returns** the length of vector
    public func getVectorElementCount(vectorOffset : Offset?) -> Int {
        guard let vectorOffset = vectorOffset else {
            return 0
        }
        let vectorPosition = Int(vectorOffset)
        do {
            let length2 : Int32 = try getScalar(at: vectorPosition)
            return Int(length2)
        } catch {
            return 0
        }
    }
    
    /// **Returns** the offset in the buffer for a given vector element
    public func getVectorElementOffset(vectorOffset : Offset?, index : Int) -> Offset? {
        guard let vectorOffset = vectorOffset else {
            return nil
        }
        guard index >= 0 else{
            return nil
        }
        guard index < getVectorElementCount(vectorOffset: vectorOffset) else {
            return nil
        }
        let valueStartPosition = Int(vectorOffset + MemoryLayout<Int32>.stride + (index * MemoryLayout<Int32>.stride))
        do {
            let localOffset : Int32 = try getScalar(at: valueStartPosition)
            if(localOffset == 0){
                return nil
            }
            return localOffset + valueStartPosition
        } catch {
            return nil
        }
    }
    
    /// **Returns** a scalar value directly from a vector for a given index
    public func getVectorScalarElement<T : Scalar>(vectorOffset : Offset?, index : Int) -> T? {
        guard let vectorOffset = vectorOffset else {
            return nil
        }
        guard index >= 0 else{
            return nil
        }
        guard index < getVectorElementCount(vectorOffset: vectorOffset) else {
            return nil
        }
        
        let valueStartPosition = Int(vectorOffset + MemoryLayout<Int32>.stride + (index * MemoryLayout<T>.stride))
        
        do {
            return try getScalar(at: valueStartPosition) as T
        } catch {
            return nil
        }
    }

    /// **Returns** a scalar value directly from a vector for a given index
    public func get<T : Scalar>(objectOffset : Offset, propertyIndex : Int, defaultValue : T) -> T {
        let propertyOffset = getPropertyOffset(objectOffset: objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return defaultValue
        }
        let position = Int(objectOffset + propertyOffset)
        do {
            return try getScalar(at: position)
        } catch {
            return defaultValue
        }
    }
    
    /// **Returns** a scalar value for a given property from an object
    public func get<T : Scalar>(objectOffset : Offset, propertyIndex : Int) -> T? {
        let propertyOffset = getPropertyOffset(objectOffset: objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return nil
        }
        let position = Int(objectOffset + propertyOffset)
        do {
            return try getScalar(at: position) as T
        } catch {
            return nil
        }
    }
    
    /// **Returns** a buffer pointer to the subrange of the reader buffer occupied by a string
    public func getStringBuffer(stringOffset : Offset?) -> UnsafeBufferPointer<UInt8>? {
        guard let stringOffset = stringOffset else {
            return nil
        }
        let stringPosition = Int(stringOffset)
        do {
            let stringLength : Int32 = try getScalar(at: stringPosition)
            let stringCharactersPosition = stringPosition + MemoryLayout<Int32>.stride
            
            return try bytes(at: stringCharactersPosition, length: Int(stringLength))
        } catch {
            return nil
        }
    }
    
    /// **Returns** the offset for the root table object
    public var rootObjectOffset : Offset? {
        do {
            return try getScalar(at: 0) as Offset
        } catch {
            return nil
        }
    }
}

/// A FlatBuffers reader subclass that by default reads directly from a memory buffer, but also supports initialization from Data objects for convenience
public struct FBMemoryReader : FBReader {
    
    private let count : Int
    public let cache : FBReaderCache?
    private let buffer : UnsafeRawPointer
    
    /**
     Initializes the reader directly from a raw memory buffer.
     
     - parameters:
         - buffer: A raw pointer to the underlying data to be parsed
         - count: The size of the data buffer
         - cache: An optional cache of reader objects for reuse
     
     - Returns: A FB reader ready for use.
     */
    public init(buffer : UnsafeRawPointer, count : Int, cache : FBReaderCache? = FBReaderCache()) {
        self.buffer = buffer
        self.count = count
        self.cache = cache
    }
    
    /**
     Initializes the reader from a Data object.
     This method will probably keep a copy after https://github.com/mzaks/FlatBuffersSwift/issues/73 is resolved
     - parameters:
         - data: A Data object holding the data to be parsed, the contents may be copied, for performance sensitive implementations, 
                 the UnsafeRawsPointer initializer should be used.
         - cache: An optional cache of reader objects for reuse
     
     - Returns: A FB reader ready for use.
     */
    public init(data : Data, cache : FBReaderCache? = FBReaderCache()) {
        self.count = data.count
        self.cache = cache
        var pointer : UnsafePointer<UInt8>! = nil
        data.withUnsafeBytes { (u8Ptr: UnsafePointer<UInt8>) in
            pointer = u8Ptr
        }
        self.buffer = UnsafeRawPointer(pointer)
    }
    
    public func getScalar<T : Scalar>(at offset: Int) throws -> T {
        if offset + MemoryLayout<T>.stride > count || offset < 0 {
            throw FBReaderError.outOfBufferBounds
        }
        
        return buffer.load(fromByteOffset: offset, as: T.self)
    }
    
    public func bytes(at offset : Int, length : Int) throws -> UnsafeBufferPointer<UInt8> {
        if Int(offset + length) > count {
            throw FBReaderError.outOfBufferBounds
        }
        let pointer = buffer.advanced(by:offset).bindMemory(to: UInt8.self, capacity: length)
        return UnsafeBufferPointer<UInt8>.init(start: pointer, count: Int(length))
    }
    
    public func isEqual(other: FBReader) -> Bool{
        guard let other = other as? FBMemoryReader else {
            return false
        }
        return self.buffer == other.buffer
    }
}

/// A FlatBuffers reader subclass that reads directly from a file handle
public struct FBFileReader : FBReader {
    
    private let fileSize : UInt64
    private let fileHandle : FileHandle
    public let cache : FBReaderCache?
    
    public init(fileHandle : FileHandle, cache : FBReaderCache? = FBReaderCache()){
        self.fileHandle = fileHandle
        fileSize = fileHandle.seekToEndOfFile()
        
        self.cache = cache
    }
    
    public func getScalar<T : Scalar>(at offset: Int) throws -> T {
        let seekPosition = UInt64(offset)
        if seekPosition + UInt64(MemoryLayout<T>.stride) > fileSize {
            throw FBReaderError.outOfBufferBounds
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
        throw FBReaderError.outOfBufferBounds
    }
    
    public func bytes(at offset : Int, length : Int) throws -> UnsafeBufferPointer<UInt8> {
        if UInt64(offset + length) > fileSize {
            throw FBReaderError.outOfBufferBounds
        }
        fileHandle.seek(toFileOffset: UInt64(offset))
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
