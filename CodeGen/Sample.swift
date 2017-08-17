
// generated with FlatBuffersSchemaEditor https://github.com/mzaks/FlatBuffersSchemaEditor

import Foundation

public enum E: Int8, FlatBuffersEnum {
    case A, B
    public static func fromScalar<T>(_ scalar: T) -> E? where T : Scalar {
        guard let value = scalar as? RawValue else {
            return nil
        }
        return E(rawValue: value)
    }
}
public struct S1: Scalar {
    public let a: Bool
    public static func ==(v1:S1, v2:S1) -> Bool {
        return v1.a==v2.a
    }
}
public enum U1 {
    case tableT0(T0), tableT1(T1)
    fileprivate static func from(selfReader: U1.Direct<FlatBuffersMemoryReader>?) -> U1? {
        guard let selfReader = selfReader else {
            return nil
        }
        switch selfReader {
        case .tableT0(let o):
            guard let o1 = T0.from(selfReader: o) else {
                return nil
            }
            return .tableT0(o1)
        case .tableT1(let o):
            guard let o1 = T1.from(selfReader: o) else {
                return nil
            }
            return .tableT1(o1)
        }
    }
    public enum Direct<R : FlatBuffersReader> {
        case tableT0(T0.Direct<R>), tableT1(T1.Direct<R>)
        fileprivate static func from(reader: R, propertyIndex : Int, objectOffset : Offset?) -> U1.Direct<R>? {
            guard let objectOffset = objectOffset else {
                return nil
            }
            let unionCase : Int8 = reader.get(objectOffset: objectOffset, propertyIndex: propertyIndex, defaultValue: 0)
            guard let caseObjectOffset : Offset = reader.offset(objectOffset: objectOffset, propertyIndex:propertyIndex + 1) else {
                return nil
            }
            switch unionCase {
            case 1:
                guard let o = T0.Direct<R>(reader: reader, myOffset: caseObjectOffset) else {
                    return nil
                }
                return U1.Direct.tableT0(o)
            case 2:
                guard let o = T1.Direct<R>(reader: reader, myOffset: caseObjectOffset) else {
                    return nil
                }
                return U1.Direct.tableT1(o)
            default:
                break
            }
            return nil
        }
    }
    var unionCase: Int8 {
        switch self {
        case .tableT0(_): return 1
        case .tableT1(_): return 2
        }
    }
    func insert(_ builder: FlatBuffersBuilder) throws -> Offset {
        switch self {
        case .tableT0(let o): return try o.insert(builder)
        case .tableT1(let o): return try o.insert(builder)
        }
    }
}
extension T0.Direct {
    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset? = nil) {
        guard let reader = reader as? T else {
            return nil
        }
        self._reader = reader
        if let myOffset = myOffset {
            self._myOffset = myOffset
        } else {
            if let rootOffset = reader.rootObjectOffset {
                self._myOffset = rootOffset
            } else {
                return nil
            }
        }
    }
    public var hashValue: Int { return Int(_myOffset) }
    public static func ==<T>(t1 : T0.Direct<T>, t2 : T0.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var a: UnsafeBufferPointer<UInt8>? {
        return _reader.stringBuffer(stringOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:0))
    }
}
public final class T0 {
    public var a: String?
    public init(a: String? = nil) {
        self.a = a
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}
extension T0 {
    
    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> T0? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? T0 {
            return o
        }
        return T0(
            a: selfReader.a§
        )
    }
    
