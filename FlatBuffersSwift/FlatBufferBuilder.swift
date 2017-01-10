//
//  Builder.swift
//  FBSwift3
//
//  Created by Maxim Zaks on 27.10.16.
//  Copyright © 2016 Maxim Zaks. All rights reserved.
//

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

public struct FBBuildConfig {
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

public enum FBBuildError : Error {
    case objectIsNotClosed
    case noOpenObject
    case propertyIndexIsInvalid
    case offsetIsTooBig
    case cursorIsInvalid
    case badFileIdentifier
    case unsupportedType
}

public final class FBBuilder {
    
    private var _config : FBBuildConfig
    public var config : FBBuildConfig { return _config }
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
    
    public init(config : FBBuildConfig = FBBuildConfig()) {
        self._config = config
        self.capacity = config.initialCapacity
        _data = UnsafeMutableRawPointer.allocate(bytes: capacity, alignedTo: minalign)
    }
    
    public var data : Data {
        return Data(bytes:_data.advanced(by:leftCursor), count: cursor)
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
        
        let newData = UnsafeMutableRawPointer.allocate(bytes: capacity, alignedTo: minalign)
        newData.advanced(by:leftCursor).copyBytes(from: _data.advanced(by: _leftCursor), count: cursor)
        _data.deallocate(bytes: _capacity, alignedTo: minalign)
        _data = newData
    }
    
    private func align(size : Int, additionalBytes : Int){
        if size > minalign {
            minalign = size
        }
        let alignSize = ((~(cursor + additionalBytes)) + 1) & (size - 1)
        increaseCapacity(size: alignSize)
        cursor += alignSize
        
    }
    
    public func put<T : Scalar>(value : T){
        let c = MemoryLayout.stride(ofValue: value)
        if c > 8 {
            align(size: 8, additionalBytes: c)
        } else {
            align(size: c, additionalBytes: 0)
        }
        
        increaseCapacity(size: c)
        
        _data.storeBytes(of: value, toByteOffset: leftCursor-c, as: T.self)
        cursor += c
    }
    
    @discardableResult
    public func putOffset(offset : Offset?) throws -> Int { // make offset relative and put it into byte buffer
        guard let offset = offset else {
            put(value: Offset(0))
            return cursor
        }
        guard offset <= Int32(cursor) else {
            throw FBBuildError.offsetIsTooBig
        }
        
        if offset == Int32(0) {
            put(value: Offset(0))
            return cursor
        }
        align(size: 4, additionalBytes: 0)
        let _offset = Int32(cursor) - offset + MemoryLayout<Int32>.stride;
        put(value: _offset)
        return cursor
    }
    
    public func replaceOffset(offset : Offset, atCursor jumpCursor: Int) throws{
        guard offset <= Int32(cursor) else {
            throw FBBuildError.offsetIsTooBig
        }
        guard jumpCursor <= cursor else {
            throw FBBuildError.cursorIsInvalid
        }
        let _offset = Int32(jumpCursor) - offset;
        
        _data.storeBytes(of: _offset, toByteOffset: capacity - jumpCursor, as: Int32.self)
    }
    
    private func put<T : Scalar>(value : T, at index : Int) {
        _data.storeBytes(of: value, toByteOffset: index + leftCursor, as: T.self)
    }
    
    public func openObject(numOfProperties : Int) throws {
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FBBuildError.objectIsNotClosed
        }
        currentVTable.removeAll(keepingCapacity: true)
        currentVTable.reserveCapacity(numOfProperties)
        for _ in 0..<numOfProperties {
            currentVTable.append(0)
        }
        objectStart = Int32(cursor)
    }
    
    @discardableResult
    public func addPropertyOffsetToOpenObject(propertyIndex : Int, offset : Offset) throws -> Int{
        guard objectStart > -1 else {
            throw FBBuildError.noOpenObject
        }
        guard propertyIndex >= 0 && propertyIndex < currentVTable.count else {
            throw FBBuildError.propertyIndexIsInvalid
        }
        _ = try putOffset(offset: offset)
        currentVTable[propertyIndex] = Int32(cursor)
        return cursor
    }
    
