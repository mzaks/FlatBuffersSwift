//
//  FlatBufferBuilder.swift
//  SwiftFlatBuffers
//
//  Created by Maxim Zaks on 01.11.15.
//  Copyright © 2015 maxim.zaks. All rights reserved.
//
import Foundation

public enum FlatBufferBuilderError : ErrorType {
    case ObjectIsNotClosed
    case NoOpenObject
    case PropertyIndexIsInvalid
    case OffsetIsTooBig
    case CursorIsInvalid
    case BadFileIdentifier
    case UnsupportedType
}

public final class FlatBufferBuilder {
    
    public static var maxInstanceCacheSize : UInt = 0 // max number of cached instances
    static var instancePool : [FlatBufferBuilder] = []
    
    public var cache : [ObjectIdentifier : Offset] = [:]
    public var inProgress : Set<ObjectIdentifier> = []
    public var deferedBindings : ContiguousArray<(object:Any, cursor:Int)> = []
    
    public var config : BinaryBuildConfig
    
    var capacity : Int
    private var _data : UnsafeMutablePointer<UInt8>
    public var _dataCount : Int { return cursor } // count of bytes in unsafe buffer
    public var _dataStart : UnsafeMutablePointer<UInt8> { return _data.advancedBy(leftCursor) } // start of actual raw unsafe buffer data
    public var data : [UInt8] {
        return Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(_data).advancedBy(leftCursor), count: cursor))
    }
    var cursor = 0
    var leftCursor : Int {
        return capacity - cursor
    }
    
    var currentVTable : ContiguousArray<Int32> = []
    var objectStart : Int32 = -1
    var vectorNumElems : Int32 = -1;
    var vTableOffsets : ContiguousArray<Int32> = []
    
    public init(config : BinaryBuildConfig){
        self.config = config
        self.capacity = config.initialCapacity
        _data = UnsafeMutablePointer.alloc(capacity)
    }
    
    deinit {
        _data.dealloc(capacity)
    }    

    private func increaseCapacity(size : Int){
        guard leftCursor <= size else {
            return
        }
        let _leftCursor = leftCursor
        let _capacity = capacity
        while leftCursor <= size {
            capacity = capacity << 1
        }
        
        let newData = UnsafeMutablePointer<UInt8>.alloc(capacity)
        newData.advancedBy(leftCursor).initializeFrom(_data.advancedBy(_leftCursor), count: cursor)
        _data.dealloc(_capacity)
        _data = newData
    }
    
    var minalign = 1;
    private func align(size : Int, additionalBytes : Int){
        if config.fullMemoryAlignment == false {
            return
        }
        if size > minalign {
            minalign = size
        }
        let alignSize = ((~(cursor + additionalBytes)) + 1) & (size - 1)
        increaseCapacity(alignSize)
        cursor += alignSize
        
    }
    
    public func put<T : Scalar>(value : T){
        var v = value
        let c = strideofValue(v)
        if c > 8 {
            align(8, additionalBytes: c)
        } else {
            align(c, additionalBytes: 0)
        }

        increaseCapacity(c)
        withUnsafePointer(&v){
            _data.advancedBy(leftCursor-c).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
        cursor += c

    }
    
    public func put<T : Scalar>(value : UnsafePointer<T>, length : Int){
        if length > 8 {
            align(8, additionalBytes: length)
        } else {
            align(length, additionalBytes: 0)
        }
        
        increaseCapacity(length)
        _data.advancedBy(leftCursor-length).assignFrom(UnsafeMutablePointer<UInt8>(value), count: length)
        cursor += length
    }
    
    public func putOffset(offset : Offset?) throws -> Int { // make offset relative and put it into byte buffer
        guard let offset = offset else {
            put(Offset(0))
            return cursor
        }
        guard offset <= Int32(cursor) else {
            throw FlatBufferBuilderError.OffsetIsTooBig
        }
        
        if offset == Int32(0) {
            put(Offset(0))
            return cursor
        }
        align(4, additionalBytes: 0)
        let _offset = Int32(cursor) - offset + strideof(Int32);
        put(_offset)
        return cursor
    }
    
    public func replaceOffset(offset : Offset, atCursor jumpCursor: Int) throws{
        guard offset <= Int32(cursor) else {
            throw FlatBufferBuilderError.OffsetIsTooBig
        }
        guard jumpCursor <= cursor else {
            throw FlatBufferBuilderError.CursorIsInvalid
        }
        let _offset = Int32(jumpCursor) - offset;
        
        var v = _offset
        if UInt32(CFByteOrderGetCurrent()) == CFByteOrderBigEndian.rawValue{
            v = _offset.littleEndian
        }
        let c = strideofValue(v)
        withUnsafePointer(&v){
            _data.advancedBy((capacity - jumpCursor)).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
    }
    
    private func put<T : Scalar>(value : T, at index : Int){
        var v = value
        let c = strideofValue(v)
        withUnsafePointer(&v){
            _data.advancedBy(index + leftCursor).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
    }
    
    public func openObject(numOfProperties : Int) throws {
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBufferBuilderError.ObjectIsNotClosed
        }
        currentVTable.removeAll(keepCapacity: true)
        currentVTable.reserveCapacity(numOfProperties)
        for _ in 0..<numOfProperties {
            currentVTable.append(0)
        }
        objectStart = Int32(cursor)
    }
    
    public func addPropertyOffsetToOpenObject(propertyIndex : Int, offset : Offset) throws -> Int{
        guard objectStart > -1 else {
            throw FlatBufferBuilderError.NoOpenObject
        }
        guard propertyIndex >= 0 && propertyIndex < currentVTable.count else {
            throw FlatBufferBuilderError.PropertyIndexIsInvalid
        }
        try putOffset(offset)
        currentVTable[propertyIndex] = Int32(cursor)
        return cursor
    }
    
    public func addPropertyToOpenObject<T : Scalar>(propertyIndex : Int, value : T, defaultValue : T) throws {
        guard objectStart > -1 else {
            throw FlatBufferBuilderError.NoOpenObject
        }
        guard propertyIndex >= 0 && propertyIndex < currentVTable.count else {
            throw FlatBufferBuilderError.PropertyIndexIsInvalid
        }
        
        if(config.forceDefaults == false && value == defaultValue) {
            return
        }
        
        put(value)
        currentVTable[propertyIndex] = Int32(cursor)
    }
    
    public func addCurrentOffsetAsPropertyToOpenObject(propertyIndex : Int) throws {
        guard objectStart > -1 else {
            throw FlatBufferBuilderError.NoOpenObject
        }
        guard propertyIndex >= 0 && propertyIndex < currentVTable.count else {
            throw FlatBufferBuilderError.PropertyIndexIsInvalid
        }
        currentVTable[propertyIndex] = Int32(cursor)
    }
    
    public func closeObject() throws -> Offset {
        guard objectStart > -1 else {
            throw FlatBufferBuilderError.NoOpenObject
        }
        
        increaseCapacity(4)
        cursor += 4 // Will be set to vtable offset afterwards
        
        let vtableloc = cursor
        
        // vtable is stored as relative offset for object data
        var index = currentVTable.count - 1
        while(index>=0) {
            // Offset relative to the start of the table.
            let off = Int16(currentVTable[index] != 0 ? Int32(vtableloc) - currentVTable[index] : 0);
            put(off);
            index -= 1
        }
        
        let numberOfstandardFields = 2
        
        put(Int16(Int32(vtableloc) - objectStart)); // standard field 1: lenght of the object data
        put(Int16((currentVTable.count + numberOfstandardFields) * strideof(Int16))); // standard field 2: length of vtable and standard fields them selves
        
        // search if we already have same vtable
        let vtableDataLength = cursor - vtableloc
        
        var foundVTableOffset = vtableDataLength
        
        if config.uniqueVTables{
            for otherVTableOffset in vTableOffsets {
                let start = cursor - Int(otherVTableOffset)
                var found = true
                for i in 0 ..< vtableDataLength {
                    let a = _data.advancedBy(leftCursor + i).memory
                    let b = _data.advancedBy(leftCursor + i + start).memory
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
        
        put(Int32(foundVTableOffset), at: indexLocation)
        
        objectStart = -1
        
        return Offset(vtableloc)
    }
    
    public func startVector(count : Int, elementSize : Int) throws{
        align(4, additionalBytes: count * elementSize)
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBufferBuilderError.ObjectIsNotClosed
        }
        vectorNumElems = Int32(count)
    }
    
    public func endVector() -> Offset {
        put(vectorNumElems)
        vectorNumElems = -1
        return Int32(cursor)
    }
    
    private var stringCache : [String:Offset] = [:]
    public func createString(value : String?) throws -> Offset {
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBufferBuilderError.ObjectIsNotClosed
        }
        guard let value = value else {
            return 0
        }
        
        if config.uniqueStrings{
            if let o = stringCache[value]{
                return o
            }
        }
        
        if config.nullTerminatedUTF8 {
            let utf8View = value.nulTerminatedUTF8
            
            let length = utf8View.count
            align(4, additionalBytes: length)
            increaseCapacity(length)
            
            let p = UnsafeMutablePointer<UInt8>(_data.advancedBy(leftCursor-length))
            var charofs = 0
            for c in utf8View {
                assert(charofs < length)
                p.advancedBy(charofs).memory = c
                charofs = charofs + 1
            }
            cursor += length
            put(Int32(length - 1))
        } else {
            let utf8View = value.utf8
            
            let length = utf8View.count
            align(4, additionalBytes: length)
            increaseCapacity(length)
            
            let p = UnsafeMutablePointer<UInt8>(_data.advancedBy(leftCursor-length))
            var charofs = 0
            for c in utf8View {
                assert(charofs < length)
                p.advancedBy(charofs).memory = c
                charofs = charofs + 1
            }
            cursor += length
            put(Int32(length))
        }
        
        let o = Offset(cursor)
        if config.uniqueStrings {
            stringCache[value] = o
        }
        return o
    }
    
    public func createString(value : UnsafeBufferPointer<UInt8>?) throws -> Offset {
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBufferBuilderError.ObjectIsNotClosed
        }
        guard let value = value else {
            return 0
        }
        let length = value.count
        align(4, additionalBytes: length)
        increaseCapacity(length)
        _data.advancedBy(leftCursor-length).assignFrom(UnsafeMutablePointer(value.baseAddress), count: length)
        cursor += length
        put(Int32(length))
        return Offset(cursor)
    }
    
    public func createStaticString(value : StaticString?) throws -> Offset {
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBufferBuilderError.ObjectIsNotClosed
        }
        guard let value = value else {
            return 0
        }
        
        let buf = value.utf8Start
        let length = value.byteSize
        align(4, additionalBytes: length)
        increaseCapacity(length)
        _data.advancedBy(leftCursor-length).assignFrom(UnsafeMutablePointer<UInt8>(buf), count: length)
        cursor += length
        
        put(Int32(length))
        return Offset(cursor)
    }
    
    public func finish(offset : Offset, fileIdentifier : String?) throws -> Void {
        guard offset <= Int32(cursor) else {
            throw FlatBufferBuilderError.OffsetIsTooBig
        }
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBufferBuilderError.ObjectIsNotClosed
        }
        var prefixLength = 4
        increaseCapacity(8)
        if let fileIdentifier = fileIdentifier {
            let buf = fileIdentifier.utf8
            guard buf.count == 4 else {
                throw FlatBufferBuilderError.BadFileIdentifier
            }
            
            _data.advancedBy(leftCursor-4).initializeFrom(buf)
            prefixLength += 4
        }
        
        var v = (Int32(cursor + prefixLength) - offset).littleEndian
        let c = strideofValue(v)
        withUnsafePointer(&v){
            _data.advancedBy(leftCursor - prefixLength).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
        cursor += prefixLength
    }
}