    fileprivate func insert(_ builder: FlatBuffersBuilder) throws -> Offset {
        return 0
    }
}
extension T1.Direct {
    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset? = nil) {
        guard let reader = reader as? T else {
            return nil
        }
        self._reader = reader
        if let myOffset = myOffset {
            self._myOffset = myOffset
        } else {
            if let rootOffset = reader.rootObjectOffset {
                self._myOffset = rootOffset
            } else {
                return nil
            }
        }
    }
    public var hashValue: Int { return Int(_myOffset) }
    public static func ==<T>(t1 : T1.Direct<T>, t2 : T1.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var i: Int32 {
        return _reader.get(objectOffset: _myOffset, propertyIndex: 0, defaultValue: 0)
    }
    public var b: Bool {
        return _reader.get(objectOffset: _myOffset, propertyIndex: 1, defaultValue: false)
    }
    public var bs: FlatBuffersScalarVector<Bool, T> {
        return FlatBuffersScalarVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:2))
    }
    public var name: UnsafeBufferPointer<UInt8>? {
        return _reader.stringBuffer(stringOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:3))
    }
    public var names: FlatBuffersStringVector<T> {
        return FlatBuffersStringVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:4))
    }
    public var _self: T0.Direct<T>? {
        return T0.Direct(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:5))
    }
    public var selfs: FlatBuffersTableVector<T0.Direct<T>, T> {
        return FlatBuffersTableVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:6))
    }
    public var s: S1? {
        return _reader.get(objectOffset: _myOffset, propertyIndex: 7)
    }
    public var s_s: FlatBuffersScalarVector<S1, T> {
        return FlatBuffersScalarVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:8))
    }
    public var e: E? {
        return E(rawValue:_reader.get(objectOffset: _myOffset, propertyIndex: 9, defaultValue: E.A.rawValue))
    }
    public var es: FlatBuffersEnumVector<Int8, T, E> {
        return FlatBuffersEnumVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:10))
    }
    public var u: U1.Direct<T>? {
        return U1.Direct.from(reader: _reader, propertyIndex : 11, objectOffset : _myOffset)
    }
}
public final class T1 {
    public var i: Int32
    public var b: Bool
    public var bs: [Bool]
    public var name: String?
    public var names: [String]
    public var _self: T0?
    public var selfs: [T0]
    public var s: S1?
    public var s_s: [S1]
    public var e: E?
    public var es: [E]
    public var u: U1?
    public init(i: Int32 = 0, b: Bool = false, bs: [Bool] = [], name: String? = nil, names: [String] = [], _self: T0? = nil, selfs: [T0] = [], s: S1? = nil, s_s: [S1] = [], e: E? = E.A, es: [E] = [], u: U1? = nil) {
        self.i = i
        self.b = b
        self.bs = bs
        self.name = name
        self.names = names
        self._self = _self
        self.selfs = selfs
        self.s = s
        self.s_s = s_s
        self.e = e
        self.es = es
        self.u = u
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}
extension T1 {
    
    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> T1? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? T1 {
            return o
        }
        return T1(
            i: selfReader.i,
            b: selfReader.b,
            bs: selfReader.bs.flatMap{$0},
            name: selfReader.name§,
            names: selfReader.names.flatMap{ $0§ },
            _self: T0.from(selfReader:selfReader._self),
            selfs: selfReader.selfs.flatMap{ T0.from(selfReader:$0) },
            s: selfReader.s,
            s_s: selfReader.s_s.flatMap{$0},
            e: selfReader.e,
            es: selfReader.es.flatMap{$0},
            u: U1.from(selfReader: selfReader.u)
        )
    }
}

//////////////////////////////

extension FlatBuffersBuilder {
    public func insertT1(i: Int32 = 0, b: Bool = false, bs: Offset? = nil, name: Offset? = nil, names: Offset? = nil, _self: Offset? = nil, selfs: Offset? = nil, s: S1? = nil, s_s: Offset? = nil, e: E = E.A, es: Offset? = nil, u_type: Int8 = 0, u: Offset? = nil) throws -> Offset {
        try self.startObject(withPropertyCount: 14)
        try self.insert(value: b, defaultValue: false, toStartedObjectAt: 1)
        if let s = s {
            self.insert(value: s)
            try self.insertCurrentOffsetAsProperty(toStartedObjectAt: 8)
        }
        try self.insert(value: e.rawValue, defaultValue: E.A.rawValue, toStartedObjectAt: 10)
        try self.insert(value: u_type, defaultValue: 0, toStartedObjectAt: 12)
        try self.insert(value: i, defaultValue: 0, toStartedObjectAt: 0)
        if let bs = bs {
            try self.insert(offset: bs, toStartedObjectAt: 3)
        }
        if let name = name {
            try self.insert(offset: name, toStartedObjectAt: 4)
        }
        if let names = names {
            try self.insert(offset: names, toStartedObjectAt: 5)
        }
        if let _self = _self {
            try self.insert(offset: _self, toStartedObjectAt: 6)
        }
        if let selfs = selfs {
            try self.insert(offset: selfs, toStartedObjectAt: 7)
        }
        if let s_s = s_s {
            try self.insert(offset: s_s, toStartedObjectAt: 9)
        }
        if let es = es {
            try self.insert(offset: es, toStartedObjectAt: 11)
        }
        if let u = u {
            try self.insert(offset: u, toStartedObjectAt: 13)
        }
        return try self.endObject()
    }
}

