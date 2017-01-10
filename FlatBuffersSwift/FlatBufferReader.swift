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

    func getScalar<T : Scalar>(at offset: Int) throws -> T
    func bytes(at offset : Int, length : Int) throws -> UnsafeBufferPointer<UInt8>
    func isEqual(other : FBReader) -> Bool
}


fileprivate enum FBReaderError : Error {
    case outOfBufferBounds
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
    
    public func getVectorLength(vectorOffset : Offset?) -> Int {
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
            let localOffset : Int32 = try getScalar(at: valueStartPosition)
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
            return try getScalar(at: valueStartPosition) as T
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
            return try getScalar(at: position)
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
            return try getScalar(at: position) as T
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
            let stringLength : Int32 = try getScalar(at: stringPosition)
            let stringCharactersPosition = stringPosition + MemoryLayout<Int32>.stride
            
            return try bytes(at: stringCharactersPosition, length: Int(stringLength))
        } catch {
            return nil
        }
    }
    
    public var rootObjectOffset : Offset? {
        do {
            return try getScalar(at: 0) as Offset
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
