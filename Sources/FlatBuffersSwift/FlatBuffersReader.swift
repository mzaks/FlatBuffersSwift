//
//  FlatBuffersReader.swift
//  FBSwift3
//
//  Created by Maxim Zaks on 28.10.16.
//  Copyright © 2016 Maxim Zaks. All rights reserved.
//
// See https://github.com/mzaks/FlatBuffersSwift/graphs/contributors for contributors.

import Foundation

public protocol FlatBuffersReader {
    var cache : FlatBuffersReaderCache? {get}

    /**
     Access a scalar value directly from the underlying reader buffer.

     - parameters:
     - offset: The offset to read from in the buffer

     - Returns: a scalar value at a given offset from the buffer.
     */
    func scalar<T : Scalar>(at offset: Int) throws -> T

    /**
     Access a subrange from the underlying reader buffer

     - parameters:
     - offset: The offset to read from in the buffer
     - length: The amount of data to include from the buffer

     - Returns: a direct pointer to a subrange from the underlying reader buffer.
     */
    func bytes(at offset : Int, length : Int) throws -> UnsafeBufferPointer<UInt8>
    func isEqual(other : FlatBuffersReader) -> Bool
}


fileprivate enum FlatBuffersReaderError : Error {
    case outOfBufferBounds     /// Trying to address outside of the bounds of the underlying buffer
    case canNotSetProperty
}

public class FlatBuffersReaderCache {
    public var objectPool : [Offset : AnyObject] = [:]
    func reset(){
        objectPool.removeAll(keepingCapacity: true)
    }
    public init(){}
}

public extension FlatBuffersReader {
    /**
     Retrieve the offset of a property from the vtable.

     - parameters:
     - objectOffset: The offset of the object
     - propertyIndex: The property to extract

     - Returns: the object-local offset of a given property by looking it up in the vtable
     */
    private func propertyOffset(objectOffset : Offset, propertyIndex : Int) -> Int {
        guard propertyIndex >= 0 else {
            return 0
        }
        do {
            let offset = Int(objectOffset)
            let localOffset : Int32 = try scalar(at: offset)
            let vTableOffset : Int = offset - Int(localOffset)
            let vTableLength : Int16 = try scalar(at: vTableOffset)
            let objectLength : Int16 = try scalar(at: vTableOffset + 2)
            let positionInVTable = 4 + propertyIndex * 2
            if (vTableLength<=Int16(positionInVTable)) {
                return 0
            }
            let propertyStart = vTableOffset + positionInVTable
            let propOffset : Int16 = try scalar(at: propertyStart)
            if (objectLength<=propOffset) {
                return 0
            }
            return Int(propOffset)
        } catch {
            return 0 // Currently don't want to propagate the error
        }
    }

    /**
     Retrieve the final offset of a property to be able to access it

     - parameters:
     - objectOffset: The offset of the object
     - propertyIndex: The property to extract

     - Returns: the final offset in the reader buffer to access a given property for a given object-offset
     */
    public func offset(objectOffset : Offset, propertyIndex : Int) -> Offset? {

        let propOffset = propertyOffset(objectOffset: objectOffset, propertyIndex: propertyIndex)
        if propOffset == 0 {
            return nil
        }

        let position = Int(objectOffset) + propOffset
        do {
            let localObjectOffset : Int32 = try scalar(at: position)
            let offset = Offset(position) + localObjectOffset

            if localObjectOffset == 0 {
                return nil
            }
            return offset
        } catch {
            return nil
        }

    }

    /**
     Retrieve the count of elements in an embedded vector

     - parameters:
     - vectorOffset: The offset of the vector in the buffer

     - Returns: the number of elements in the vector
     */
    public func vectorElementCount(vectorOffset : Offset?) -> Int {
        guard let vectorOffset = vectorOffset else {
            return 0
        }
        let vectorPosition = Int(vectorOffset)
        do {
            let length2 : Int32 = try scalar(at: vectorPosition)
            return Int(length2)
        } catch {
            return 0
        }
    }

