//
//  bench_direct_access.swift
//  FlatBuffersSwift
//
//  Created by Maxim Zaks on 09.05.16.
//  Copyright © 2016 maxim.zaks. All rights reserved.
//

import Foundation

//public final class FlatBufferReaderFast{
//    
//    public static func fromByteArray<T : Scalar>(buffer : UnsafePointer<UInt8>, _ position : Int) -> T{
//        return UnsafePointer<T>(buffer.advancedBy(position)).memory
//    }
//    
//    public static func getPropertyOffset(buffer : UnsafePointer<UInt8>, _ objectOffset : Offset, propertyIndex : Int)->Int {
//        let offset = Int(objectOffset)
//        let localOffset : Int32 = fromByteArray(buffer, offset)
//        let vTableOffset : Int = offset - Int(localOffset)
//        let vTableLength : Int16 = fromByteArray(buffer, vTableOffset)
//        if(vTableLength<=Int16(4 + propertyIndex * 2)) {
//            return 0
//        }
//        let propertyStart = vTableOffset + 4 + (2 * propertyIndex)
//        
//        let propertyOffset : Int16 = fromByteArray(buffer, propertyStart)
//        return Int(propertyOffset)
//    }
//    
//    public static func getOffset(buffer : UnsafePointer<UInt8>, _ objectOffset : Offset, propertyIndex : Int) -> Offset?{
//        let propertyOffset = getPropertyOffset(buffer, objectOffset, propertyIndex: propertyIndex)
//        if propertyOffset == 0 {
//            return nil
//        }
//        let position = objectOffset + propertyOffset
//        let localObjectOffset : Int32 = fromByteArray(buffer, Int(position))
//        let offset = position + localObjectOffset
//        
//        if localObjectOffset == 0 {
//            return nil
//        }
//        return offset
//    }
//    
//    public static func getVectorLength(buffer : UnsafePointer<UInt8>, _ vectorOffset : Offset?) -> Int {
//        guard let vectorOffset = vectorOffset else {
//            return 0
//        }
//        let vectorPosition = Int(vectorOffset)
//        let length2 : Int32 = fromByteArray(buffer, vectorPosition)
//        return Int(length2)
//    }
//    
//    public static func getVectorOffsetElement(buffer : UnsafePointer<UInt8>, _ vectorOffset : Offset, index : Int) -> Offset? {
//        let valueStartPosition = Int(vectorOffset + strideof(Int32) + (index * strideof(Int32)))
//        let localOffset : Int32 = fromByteArray(buffer, valueStartPosition)
//        if(localOffset == 0){
//            return nil
//        }
//        return localOffset + valueStartPosition
//    }
//    
//    public static func getVectorScalarElement<T : Scalar>(buffer : UnsafePointer<UInt8>, _ vectorOffset : Offset, index : Int) -> T {
//        let valueStartPosition = Int(vectorOffset + strideof(Int32) + (index * strideof(T)))
//        return UnsafePointer<T>(UnsafePointer<UInt8>(buffer).advancedBy(valueStartPosition)).memory
//    }
//    
//    public static func get<T : Scalar>(buffer : UnsafePointer<UInt8>, _ objectOffset : Offset, propertyIndex : Int, defaultValue : T) -> T{
//        let propertyOffset = getPropertyOffset(buffer, objectOffset, propertyIndex: propertyIndex)
//        if propertyOffset == 0 {
//            return defaultValue
//        }
//        let position = Int(objectOffset + propertyOffset)
//        return fromByteArray(buffer, position)
//    }
//    
//    public static func get<T : Scalar>(buffer : UnsafePointer<UInt8>, _ objectOffset : Offset, propertyIndex : Int) -> T?{
//        let propertyOffset = getPropertyOffset(buffer, objectOffset, propertyIndex: propertyIndex)
//        if propertyOffset == 0 {
//            return nil
//        }
//        let position = Int(objectOffset + propertyOffset)
//        return fromByteArray(buffer, position) as T
//    }
//    
//    public static func getStringBuffer(buffer : UnsafePointer<UInt8>, _ stringOffset : Offset?) -> UnsafeBufferPointer<UInt8>? {
//        guard let stringOffset = stringOffset else {
//            return nil
//        }
//        let stringPosition = Int(stringOffset)
//        let stringLength : Int32 = fromByteArray(buffer, stringPosition)
//        let pointer = UnsafePointer<UInt8>(buffer).advancedBy((stringPosition + strideof(Int32)))
//        return UnsafeBufferPointer<UInt8>.init(start: pointer, count: Int(stringLength))
//    }
//    
//    public static func getString(buffer : UnsafePointer<UInt8>, _ stringOffset : Offset?) -> String? {
//        guard let stringOffset = stringOffset else {
//            return nil
//        }
//        let stringPosition = Int(stringOffset)
//        let stringLength : Int32 = fromByteArray(buffer, stringPosition)
//        
//        let pointer = UnsafeMutablePointer<UInt8>(buffer).advancedBy((stringPosition + strideof(Int32)))
//        let result = String.init(bytesNoCopy: pointer, length: Int(stringLength), encoding: NSUTF8StringEncoding, freeWhenDone: false)
//        
//        return result
//    }
//    
//    public static func set<T : Scalar>(buffer : UnsafeMutablePointer<UInt8>, _ objectOffset : Offset, propertyIndex : Int, value : T) throws {
//        let propertyOffset = getPropertyOffset(buffer, objectOffset, propertyIndex: propertyIndex)
//        if propertyOffset == 0 {
//            throw FlatBufferReaderError.CanOnlySetNonDefaultProperty
//        }
//        var v = value
//        let position = Int(objectOffset + propertyOffset)
//        let c = strideofValue(v)
//        withUnsafePointer(&v){
//            buffer.advancedBy(position).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
//        }
//    }
//    
//    public static func setVectorScalarElement<T : Scalar>(buffer : UnsafeMutablePointer<UInt8>, _ vectorOffset : Offset, index : Int, value : T) {
//        let valueStartPosition = Int(vectorOffset + strideof(Int32) + (index * strideof(T)))
//        var v = value
//        let c = strideofValue(v)
//        withUnsafePointer(&v){
//            buffer.advancedBy(valueStartPosition).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
//        }
//    }
//    
//}