extension T1 {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }
        let bs: Offset?
        if self.bs.isEmpty {
            bs = nil
        } else {
            try builder.startVector(count: self.bs.count, elementSize: MemoryLayout<Bool>.stride)
            for o in self.bs.reversed() {
                builder.insert(value: o)
            }
            bs = builder.endVector()
        }
        
        let name = self.name == nil ? nil : try builder.insert(value: self.name)
        
        let names: Offset?
        if self.names.isEmpty {
            names = nil
        } else {
            let offsets = try self.names.map{ try builder.insert(value: $0) }
            try builder.startVector(count: self.names.count, elementSize: MemoryLayout<Offset>.stride)
            for o in offsets.reversed() {
                builder.insert(value: o)
            }
            names = builder.endVector()
        }
        
        let _self = try self._self?.insert(builder)
        
        let selfs: Offset?
        if self.selfs.isEmpty {
            selfs = nil
        } else {
            let offsets = try self.selfs.map{ try $0.insert(builder) }
            try builder.startVector(count: self.selfs.count, elementSize: MemoryLayout<Offset>.stride)
            for o in offsets.reversed() {
                builder.insert(value: o)
            }
            selfs = builder.endVector()
        }
        
        let s_s: Offset?
        if self.s_s.isEmpty {
            s_s = nil
        } else {
            try builder.startVector(count: self.s_s.count, elementSize: MemoryLayout<S1>.stride)
            for o in self.s_s.reversed() {
                builder.insert(value: o)
            }
            s_s = builder.endVector()
        }
        
        let es: Offset?
        if self.es.isEmpty {
            es = nil
        } else {
            try builder.startVector(count: self.es.count, elementSize: MemoryLayout<E>.stride)
            for o in self.es.reversed() {
                builder.insert(value: o.rawValue)
            }
            es = builder.endVector()
        }
        
        let u = try self.u?.insert(builder)
        
        return try builder.insertT1(
            i: i,
            b: b,
            bs: bs,
            name: name,
            names: names,
            _self: _self,
            selfs: selfs,
            s: s,
            s_s: s_s,
            e: e ?? E.A,
            es: es,
            u_type: self.u?.unionCase ?? 0,
            u: u
        )
    }
}

// MARK: Reader
//
//  FlatBuffersReader.swift
//  FBSwift3
//
//  Created by Maxim Zaks on 28.10.16.
//  Copyright © 2016 Maxim Zaks. All rights reserved.
//
// See https://github.com/mzaks/FlatBuffersSwift/graphs/contributors for contributors.

import Foundation