    public func addPropertyToOpenObject<T : Scalar>(propertyIndex : Int, value : T, defaultValue : T) throws {
        guard objectStart > -1 else {
            throw FBBuildError.noOpenObject
        }
        guard propertyIndex >= 0 && propertyIndex < currentVTable.count else {
            throw FBBuildError.propertyIndexIsInvalid
        }
        
        if(config.forceDefaults == false && value == defaultValue) {
            return
        }
        
        put(value: value)
        currentVTable[propertyIndex] = Int32(cursor)
    }
    
    public func addCurrentOffsetAsPropertyToOpenObject(propertyIndex : Int) throws {
        guard objectStart > -1 else {
            throw FBBuildError.noOpenObject
        }
        guard propertyIndex >= 0 && propertyIndex < currentVTable.count else {
            throw FBBuildError.propertyIndexIsInvalid
        }
        currentVTable[propertyIndex] = Int32(cursor)
    }
    
    public func closeObject() throws -> Offset {
        guard objectStart > -1 else {
            throw FBBuildError.noOpenObject
        }
        align(size: 4, additionalBytes: 0)
        increaseCapacity(size: 4)
        cursor += 4 // Will be set to vtable offset afterwards
        
        let vtableloc = cursor
        
        // vtable is stored as relative offset for object data
        var index = currentVTable.count - 1
        while(index>=0) {
            // Offset relative to the start of the table.
            let off = Int16(currentVTable[index] != 0 ? Int32(vtableloc) - currentVTable[index] : 0);
            put(value: off);
            index -= 1
        }
        
        let numberOfstandardFields = 2
        
        put(value: Int16(Int32(vtableloc) - objectStart)); // standard field 1: lenght of the object data
        put(value: Int16((currentVTable.count + numberOfstandardFields) * MemoryLayout<Int16>.stride)); // standard field 2: length of vtable and standard fields them selves
        
        // search if we already have same vtable
        let vtableDataLength = cursor - vtableloc
        
        var foundVTableOffset = vtableDataLength
        
        if config.uniqueVTables{
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
        
        put(value: Int32(foundVTableOffset), at: indexLocation)
        
        objectStart = -1
        
        return Offset(vtableloc)
    }
    
    public func startVector(count : Int, elementSize : Int) throws{
        align(size: 4, additionalBytes: count * elementSize)
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FBBuildError.objectIsNotClosed
        }
        vectorNumElems = Int32(count)
    }
    
    public func endVector() -> Offset {
        put(value: vectorNumElems)
        vectorNumElems = -1
        return Int32(cursor)
    }
    
    private var stringCache : [String:Offset] = [:]
    public func createString(value : String?) throws -> Offset {
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FBBuildError.objectIsNotClosed
        }
        guard let value = value else {
            return 0
        }
        
        if config.uniqueStrings{
            if let o = stringCache[value]{
                return o
            }
        }
        // TODO: Performance Test
        if config.nullTerminatedUTF8 {
            let utf8View = value.utf8CString
            let length = utf8View.count
            align(size: 4, additionalBytes: length)
            increaseCapacity(size: length)
            for c in utf8View.lazy.reversed() {
                put(value: c)
            }
            put(value: Int32(length - 1))
        } else {
            let utf8View = value.utf8
            let length = utf8View.count
            align(size: 4, additionalBytes: length)
            increaseCapacity(size: length)
            for c in utf8View.lazy.reversed() {
                put(value: c)
            }
            put(value: Int32(length))
        }
        
        let o = Offset(cursor)
        if config.uniqueStrings {
            stringCache[value] = o
        }
        return o
    }
    
    public func finish(offset : Offset, fileIdentifier : String?) throws -> Void {
        guard offset <= Int32(cursor) else {
            throw FBBuildError.offsetIsTooBig
        }
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FBBuildError.objectIsNotClosed
        }
        var prefixLength = 4
        if let fileIdentifier = fileIdentifier {
            prefixLength += 4
            align(size: minalign, additionalBytes: prefixLength)
            let utf8View = fileIdentifier.utf8
            let count = utf8View.count
            guard count == 4 else {
                throw FBBuildError.badFileIdentifier
            }
            for c in utf8View.lazy.reversed() {
                put(value: c)
            }
        } else {
            align(size: minalign, additionalBytes: prefixLength)
        }
        
        let v = (Int32(cursor + 4) - offset)
        
        put(value: v)
    }
}
