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
    case BadFileIdentifier
    case UnsupportedType
}

public class FlatBufferBuilder {
    var capacity : Int
    private var _data : UnsafeMutablePointer<UInt8>
    var data : [UInt8] {
        return Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(_data).advancedBy(leftCursor), count: cursor))
    }
    var cursor = 0
    var leftCursor : Int {
        return capacity - cursor
    }
    
    var currentVTable : [Int32] = []
    var objectStart : Int32 = -1
    var vectorNumElems : Int32 = -1;
    var vTableOffsets : [Int32] = []
    
    public init(capacity : Int = 1){
        self.capacity = capacity
        _data = UnsafeMutablePointer.alloc(capacity)
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
        _data.destroy(_capacity)
        _data = newData
    }
    
    public func put<T : Scalar>(value : T){
        var v = value.littleEndian
        let c = strideofValue(v)
        increaseCapacity(c)
        withUnsafePointer(&v){
            _data.advancedBy(leftCursor-c).initializeFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
        cursor += c
    }
    
    public func putOffset(offset : Offset?) throws {
        guard let offset = offset else {
            return put(Int32(0))
        }
        guard offset.value <= Int32(cursor) else {
            throw FlatBufferBuilderError.OffsetIsTooBig
        }
        let _offset = Int32(cursor) - offset.value + strideof(Int32);
        put(_offset)
    }
    
    private func put<T : Scalar>(value : T, at index : Int){
        var v = value.littleEndian
        let c = strideofValue(v)
        withUnsafePointer(&v){
            _data.advancedBy(index + leftCursor).initializeFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
    }
    
    public func openObject(numOfProperties : Int) throws {
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBufferBuilderError.ObjectIsNotClosed
        }
        currentVTable = Array<Int32>(count: numOfProperties, repeatedValue: 0)
        objectStart = Int32(cursor)
    }
    
    public func addPropertyOffsetToOpenObject(propertyIndex : Int, offset : Offset) throws {
        guard objectStart > -1 else {
            throw FlatBufferBuilderError.NoOpenObject
        }
        guard propertyIndex >= 0 && propertyIndex < currentVTable.count else {
            throw FlatBufferBuilderError.PropertyIndexIsInvalid
        }
        try putOffset(offset)
        currentVTable[propertyIndex] = Int32(cursor)
    }
    
    public func addPropertyToOpenObject<T : Scalar>(propertyIndex : Int, value : T, defaultValue : T) throws {
        guard objectStart > -1 else {
            throw FlatBufferBuilderError.NoOpenObject
        }
        guard propertyIndex >= 0 && propertyIndex < currentVTable.count else {
            throw FlatBufferBuilderError.PropertyIndexIsInvalid
        }
        
        if(value == defaultValue) {
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
    
    public func closeObject() throws -> ObjectOffset {
        guard objectStart > -1 else {
            throw FlatBufferBuilderError.NoOpenObject
        }
        
        put(0 as Int32) // Will be set to vtable offset afterwards
        
        let vtableloc = cursor
        
        // vtable is stored as relative offset for object data
        for var index = currentVTable.count - 1; index >= 0; index-- {
            // Offset relative to the start of the table.
            let off = Int16(currentVTable[index] != 0 ? Int32(vtableloc) - currentVTable[index] : 0);
            put(off);
        }
        
        let numberOfstandardFields = 2
        
        put(Int16(Int32(vtableloc) - objectStart)); // standard field 1: lenght of the object data
        put(Int16((currentVTable.count + numberOfstandardFields) * strideof(Int16))); // standard field 2: length of vtable and standard fields them selves
        
        // search if we already have same vtable
        let vtableDataLength = cursor - vtableloc
        
        var foundVTableOffset = vtableDataLength

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
        
        let indexLocation = cursor - vtableloc
        
        put(Int32(foundVTableOffset), at: indexLocation)
        
        objectStart = -1
        
        return ObjectOffset(vtableloc)
    }
    
    public func startVector(count : Int) throws{
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBufferBuilderError.ObjectIsNotClosed
        }
        vectorNumElems = Int32(count)
    }
    
    public func endVector() -> VectorOffset {
        put(vectorNumElems)
        vectorNumElems = -1
        return VectorOffset(cursor)
    }
    
    var stringCache : [String:StringOffset] = [:]
    
    public func createString(value : String?) throws -> StringOffset {
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBufferBuilderError.ObjectIsNotClosed
        }
        guard let value = value else {
            return StringOffset(0)
        }
        if let result = stringCache[value]{
            return result
        }

        let buf = value.utf8
        let length = buf.count
        increaseCapacity(length)
        _data.advancedBy(leftCursor-length).initializeFrom(buf)
        cursor += length

        put(Int32(length))
        let result = StringOffset(cursor)
        stringCache[value] = result
        return result
    }
    
    public func finish(offset : ObjectOffset, fileIdentifier : String?) throws -> [UInt8] {
        guard offset.value <= Int32(cursor) else {
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
        
        var v = (Int32(cursor + prefixLength) - offset.value).littleEndian
        let c = strideofValue(v)
        withUnsafePointer(&v){
            _data.advancedBy(leftCursor - prefixLength).initializeFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
        
        return Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(_data).advancedBy(leftCursor - prefixLength), count: cursor+prefixLength))
    }
}