private func fromByteArray<T : Scalar>(buffer : UnsafePointer<UInt8>, _ position : Int) -> T{
    return UnsafePointer<T>(buffer.advancedBy(position)).memory
}

private func getPropertyOffset(buffer : UnsafePointer<UInt8>, _ objectOffset : Offset, propertyIndex : Int)->Int {
    let offset = Int(objectOffset)
    let localOffset : Int32 = fromByteArray(buffer, offset)
    let vTableOffset : Int = offset - Int(localOffset)
    let vTableLength : Int16 = fromByteArray(buffer, vTableOffset)
    if(vTableLength<=Int16(4 + propertyIndex * 2)) {
        return 0
    }
    let propertyStart = vTableOffset + 4 + (2 * propertyIndex)
    
    let propertyOffset : Int16 = fromByteArray(buffer, propertyStart)
    return Int(propertyOffset)
}

private func getOffset(buffer : UnsafePointer<UInt8>, _ objectOffset : Offset, propertyIndex : Int) -> Offset?{
    let propertyOffset = getPropertyOffset(buffer, objectOffset, propertyIndex: propertyIndex)
    if propertyOffset == 0 {
        return nil
    }
    let position = objectOffset + propertyOffset
    let localObjectOffset : Int32 = fromByteArray(buffer, Int(position))
    let offset = position + localObjectOffset
    
    if localObjectOffset == 0 {
        return nil
    }
    return offset
}

private func getVectorLength(buffer : UnsafePointer<UInt8>, _ vectorOffset : Offset?) -> Int {
    guard let vectorOffset = vectorOffset else {
        return 0
    }
    let vectorPosition = Int(vectorOffset)
    let length2 : Int32 = fromByteArray(buffer, vectorPosition)
    return Int(length2)
}

private func getVectorOffsetElement(buffer : UnsafePointer<UInt8>, _ vectorOffset : Offset, index : Int) -> Offset? {
    let valueStartPosition = Int(vectorOffset + strideof(Int32) + (index * strideof(Int32)))
    let localOffset : Int32 = fromByteArray(buffer, valueStartPosition)
    if(localOffset == 0){
        return nil
    }
    return localOffset + valueStartPosition
}