    /**
     Retrieve an element offset from a vector

     - parameters:
     - vectorOffset: The offset of the vector in the buffer
     - index: The index of the element we want the offset for

     - Returns: the offset in the buffer for a given vector element
     */
    public func vectorElementOffset(vectorOffset : Offset?, index : Int) -> Offset? {
        guard let vectorOffset = vectorOffset else {
            return nil
        }
        guard index >= 0 else{
            return nil
        }
        guard index < vectorElementCount(vectorOffset: vectorOffset) else {
            return nil
        }
        let valueStartPosition = Int(vectorOffset) + MemoryLayout<Int32>.stride + (index * MemoryLayout<Int32>.stride)
        do {
            let localOffset : Int32 = try scalar(at: valueStartPosition)
            if(localOffset == 0){
                return nil
            }
            return localOffset + Offset(valueStartPosition)
        } catch {
            return nil
        }
    }

    /**
     Retrieve a scalar value from a vector

     - parameters:
     - vectorOffset: The offset of the vector in the buffer
     - index: The index of the element we want the offset for

     - Returns: a scalar value directly from a vector for a given index
     */
    public func vectorElementScalar<T : Scalar>(vectorOffset : Offset?, index : Int) -> T? {
        guard let vectorOffset = vectorOffset else {
            return nil
        }
        guard index >= 0 else{
            return nil
        }
        guard index < vectorElementCount(vectorOffset: vectorOffset) else {
            return nil
        }

        let valueStartPosition = Int(vectorOffset) + MemoryLayout<Int32>.stride + (index * MemoryLayout<T>.stride)

        do {
            return try scalar(at: valueStartPosition) as T
        } catch {
            return nil
        }
    }

    /**
     Retrieve a scalar value or supply a default if unavailable

     - parameters:
     - objectOffset: The offset of the object
     - propertyIndex: The property to try to extract
     - defaultValue: The default value to return if the property is not in the buffer

     - Returns: a scalar value directly from a vector for a given index
     */
    public func get<T : Scalar>(objectOffset : Offset, propertyIndex : Int, defaultValue : T) -> T {
        let propOffset = propertyOffset(objectOffset: objectOffset, propertyIndex: propertyIndex)
        if propOffset == 0 {
            return defaultValue
        }
        let position = Int(objectOffset) + propOffset
        do {
            return try scalar(at: position)
        } catch {
            return defaultValue
        }
    }

    /**
     Retrieve a scalar optional value (return nil if unavailable)

     - parameters:
     - objectOffset: The offset of the object
     - propertyIndex: The property to try to extract

     - Returns: a scalar value directly from a vector for a given index
     */
    public func get<T : Scalar>(objectOffset : Offset, propertyIndex : Int) -> T? {
        let propOffset = propertyOffset(objectOffset: objectOffset, propertyIndex: propertyIndex)
        if propOffset == 0 {
            return nil
        }
        let position = Int(objectOffset) + propOffset
        do {
            return try scalar(at: position) as T
        } catch {
            return nil
        }
    }

    /**
     Retrieve a stringbuffer

     - parameters:
     - stringOffset: The offset of the string

     - Returns:  a buffer pointer to the subrange of the reader buffer occupied by a string
     */
    public func stringBuffer(stringOffset : Offset?) -> UnsafeBufferPointer<UInt8>? {
        guard let stringOffset = stringOffset else {
            return nil
        }
        let stringPosition = Int(stringOffset)
        do {
            let stringLength : Int32 = try scalar(at: stringPosition)
            let stringCharactersPosition = stringPosition + MemoryLayout<Int32>.stride

            return try bytes(at: stringCharactersPosition, length: Int(stringLength))
        } catch {
            return nil
        }
    }

    /**
     Retrieve the root object offset

     - Returns:  the offset for the root table object
     */
    public var rootObjectOffset : Offset? {
        do {
            return try scalar(at: 0) as Offset
        } catch {
            return nil
        }
    }
}

/// A FlatBuffers reader subclass that by default reads directly from a memory buffer, but also supports initialization from Data objects for convenience
public final class FlatBuffersMemoryReader : FlatBuffersReader {

    private let count : Int
    public let cache : FlatBuffersReaderCache?
    private let buffer : UnsafeRawPointer
    private let originalBuffer : UnsafeMutableBufferPointer<UInt8>!

    /**
     Initializes the reader directly from a raw memory buffer.

     - parameters:
     - buffer: A raw pointer to the underlying data to be parsed
     - count: The size of the data buffer
     - cache: An optional cache of reader objects for reuse

     - Returns: A FlatBuffers reader ready for use.
     */
    public init(buffer : UnsafeRawPointer, count : Int, cache : FlatBuffersReaderCache? = FlatBuffersReaderCache()) {
        self.buffer = buffer
        self.count = count
        self.cache = cache
        self.originalBuffer = nil
    }

