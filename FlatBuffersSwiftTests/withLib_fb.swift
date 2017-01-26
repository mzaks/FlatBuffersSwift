
// generated with FlatBuffersSchemaEditor https://github.com/mzaks/FlatBuffersSchemaEditor

import Foundation

public final class A {
	public var text : String? = nil
	public init(){}
	public init(text: String?){
		self.text = text
	}
}
public extension A {
	fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> A? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if  let cache = reader.cache,
			let o = cache.objectPool[objectOffset] {
			return o as? A
		}
		let _result = A()
		if let cache = reader.cache {
			cache.objectPool[objectOffset] = _result
		}
		_result.text = reader.stringBuffer(stringOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 0))?§
		return _result
	}
}
public extension A {
	public static func makeA(data : Data,  cache : FlatBuffersReaderCache? = FlatBuffersReaderCache()) -> A? {
		let reader = FlatBuffersMemoryReader(data: data, cache: cache)
		return makeA(reader: reader)
	}
	public static func makeA(reader : FlatBuffersReader) -> A? {
		let objectOffset = reader.rootObjectOffset
		return create(reader, objectOffset : objectOffset)
	}
}

public extension A {
	public func encode(withBuilder builder : FlatBuffersBuilder) throws -> Void {
		let offset = try addToByteArray(builder)
		try builder.finish(offset: offset, fileIdentifier: nil)
	}
	public func makeData(withOptions options : FlatBuffersBuilderOptions = FlatBuffersBuilderOptions()) throws -> Data {
		let builder = FlatBuffersBuilder(options: options)
		try encode(withBuilder: builder)
		return builder.makeData
	}
}

public struct A_Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
	fileprivate let reader : T
	fileprivate let myOffset : Offset
	public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset?) {
		guard let myOffset = myOffset, let reader = reader as? T else {
			return nil
		}
		self.reader = reader
		self.myOffset = myOffset
	}
	public init?(_ reader: T) {
		self.reader = reader
		guard let offest = reader.rootObjectOffset else {
			return nil
		}
		self.myOffset = offest
	}
	public var text : UnsafeBufferPointer<UInt8>? { get { return reader.stringBuffer(stringOffset: reader.offset(objectOffset: myOffset, propertyIndex:0)) } }
	public var hashValue: Int { return Int(myOffset) }
}
public func ==<T>(t1 : A_Direct<T>, t2 : A_Direct<T>) -> Bool {
	return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
}
public extension A {
	fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
		if builder.options.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		let offset0 = try builder.insert(value: text)
		try builder.startObject(withPropertyCount: 1)
		try builder.insert(offset: offset0, toStartedObjectAt: 0)
		let myOffset =  try builder.endObject()
		if builder.options.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
// MARK: Reader
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
        
        let position = objectOffset + propOffset
        do {
            let localObjectOffset : Int32 = try scalar(at: Int(position))
            let offset = position + localObjectOffset
            
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
        let valueStartPosition = Int(vectorOffset + MemoryLayout<Int32>.stride + (index * MemoryLayout<Int32>.stride))
        do {
            let localOffset : Int32 = try scalar(at: valueStartPosition)
            if(localOffset == 0){
                return nil
            }
            return localOffset + valueStartPosition
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
        
        let valueStartPosition = Int(vectorOffset + MemoryLayout<Int32>.stride + (index * MemoryLayout<T>.stride))
        
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
        let position = Int(objectOffset + propOffset)
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
        let position = Int(objectOffset + propOffset)
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

public postfix func §(value: UnsafeBufferPointer<UInt8>) -> String? {
    guard let p = value.baseAddress else {
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
// MARK: Builder
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
    private var minalign = 1;
    private var cursor = 0
    private var leftCursor : Int {
        return capacity - cursor
    }
    
    private var currentVTable : ContiguousArray<Int32> = []
    private var objectStart : Int32 = -1
    private var vectorNumElems : Int32 = -1;
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
        let _offset = Int32(cursor) - offset + MemoryLayout<Int32>.stride;
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
        let _offset = Int32(jumpCursor) - offset;
        
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
            let off = Int16(currentVTable[index] != 0 ? Int32(vtableloc) - currentVTable[index] : 0);
            insert(value: off);
            index -= 1
        }
        
        let numberOfstandardFields = 2
        
        insert(value: Int16(Int32(vtableloc) - objectStart)); // standard field 1: lenght of the object data
        insert(value: Int16((currentVTable.count + numberOfstandardFields) * MemoryLayout<Int16>.stride)); // standard field 2: length of vtable and standard fields them selves
        
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
                        break;
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