private func getVectorScalarElement<T : Scalar>(buffer : UnsafePointer<UInt8>, _ vectorOffset : Offset, index : Int) -> T {
    let valueStartPosition = Int(vectorOffset + strideof(Int32) + (index * strideof(T)))
    return UnsafePointer<T>(UnsafePointer<UInt8>(buffer).advancedBy(valueStartPosition)).memory
}

private func get<T : Scalar>(buffer : UnsafePointer<UInt8>, _ objectOffset : Offset, propertyIndex : Int, defaultValue : T) -> T{
    let propertyOffset = getPropertyOffset(buffer, objectOffset, propertyIndex: propertyIndex)
    if propertyOffset == 0 {
        return defaultValue
    }
    let position = Int(objectOffset + propertyOffset)
    return fromByteArray(buffer, position)
}

private func get<T : Scalar>(buffer : UnsafePointer<UInt8>, _ objectOffset : Offset, propertyIndex : Int) -> T?{
    let propertyOffset = getPropertyOffset(buffer, objectOffset, propertyIndex: propertyIndex)
    if propertyOffset == 0 {
        return nil
    }
    let position = Int(objectOffset + propertyOffset)
    return fromByteArray(buffer, position) as T
}

private func getStringBuffer(buffer : UnsafePointer<UInt8>, _ stringOffset : Offset?) -> UnsafeBufferPointer<UInt8>? {
    guard let stringOffset = stringOffset else {
        return nil
    }
    let stringPosition = Int(stringOffset)
    let stringLength : Int32 = fromByteArray(buffer, stringPosition)
    let pointer = UnsafePointer<UInt8>(buffer).advancedBy((stringPosition + strideof(Int32)))
    return UnsafeBufferPointer<UInt8>.init(start: pointer, count: Int(stringLength))
}

private func getString(buffer : UnsafePointer<UInt8>, _ stringOffset : Offset?) -> String? {
    guard let stringOffset = stringOffset else {
        return nil
    }
    let stringPosition = Int(stringOffset)
    let stringLength : Int32 = fromByteArray(buffer, stringPosition)
    
    let pointer = UnsafeMutablePointer<UInt8>(buffer).advancedBy((stringPosition + strideof(Int32)))
    let result = String.init(bytesNoCopy: pointer, length: Int(stringLength), encoding: NSUTF8StringEncoding, freeWhenDone: false)
    
    return result
}

private func set<T : Scalar>(buffer : UnsafeMutablePointer<UInt8>, _ objectOffset : Offset, propertyIndex : Int, value : T) throws {
    let propertyOffset = getPropertyOffset(buffer, objectOffset, propertyIndex: propertyIndex)
    if propertyOffset == 0 {
        throw FlatBufferReaderError.CanOnlySetNonDefaultProperty
    }
    var v = value
    let position = Int(objectOffset + propertyOffset)
    let c = strideofValue(v)
    withUnsafePointer(&v){
        buffer.advancedBy(position).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
    }
}

private func setVectorScalarElement<T : Scalar>(buffer : UnsafeMutablePointer<UInt8>, _ vectorOffset : Offset, index : Int, value : T) {
    let valueStartPosition = Int(vectorOffset + strideof(Int32) + (index * strideof(T)))
    var v = value
    let c = strideofValue(v)
    withUnsafePointer(&v){
        buffer.advancedBy(valueStartPosition).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
    }
}





func getFooBarContainerRootOffset(buffer : UnsafePointer<UInt8>) -> Offset {
    return UnsafePointer<Offset>(buffer.advancedBy(0)).memory
}

func getListCountFrom(buffer : UnsafePointer<UInt8>, fooBarContainerOffset : Offset) -> Int {
    let offset_list : Offset? = getOffset(buffer, fooBarContainerOffset, propertyIndex: 0)
    return getVectorLength(buffer, offset_list)
}

func getFooBarOffsetFrom(buffer : UnsafePointer<UInt8>, fooBarContainerOffset : Offset, listIndex : Int) -> Offset {
    let offset_list : Offset? = getOffset(buffer, fooBarContainerOffset, propertyIndex: 0)
    return getVectorOffsetElement(buffer, offset_list!, index: listIndex)!
}