    /**
     Initializes the reader from a Data object.
     - parameters:
     - data: A Data object holding the data to be parsed, the contents may be copied, for performance sensitive implementations,
     the UnsafeRawsPointer initializer should be used.
     - withoutCopy: set it to true if you want to avoid copying the buffer. This implies that you have to keep a reference to data object around.
     - cache: An optional cache of reader objects for reuse

     - Returns: A FlatBuffers reader ready for use.
     */
    public init(data : Data, withoutCopy: Bool = false, cache : FlatBuffersReaderCache? = FlatBuffersReaderCache()) {
        self.count = data.count
        self.cache = cache
        if withoutCopy {
            var pointer : UnsafePointer<UInt8>! = nil
            data.withUnsafeBytes { (u8Ptr: UnsafePointer<UInt8>) in
                pointer = u8Ptr
            }
            self.buffer = UnsafeRawPointer(pointer)
            self.originalBuffer = nil
        } else {
            let pointer : UnsafeMutablePointer<UInt8> = UnsafeMutablePointer.allocate(capacity: data.count)
            self.originalBuffer = UnsafeMutableBufferPointer(start: pointer, count: data.count)
            _ = data.copyBytes(to: originalBuffer)
            self.buffer = UnsafeRawPointer(pointer)
        }
    }

    deinit {
        if let originalBuffer = originalBuffer,
            let pointer = originalBuffer.baseAddress {
            pointer.deinitialize(count: count)
        }
    }

    public func scalar<T : Scalar>(at offset: Int) throws -> T {
        if offset + MemoryLayout<T>.stride > count || offset < 0 {
            throw FlatBuffersReaderError.outOfBufferBounds
        }

        return buffer.load(fromByteOffset: offset, as: T.self)
    }

    public func bytes(at offset : Int, length : Int) throws -> UnsafeBufferPointer<UInt8> {
        if Int(offset + length) > count {
            throw FlatBuffersReaderError.outOfBufferBounds
        }
        let pointer = buffer.advanced(by:offset).bindMemory(to: UInt8.self, capacity: length)
        return UnsafeBufferPointer<UInt8>.init(start: pointer, count: Int(length))
    }

    public func isEqual(other: FlatBuffersReader) -> Bool{
        guard let other = other as? FlatBuffersMemoryReader else {
            return false
        }
        return self.buffer == other.buffer
    }
}

/// A FlatBuffers reader subclass that reads directly from a file handle
public final class FlatBuffersFileReader : FlatBuffersReader {

    private let fileSize : UInt64
    private let fileHandle : FileHandle
    public let cache : FlatBuffersReaderCache?

    /**
     Initializes the reader from a FileHandle object.

     - parameters:
     - fileHandle: A FileHandle object referencing the file we read from.
     - cache: An optional cache of reader objects for reuse

     - Returns: A FlatBuffers reader ready for use.
     */
    public init(fileHandle : FileHandle, cache : FlatBuffersReaderCache? = FlatBuffersReaderCache()){
        self.fileHandle = fileHandle
        fileSize = fileHandle.seekToEndOfFile()

        self.cache = cache
    }

    private struct DataCacheKey : Hashable {
        let offset : Int
        let lenght : Int

        static func ==(a : DataCacheKey, b : DataCacheKey) -> Bool {
            return a.offset == b.offset && a.lenght == b.lenght
        }

        var hashValue: Int {
            return offset
        }
    }

    private var dataCache : [DataCacheKey:Data] = [:]

    public func clearDataCache(){
        dataCache.removeAll(keepingCapacity: true)
    }

    public func scalar<T : Scalar>(at offset: Int) throws -> T {
        let seekPosition = UInt64(offset)
        let length = MemoryLayout<T>.stride
        if seekPosition + UInt64(length) > fileSize {
            throw FlatBuffersReaderError.outOfBufferBounds
        }

        let cacheKey = DataCacheKey(offset: offset, lenght: length)

        let data : Data
        if let _data = dataCache[cacheKey] {
            data = _data
        } else {
            fileHandle.seek(toFileOffset: UInt64(offset))
            data = fileHandle.readData(ofLength:Int(length))
            dataCache[cacheKey] = data
        }
        return data.withUnsafeBytes { (pointer) -> T in
            return pointer.pointee
        }
    }

