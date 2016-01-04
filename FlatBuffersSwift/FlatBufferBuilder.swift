//
//  FlatBufferBuilder.swift
//  SwiftFlatBuffers
//
//  Created by Maxim Zaks on 01.11.15.
//  Copyright © 2015 maxim.zaks. All rights reserved.
//


func toByteArray<T : Scalar>(var value: T) -> [UInt8] {
    return withUnsafePointer(&value) {
        Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>($0), count: strideof(T)))
    }
}


public enum FlatBufferBuilderError : ErrorType {
    case ObjectIsNotClosed
    case NoOpenObject
    case PropertyIndexIsInvalid
    case OffsetIsTooBig
    case BadFileIdentifier
    case UnsupportedType
}

public class FlatBufferBuilder {
    var data : [UInt8] = []
    
    var currentVTable : [Int32] = []
    var objectStart : Int32 = -1
    var vectorNumElems : Int32 = -1;
    var vTableOffsets : [Int32] = []
    
    public init(){}
    
    public func put<T : Scalar>(value : T){
        let valueAsBuffer = toByteArray(value.littleEndian)
        data.insertContentsOf(valueAsBuffer, at: 0)
    }
    
    public func putOffset(offset : Offset?) throws {
        guard let offset = offset else {
            return put(Int32(0))
        }
        guard offset.value <= Int32(data.count) else {
            throw FlatBufferBuilderError.OffsetIsTooBig
        }
        let _offset = Int32(data.count) - offset.value + strideof(Int32);
        put(_offset)
    }
    
    public func put<T : Scalar>(value : T, at index : Int){
        let valueAsBuffer = toByteArray(value.littleEndian)
        data.replaceRange(Range(start: index, end: index + valueAsBuffer.count), with: valueAsBuffer)
    }
    
    public func openObject(numOfProperties : Int) throws {
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBufferBuilderError.ObjectIsNotClosed
        }
        currentVTable = Array<Int32>(count: numOfProperties, repeatedValue: 0)
        objectStart = Int32(data.count)
    }
    
    public func addPropertyOffsetToOpenObject(propertyIndex : Int, offset : Offset) throws {
        guard objectStart > -1 else {
            throw FlatBufferBuilderError.NoOpenObject
        }
        guard propertyIndex >= 0 && propertyIndex < currentVTable.count else {
            throw FlatBufferBuilderError.PropertyIndexIsInvalid
        }
        try putOffset(offset)
        currentVTable[propertyIndex] = Int32(data.count)
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
        currentVTable[propertyIndex] = Int32(data.count)
    }
    
    public func closeObject() throws -> ObjectOffset {
        guard objectStart > -1 else {
            throw FlatBufferBuilderError.NoOpenObject
        }
        
        put(0 as Int32) // Will be set to vtable offset afterwards
        
        let vtableloc = data.count
        
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
        let vtableDataLength = data.count - vtableloc
        let vtableData1 = data[0..<vtableDataLength]
        
        var foundVTableOffset = vtableDataLength
        
        for otherVTableOffset in vTableOffsets {
            let start = data.count - Int(otherVTableOffset)
            let vtableData2 = data[start ..< (start + vtableDataLength)]
            if vtableData1 == vtableData2 {
                foundVTableOffset = Int(otherVTableOffset) - vtableloc
                break;
            }
        }
        
        if foundVTableOffset != vtableDataLength {
            data.removeFirst(vtableDataLength)
        } else {
            vTableOffsets.append(Int32(data.count))
        }
        
        let indexLocation = data.count - vtableloc
        
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
        return VectorOffset(data.count)
    }
    
    public func createString(value : String) throws -> StringOffset {
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBufferBuilderError.ObjectIsNotClosed
        }
        let buf = [UInt8](value.utf8)
        let length = buf.count
        data.insertContentsOf(buf, at: 0)
        put(Int32(length))
        return StringOffset(data.count)
    }
    
    public func finish(offset : ObjectOffset, fileIdentifier : String?) throws -> [UInt8] {
        var result = data
        guard offset.value <= Int32(result.count) else {
            throw FlatBufferBuilderError.OffsetIsTooBig
        }
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBufferBuilderError.ObjectIsNotClosed
        }
        
        if let fileIdentifier = fileIdentifier {
            let buf = [UInt8](fileIdentifier.utf8)
            guard buf.count == 4 else {
                throw FlatBufferBuilderError.BadFileIdentifier
            }
            result.insertContentsOf(buf, at: 0)
        }
        
        let _offset = Int32(result.count) - offset.value + strideof(Int32);
        let valueAsBuffer = toByteArray(_offset.littleEndian)
        result.insertContentsOf(valueAsBuffer, at: 0)
        return result
    }
}