//
//  bench_direct_access.swift
//  FlatBuffersSwift
//
//  Created by Maxim Zaks on 09.05.16.
//  Copyright © 2016 maxim.zaks. All rights reserved.
//

import Foundation

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
func getSiblingFrom(buffer : UnsafePointer<UInt8>, fooBarOffset : Offset) -> Bar {
    let result : Bar = get(buffer, fooBarOffset, propertyIndex: 0)!
    return result
}
func getNameFrom(buffer : UnsafePointer<UInt8>, fooBarOffset : Offset) -> UnsafeBufferPointer<UInt8> {
    return getStringBuffer(buffer, getOffset(buffer, fooBarOffset, propertyIndex: 1))!
}
func getRatingFrom(buffer : UnsafePointer<UInt8>, fooBarOffset : Offset) -> Float64 {
    let result : Float64 = get(buffer, fooBarOffset, propertyIndex: 2)!
    return result
}
func getPostfixFrom(buffer : UnsafePointer<UInt8>, fooBarOffset : Offset) -> UInt8 {
    let result : UInt8 = get(buffer, fooBarOffset, propertyIndex: 3)!
    return result
}