func getInitializedFrom(buffer : UnsafePointer<UInt8>, fooBarContainerOffset : Offset) -> Bool {
    return get(buffer, fooBarContainerOffset, propertyIndex: 1, defaultValue: false)
}
func getFrootFrom(buffer : UnsafePointer<UInt8>, fooBarContainerOffset : Offset) -> Enum {
    return Enum(rawValue: get(buffer, fooBarContainerOffset, propertyIndex: 2, defaultValue: Enum.Apples.rawValue))!
}
func getLocationFrom(buffer : UnsafePointer<UInt8>, fooBarContainerOffset : Offset) -> UnsafeBufferPointer<UInt8> {
    return getStringBuffer(buffer, getOffset(buffer, fooBarContainerOffset, propertyIndex: 3))!
}
func getLocationFromS(buffer : UnsafePointer<UInt8>, fooBarContainerOffset : Offset) -> String {
    return getString(buffer, getOffset(buffer, fooBarContainerOffset, propertyIndex: 3))!
}

func getSiblingFrom(buffer : UnsafePointer<UInt8>, fooBarOffset : Offset) -> Bar {
    let result : Bar = get(buffer, fooBarOffset, propertyIndex: 0)!
    return result
}
func getNameFrom(buffer : UnsafePointer<UInt8>, fooBarOffset : Offset) -> UnsafeBufferPointer<UInt8> {
    return getStringBuffer(buffer, getOffset(buffer, fooBarOffset, propertyIndex: 1))!
}
func getNameFromS(buffer : UnsafePointer<UInt8>, fooBarOffset : Offset) -> String {
    return getString(buffer, getOffset(buffer, fooBarOffset, propertyIndex: 1))!
}
func getRatingFrom(buffer : UnsafePointer<UInt8>, fooBarOffset : Offset) -> Float64 {
    let result : Float64 = get(buffer, fooBarOffset, propertyIndex: 2)!
    return result
}
func getPostfixFrom(buffer : UnsafePointer<UInt8>, fooBarOffset : Offset) -> UInt8 {
    let result : UInt8 = get(buffer, fooBarOffset, propertyIndex: 3)!
    return result
}

// Showcase of using a struct interface

//struct FooBarStruct {
//    var buffer : UnsafePointer<UInt8> = nil
//    var myOffset : Offset = 0
//    var name: UnsafeBufferPointer<UInt8> { get { return getStringBuffer(buffer, getOffset(buffer, myOffset, propertyIndex: 1))! } }
//    var rating: Float64 { get { return get(buffer, myOffset, propertyIndex: 2)! } }
//    var postfix: UInt8 {  get { return get(buffer, myOffset, propertyIndex: 3)! } }
//    var sibling: Bar {  get { return get(buffer, myOffset, propertyIndex: 0)! } }
//}
//
//struct FooBarContainerStruct {
//    var buffer : UnsafePointer<UInt8> = nil
//    var myOffset : Offset = 0
//
//    init(_ data : UnsafePointer<UInt8>) {
//        self.buffer = data
//        self.myOffset = UnsafePointer<Offset>(buffer.advancedBy(0)).memory
//        self.list = ListStruct(buffer: buffer, myOffset: myOffset) // set up vector
//    }
//    
//    // table properties
//    var list : ListStruct?
//    var location: UnsafeBufferPointer<UInt8> { get { return getStringBuffer(buffer, getOffset(buffer, myOffset, propertyIndex: 3))! } }
//    var fruit: Enum {  get { return Enum(rawValue: get(buffer, myOffset, propertyIndex: 2, defaultValue: Enum.Apples.rawValue))! } }
//    var initialized: Bool {  get { return get(buffer, myOffset, propertyIndex: 1, defaultValue: false) } }
//
//    // definition of table vector to provice nice subscripting etc
//    struct ListStruct {
//        var buffer : UnsafePointer<UInt8> = nil
//        var myOffset : Offset = 0
//        let offsetList : Offset?
//        init?(buffer b: UnsafePointer<UInt8>, myOffset o: Offset )
//        {
//            buffer = b
//            myOffset = o
//            let _offsetList = getOffset(buffer, myOffset, propertyIndex: 0)
//            guard _offsetList != nil else {
//                return nil
//            }
//            offsetList = _offsetList
//        }
//        var count : Int { get { return getVectorLength(buffer, offsetList) } }
//        subscript (index : Int) -> FooBarStruct {
//            let ofs = getVectorOffsetElement(buffer, offsetList!, index: index)!
//            return FooBarStruct(buffer: buffer, myOffset: ofs)
//        }
//    }
//}