    public func bytes(at offset : Int, length : Int) throws -> UnsafeBufferPointer<UInt8> {
        if UInt64(offset + length) > fileSize {
            throw FlatBuffersReaderError.outOfBufferBounds
        }

        let cacheKey = DataCacheKey(offset: offset, lenght: length)

        let data : Data
        if let _data = dataCache[cacheKey] {
            data = _data
        } else {
            fileHandle.seek(toFileOffset: UInt64(offset))
            data = fileHandle.readData(ofLength:Int(length))
            dataCache[cacheKey] = data
        }

        var t : UnsafeBufferPointer<UInt8>! = nil
        data.withUnsafeBytes{
            t = UnsafeBufferPointer(start: $0, count: length)
        }

        return t
    }

    public func isEqual(other: FlatBuffersReader) -> Bool{
        guard let other = other as? FlatBuffersFileReader else {
            return false
        }
        return self.fileHandle === other.fileHandle
    }
}

postfix operator §

public postfix func §(value: UnsafeBufferPointer<UInt8>?) -> String? {
    guard let p = value?.baseAddress, let value = value else {
        return nil
    }
    return String.init(bytesNoCopy: UnsafeMutablePointer<UInt8>(mutating: p), length: value.count, encoding: String.Encoding.utf8, freeWhenDone: false)
}

public protocol FlatBuffersDirectAccess {
    init?<R : FlatBuffersReader>(reader: R, myOffset: Offset?)
}
public struct FlatBuffersTableVector<T: FlatBuffersDirectAccess, R : FlatBuffersReader> : Collection {
    public let count : Int

    fileprivate let reader : R
    fileprivate let myOffset : Offset?

    public init(reader: R, myOffset: Offset?){
        self.reader = reader
        self.myOffset = myOffset
        self.count = reader.vectorElementCount(vectorOffset: myOffset)
    }

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return count
    }

    public func index(after i: Int) -> Int {
        return i+1
    }

    public subscript(i : Int) -> T? {
        let offset = reader.vectorElementOffset(vectorOffset: myOffset, index: i)
        return T(reader: reader, myOffset: offset)
    }
}

public struct FlatBuffersScalarVector<T: Scalar, R : FlatBuffersReader> : Collection {
    public let count : Int

    fileprivate let reader : R
    fileprivate let myOffset : Offset?
    public init(reader: R, myOffset: Offset?){
        self.reader = reader
        self.myOffset = myOffset
        self.count = reader.vectorElementCount(vectorOffset: myOffset)
    }

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return count
    }

    public func index(after i: Int) -> Int {
        return i+1
    }

    public subscript(i : Int) -> T? {
        return reader.vectorElementScalar(vectorOffset: myOffset, index: i)
    }
}

public protocol FlatBuffersEnum {
    static func fromScalar<T: Scalar>(_ scalar: T) -> Self?
}

public struct FlatBuffersEnumVector<T: Scalar, R : FlatBuffersReader, E: FlatBuffersEnum> : Collection {
    public let count : Int

    fileprivate let reader : R
    fileprivate let myOffset : Offset?
    public init(reader: R, myOffset: Offset?){
        self.reader = reader
        self.myOffset = myOffset
        self.count = reader.vectorElementCount(vectorOffset: myOffset)
    }

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return count
    }

    public func index(after i: Int) -> Int {
        return i+1
    }

    public subscript(i : Int) -> E? {
        guard let scalar : T = reader.vectorElementScalar(vectorOffset: myOffset, index: i) else {
            return nil
        }
        return E.fromScalar(scalar)
    }
}
public struct FlatBuffersStringVector<R : FlatBuffersReader> : Collection {
    public let count : Int

    fileprivate let reader : R
    fileprivate let myOffset : Offset?

    public init(reader: R, myOffset: Offset?){
        self.reader = reader
        self.myOffset = myOffset
        self.count = reader.vectorElementCount(vectorOffset: myOffset)
    }

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return count
    }

    public func index(after i: Int) -> Int {
        return i+1
    }

    public subscript(i : Int) -> UnsafeBufferPointer<UInt8>? {
        let offset = reader.vectorElementOffset(vectorOffset: myOffset, index: i)
        return reader.stringBuffer(stringOffset: offset)
    }
}