public protocol FlatBuffersReader: class {
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
    guard let value = value, let p = value.baseAddress else {
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

//
//  Builder.swift
//  FBSwift3
//
//  Created by Maxim Zaks on 27.10.16.
//  Copyright © 2016 Maxim Zaks. All rights reserved.
//
// See https://github.com/mzaks/FlatBuffersSwift/graphs/contributors for contributors.

import Foundation

public typealias Offset = Int32

public protocol Scalar : Equatable {}

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

/// Various options for the builder
public struct FlatBuffersBuilderOptions {
    public let initialCapacity : Int
    public let uniqueStrings : Bool
    public let uniqueTables : Bool
    public let uniqueVTables : Bool
    public let forceDefaults : Bool
    public let nullTerminatedUTF8 : Bool
    public init(initialCapacity : Int = 1, uniqueStrings : Bool = true, uniqueTables : Bool = true, uniqueVTables : Bool = true, forceDefaults : Bool = false, nullTerminatedUTF8 : Bool = false) {
        self.initialCapacity = initialCapacity
        self.uniqueStrings = uniqueStrings
        self.uniqueTables = uniqueTables
        self.uniqueVTables = uniqueVTables
        self.forceDefaults = forceDefaults
        self.nullTerminatedUTF8 = nullTerminatedUTF8
    }
}

public enum FlatBuffersBuildError : Error {
    case objectIsNotClosed
    case noOpenObject
    case propertyIndexIsInvalid
    case offsetIsTooBig
    case cursorIsInvalid
    case badFileIdentifier
    case unsupportedType
}

/// A FlatBuffers builder that supports the generation of flatbuffers 'wire' format from an object graph
public final class FlatBuffersBuilder {
    
    public var options : FlatBuffersBuilderOptions
    private var capacity : Int
    private var _data : UnsafeMutableRawPointer
    private var minalign = 1
    private var cursor = 0
    private var leftCursor : Int {
        return capacity - cursor
    }
    
    private var currentVTable : ContiguousArray<Int32> = []
    private var objectStart : Int32 = -1
    private var vectorNumElems : Int32 = -1
    private var vTableOffsets : ContiguousArray<Int32> = []
    
    public var cache : [ObjectIdentifier : Offset] = [:]
    public var inProgress : Set<ObjectIdentifier> = []
    public var deferedBindings : ContiguousArray<(object:Any, cursor:Int)> = []
    
    /**
     Initializes the builder
     
     - parameters:
     - options: The options to use for this builder.
     
     - Returns: A FlatBuffers builder ready for use.
     */
    public init(options _options : FlatBuffersBuilderOptions = FlatBuffersBuilderOptions()) {
        self.options = _options
        self.capacity = self.options.initialCapacity
        _data = UnsafeMutableRawPointer.allocate(bytes: capacity, alignedTo: minalign)
    }
    
    /**
     Allocates and returns a Data object initialized from the builder backing store
     
     - Returns: A Data object initilized with the data from the builder backing store
     */
    public var makeData : Data {
        return Data(bytes:_data.advanced(by:leftCursor), count: cursor)
    }
    
    /**
     Reserve enough space to store at a minimum size more data and resize the
     underlying buffer if needed.
     
     The data should be consumed by the builder immediately after reservation.
     
     - parameters:
     - size: The additional size that will be consumed by the builder
     immedieatly after the call
     */
    private func reserveAdditionalCapacity(size : Int){
        guard leftCursor <= size else {
            return
        }
        let _leftCursor = leftCursor
        let _capacity = capacity
        while leftCursor <= size {
            capacity = capacity << 1
        }
        
        let newData = UnsafeMutableRawPointer.allocate(bytes: capacity, alignedTo: minalign)
        newData.advanced(by:leftCursor).copyBytes(from: _data.advanced(by: _leftCursor), count: cursor)
        _data.deallocate(bytes: _capacity, alignedTo: minalign)
        _data = newData
    }
    
    /**
     Perform alignment for a value of a given size by performing padding in advance
     of actually putting the value to the buffer.
     
     - parameters:
     - size: xxx
     - additionalBytes: xxx
     */
    private func align(size : Int, additionalBytes : Int){
        if size > minalign {
            minalign = size
        }
        let alignSize = ((~(cursor + additionalBytes)) + 1) & (size - 1)
        reserveAdditionalCapacity(size: alignSize)
        cursor += alignSize
    }
    
    /**
     Add a scalar value to the buffer
     
     - parameters:
     - value: The value to add to the buffer
     */
    public func insert<T : Scalar>(value : T){
        let c = MemoryLayout.stride(ofValue: value)
        if c > 8 {
            align(size: 8, additionalBytes: c)
        } else {
            align(size: c, additionalBytes: 0)
        }
        
        reserveAdditionalCapacity(size: c)
        
        _data.storeBytes(of: value, toByteOffset: leftCursor-c, as: T.self)
        cursor += c
    }
    
    /**
     Make offset relative and add it to the buffer
     
     - parameters:
     - offset: The offset to transform and add to the buffer
     */
    @discardableResult
    public func insert(offset : Offset?) throws -> Int {
        guard let offset = offset else {
            insert(value: Offset(0))
            return cursor
        }
        guard offset <= Int32(cursor) else {
            throw FlatBuffersBuildError.offsetIsTooBig
        }
        
        if offset == Int32(0) {
            insert(value: Offset(0))
            return cursor
        }
        align(size: 4, additionalBytes: 0)
        let _offset = Int32(cursor) - offset + Offset(MemoryLayout<Int32>.stride)
        insert(value: _offset)
        return cursor
    }
    
    /**
     Update an offset in place
     
     - parameters:
     - offset: The new offset to transform and add to the buffer
     - atCursor: The position to put the new offset to
     */
    public func update(offset : Offset, atCursor jumpCursor: Int) throws{
        guard offset <= Int32(cursor) else {
            throw FlatBuffersBuildError.offsetIsTooBig
        }
        guard jumpCursor <= cursor else {
            throw FlatBuffersBuildError.cursorIsInvalid
        }
        let _offset = Int32(jumpCursor) - offset
        
        _data.storeBytes(of: _offset, toByteOffset: capacity - jumpCursor, as: Int32.self)
    }
    
    /**
     Update a scalar in place
     
     - parameters:
     - value: The new value
     - index: The position to modify
     */
    private func update<T : Scalar>(value : T, at index : Int) {
        _data.storeBytes(of: value, toByteOffset: index + leftCursor, as: T.self)
    }
    
    /**
     Start an object construction sequence
     
     - parameters:
     - withPropertyCount: The number of properties we will update
     */
    public func startObject(withPropertyCount : Int) throws {
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBuffersBuildError.objectIsNotClosed
        }
        currentVTable.removeAll(keepingCapacity: true)
        currentVTable.reserveCapacity(withPropertyCount)
        for _ in 0..<withPropertyCount {
            currentVTable.append(0)
        }
        objectStart = Int32(cursor)
    }
    
    /**
     Add an offset into the buffer for the currently open object
     
     - parameters:
     - propertyIndex: The index of the property to update
     - offset: The offsetnumber of properties we will update
     
     - Returns: The current cursor position (Note: What is the use case of the return value?)
     */
    @discardableResult
    public func insert(offset : Offset, toStartedObjectAt propertyIndex : Int) throws -> Int{
        guard objectStart > -1 else {
            throw FlatBuffersBuildError.noOpenObject
        }
        guard propertyIndex >= 0 && propertyIndex < currentVTable.count else {
            throw FlatBuffersBuildError.propertyIndexIsInvalid
        }
        _ = try insert(offset: offset)
        currentVTable[propertyIndex] = Int32(cursor)
        return cursor
    }
    
    /**
     Add a scalar into the buffer for the currently open object
     
     - parameters:
     - propertyIndex: The index of the property to update
     - value: The value to append
     - defaultValue: If configured to skip default values, a value
     matching this default value will not be written to the buffer.
     */
    public func insert<T : Scalar>(value : T, defaultValue : T, toStartedObjectAt propertyIndex : Int) throws {
        guard objectStart > -1 else {
            throw FlatBuffersBuildError.noOpenObject
        }
        guard propertyIndex >= 0 && propertyIndex < currentVTable.count else {
            throw FlatBuffersBuildError.propertyIndexIsInvalid
        }
        
        if(options.forceDefaults == false && value == defaultValue) {
            return
        }
        
        insert(value: value)
        currentVTable[propertyIndex] = Int32(cursor)
    }
    
    /**
     Add the current cursor position into the buffer for the currently open object
     
     - parameters:
     - propertyIndex: The index of the property to update
     */
    public func insertCurrentOffsetAsProperty(toStartedObjectAt propertyIndex : Int) throws {
        guard objectStart > -1 else {
            throw FlatBuffersBuildError.noOpenObject
        }
        guard propertyIndex >= 0 && propertyIndex < currentVTable.count else {
            throw FlatBuffersBuildError.propertyIndexIsInvalid
        }
        currentVTable[propertyIndex] = Int32(cursor)
    }
    
    /**
     Close the current open object.
     */
    public func endObject() throws -> Offset {
        guard objectStart > -1 else {
            throw FlatBuffersBuildError.noOpenObject
        }
        align(size: 4, additionalBytes: 0)
        reserveAdditionalCapacity(size: 4)
        cursor += 4 // Will be set to vtable offset afterwards
        
        let vtableloc = cursor
        
        // vtable is stored as relative offset for object data
        var index = currentVTable.count - 1
        while(index>=0) {
            // Offset relative to the start of the table.
            let off = Int16(currentVTable[index] != 0 ? Int32(vtableloc) - currentVTable[index] : Int32(0))
            insert(value: off)
            index -= 1
        }
        
        let numberOfstandardFields = 2
        
        insert(value: Int16(Int32(vtableloc) - objectStart)) // standard field 1: lenght of the object data
        insert(value: Int16((currentVTable.count + numberOfstandardFields) * MemoryLayout<Int16>.stride)) // standard field 2: length of vtable and standard fields them selves
        
        // search if we already have same vtable
        let vtableDataLength = cursor - vtableloc
        
        var foundVTableOffset = vtableDataLength
        
        if options.uniqueVTables{
            for otherVTableOffset in vTableOffsets {
                let start = cursor - Int(otherVTableOffset)
                var found = true
                for i in 0 ..< vtableDataLength {
                    let a = _data.advanced(by:leftCursor + i).assumingMemoryBound(to: UInt8.self).pointee
                    let b = _data.advanced(by:leftCursor + i + start).assumingMemoryBound(to: UInt8.self).pointee
                    if a != b {
                        found = false
                        break
                    }
                }
                if found == true {
                    foundVTableOffset = Int(otherVTableOffset) - vtableloc
                    break
                }
            }
            
            if foundVTableOffset != vtableDataLength {
                cursor -= vtableDataLength
            } else {
                vTableOffsets.append(Int32(cursor))
            }
        }
        
        let indexLocation = cursor - vtableloc
        
        update(value: Int32(foundVTableOffset), at: indexLocation)
        
        objectStart = -1
        
        return Offset(vtableloc)
    }
    
    /**
     Start a vector update operation
     
     - parameters:
     - count: The number of elements in the vector
     - elementSize: The size of the vector elements
     */
    public func startVector(count : Int, elementSize : Int) throws{
        align(size: 4, additionalBytes: count * elementSize)
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBuffersBuildError.objectIsNotClosed
        }
        vectorNumElems = Int32(count)
    }
    