//extension FooBar {
//    public struct Fast : Hashable {
//        private var buffer : UnsafePointer<UInt8> = nil
//        private var myOffset : Offset = 0
//        public var sibling : Bar? { get { return FlatBufferReaderFast.get(buffer, myOffset, propertyIndex: 0) } }
//        public var name : UnsafeBufferPointer<UInt8>? { get { return FlatBufferReaderFast.getStringBuffer(buffer, getOffset(buffer, myOffset, propertyIndex:1)) } }
//        public var rating : Float64 {
//            get { return FlatBufferReaderFast.get(buffer, myOffset, propertyIndex: 2, defaultValue: 0) }
//            set { try!FlatBufferReaderFast.set(UnsafeMutablePointer<UInt8>(buffer), myOffset, propertyIndex: 2, value: newValue) }
//        }
//        public var postfix : UInt8 {
//            get { return FlatBufferReaderFast.get(buffer, myOffset, propertyIndex: 3, defaultValue: 0) }
//            set { try!FlatBufferReaderFast.set(UnsafeMutablePointer<UInt8>(buffer), myOffset, propertyIndex: 3, value: newValue) }
//        }
//        public var hashValue: Int { return Int(myOffset) }
//    }
//}
//public func ==(t1 : FooBar.Fast, t2 : FooBar.Fast) -> Bool {
//    return t1.buffer == t2.buffer && t1.myOffset == t2.myOffset
//}
//extension FooBarContainer {
//    public struct Fast : Hashable {
//        private var buffer : UnsafePointer<UInt8> = nil
//        private var myOffset : Offset = 0
//        public init(_ data : UnsafePointer<UInt8>) {
//            self.buffer = data
//            self.myOffset = UnsafePointer<Offset>(buffer.advancedBy(0)).memory
//        }
//        public func getData() -> UnsafePointer<UInt8> {
//            return buffer
//        }
//        public struct ListVector {
//            private var buffer : UnsafePointer<UInt8> = nil
//            private var myOffset : Offset = 0
//            private let offsetList : Offset?
//            private init(buffer b: UnsafePointer<UInt8>, myOffset o: Offset ) {
//                buffer = b
//                myOffset = o
//                offsetList = FlatBufferReaderFast.getOffset(buffer, myOffset, propertyIndex: 0)
//            }
//            public var count : Int { get { return getVectorLength(buffer, offsetList) } }
//            public subscript (index : Int) -> FooBar.Fast? {
//                get {
//                    if let ofs = FlatBufferReaderFast.getVectorOffsetElement(buffer, offsetList!, index: index) {
//                        return FooBar.Fast(buffer: buffer, myOffset: ofs)
//                    }
//                    return nil
//                }
//            }
//        }
//        public lazy var list : ListVector = ListVector(buffer: self.buffer, myOffset: self.myOffset)
//        public var initialized : Bool {
//            get { return FlatBufferReaderFast.get(buffer, myOffset, propertyIndex: 1, defaultValue: false) }
//            set { try!FlatBufferReaderFast.set(UnsafeMutablePointer<UInt8>(buffer), myOffset, propertyIndex: 1, value: newValue) }
//        }
//        public var fruit : Enum? { get { return Enum(rawValue: FlatBufferReaderFast.get(buffer, myOffset, propertyIndex: 2, defaultValue: Enum.Apples.rawValue)) } }
//        public var location : UnsafeBufferPointer<UInt8>? { get { return FlatBufferReaderFast.getStringBuffer(buffer, getOffset(buffer, myOffset, propertyIndex:3)) } }
//        public var hashValue: Int { return Int(myOffset) }
//    }
//}
//public func ==(t1 : FooBarContainer.Fast, t2 : FooBarContainer.Fast) -> Bool {
//    return t1.buffer == t2.buffer && t1.myOffset == t2.myOffset
//}