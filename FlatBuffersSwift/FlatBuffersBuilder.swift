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
    case couldNotPerformLateBinding
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
    public var deferedBindings : ContiguousArray<(object:AnyObject, cursor:Int)> = []

    /**
     Initializes the builder

     - parameters:
     - options: The options to use for this builder.

     - Returns: A FlatBuffers builder ready for use.
     */
    public init(options _options : FlatBuffersBuilderOptions = FlatBuffersBuilderOptions()) {
        self.options = _options
        self.capacity = self.options.initialCapacity
        _data = UnsafeMutableRawPointer.allocate(byteCount: capacity, alignment: minalign)
    }

    deinit {
        _data.deallocate()
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
        while leftCursor <= size {
            capacity = capacity << 1
        }

        let newData = UnsafeMutableRawPointer.allocate(byteCount: capacity, alignment: minalign)
        newData.advanced(by:leftCursor).copyMemory(from: _data.advanced(by: _leftCursor), byteCount: cursor)
        _data.deallocate()
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

     - Returns: The current cursor position, cursor is used to replace the value later (e.g. during late binding phase).
     */
    @discardableResult
    public func insert(offset : Offset, toStartedObjectAt propertyIndex : Int) throws -> Int {
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

     - Returns: The current cursor position, cursor is used to replace the value later.
     */
    @discardableResult
    public func insert<T : Scalar>(value : T, defaultValue : T, toStartedObjectAt propertyIndex : Int) throws -> Int? {
        guard objectStart > -1 else {
            throw FlatBuffersBuildError.noOpenObject
        }
        guard propertyIndex >= 0 && propertyIndex < currentVTable.count else {
            throw FlatBuffersBuildError.propertyIndexIsInvalid
        }

        if(options.forceDefaults == false && value == defaultValue) {
            // The value was not added, so there is no cursor for late replacements.
            return nil
        }

        insert(value: value)
        currentVTable[propertyIndex] = Int32(cursor)

        return cursor
    }

    /**
     Add the current cursor position into the buffer for the currently open object

     - parameters:
     - propertyIndex: The index of the property to update
     - Returns: The current cursor position, cursor is used to replace the value later.
     */
    @discardableResult
    public func insertCurrentOffsetAsProperty(toStartedObjectAt propertyIndex : Int) throws -> Int {
        guard objectStart > -1 else {
            throw FlatBuffersBuildError.noOpenObject
        }
        guard propertyIndex >= 0 && propertyIndex < currentVTable.count else {
            throw FlatBuffersBuildError.propertyIndexIsInvalid
        }
        currentVTable[propertyIndex] = Int32(cursor)

        return cursor
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