    /**
     Finish vector update operation
     */
    public func endVector() -> Offset {
        insert(value: vectorNumElems)
        vectorNumElems = -1
        return Int32(cursor)
    }
    
    private var stringCache : [String:Offset] = [:]
    
    /**
     Add a string to the buffer
     
     - parameters:
     - value: The string to add to the buffer
     
     - Returns: The current cursor position (Note: What is the use case of the return value?)
     */
    public func insert(value : String?) throws -> Offset {
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBuffersBuildError.objectIsNotClosed
        }
        guard let value = value else {
            return 0
        }
        
        if options.uniqueStrings{
            if let o = stringCache[value]{
                return o
            }
        }
        // TODO: Performance Test
        if options.nullTerminatedUTF8 {
            let utf8View = value.utf8CString
            let length = utf8View.count
            align(size: 4, additionalBytes: length)
            reserveAdditionalCapacity(size: length)
            for c in utf8View.lazy.reversed() {
                insert(value: c)
            }
            insert(value: Int32(length - 1))
        } else {
            let utf8View = value.utf8
            let length = utf8View.count
            align(size: 4, additionalBytes: length)
            reserveAdditionalCapacity(size: length)
            for c in utf8View.lazy.reversed() {
                insert(value: c)
            }
            insert(value: Int32(length))
        }
        
        let o = Offset(cursor)
        if options.uniqueStrings {
            stringCache[value] = o
        }
        return o
    }
    
    public func finish(offset : Offset, fileIdentifier : String?) throws -> Void {
        guard offset <= Int32(cursor) else {
            throw FlatBuffersBuildError.offsetIsTooBig
        }
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBuffersBuildError.objectIsNotClosed
        }
        var prefixLength = 4
        if let fileIdentifier = fileIdentifier {
            prefixLength += 4
            align(size: minalign, additionalBytes: prefixLength)
            let utf8View = fileIdentifier.utf8
            let count = utf8View.count
            guard count == 4 else {
                throw FlatBuffersBuildError.badFileIdentifier
            }
            for c in utf8View.lazy.reversed() {
                insert(value: c)
            }
        } else {
            align(size: minalign, additionalBytes: prefixLength)
        }
        
        let v = (Int32(cursor + 4) - offset)
        
        insert(value: v)
    }
}