// Pooling
public extension FlatBufferBuilder {
    
    public func reset ()
    {
        cursor = 0
        objectStart = -1
        vectorNumElems = -1;
        vTableOffsets.removeAll(keepCapacity: true)
        currentVTable.removeAll(keepCapacity: true)
        cache.removeAll(keepCapacity: true)
        inProgress.removeAll(keepCapacity: true)
        deferedBindings.removeAll(keepCapacity: true)
        stringCache.removeAll(keepCapacity: true)
    }
    
    public static func create(config: BinaryBuildConfig) -> FlatBufferBuilder {
        objc_sync_enter(instancePool)
        defer { objc_sync_exit(instancePool) }

        if (instancePool.count > 0)
        {
            let builder = instancePool.removeLast()
            builder.config = config
            if (config.initialCapacity > builder.capacity) {
                builder._data.dealloc(builder.capacity)
                builder.capacity = config.initialCapacity
                builder._data = UnsafeMutablePointer.alloc(builder.capacity)
            }
            return builder
        }
        
        return FlatBufferBuilder(config: config)
    }
    
    public static func reuse(builder : FlatBufferBuilder) {
        objc_sync_enter(instancePool)
        defer { objc_sync_exit(instancePool) }

        if (UInt(instancePool.count) < maxInstanceCacheSize)
        {
            builder.reset()
            instancePool.append(builder)
        }
    }
    
}
