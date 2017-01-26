//
//  BuilderTest.swift
//  FBSwift3
//
//  Created by Maxim Zaks on 27.10.16.
//  Copyright © 2016 Maxim Zaks. All rights reserved.
//

import XCTest
@testable import FlatBuffersSwift

class BuilderTest: XCTestCase {
    
    var builder : FlatBuffersBuilder!
    var byteIndex = 0
    
    override func setUp() {
        super.setUp()
        builder = FlatBuffersBuilder(options: FlatBuffersBuilderOptions())
        byteIndex = 0
    }
    
    override func tearDown() {
        XCTAssertEqual(builder.makeData.count, byteIndex)
        super.tearDown()
    }
    
    func testPutOneBytePrimitives() {
        builder.insert(value: true)
        builder.insert(value: false)
        builder.insert(value: Int8(-12))
        builder.insert(value: Int8(12))
        builder.insert(value: UInt8(13))
        
        assertByte(with: 13)
        assertByte(with: 12)
        assertByte(with: 244)
        assertByte(with: 0)
        assertByte(with: 1)
    }
    
    func testPutTwoBytePrimitives() {
        builder.insert(value: Int16(-12))
        builder.insert(value: Int16(12))
        builder.insert(value: UInt16(13))
        
        assertByte(with: 13)
        assertByte(with: 0)
        assertByte(with: 12)
        assertByte(with: 0)
        assertByte(with: 244)
        assertByte(with: 255)
    }
    
    func testPutFourBytePrimitives() {
        builder.insert(value: Int32(-12))
        builder.insert(value: Int32(12))
        builder.insert(value: UInt32(13))
        
        assertByte(with: 13)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 12)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 244)
        assertByte(with: 255)
        assertByte(with: 255)
        assertByte(with: 255)
        
    }
    
    func testPutEightBytePrimitives() {
        builder.insert(value: Int(-12))
        builder.insert(value: Int(12))
        builder.insert(value: UInt(13))
        
        assertByte(with: 13)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 12)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 244)
        assertByte(with: 255)
        assertByte(with: 255)
        assertByte(with: 255)
        assertByte(with: 255)
        assertByte(with: 255)
        assertByte(with: 255)
        assertByte(with: 255)
    }
    
    func testPutFourByteFloat() {
        builder.insert(value: Float32(12.5))
        builder.insert(value: Float32(-12.5))
        
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 72)
        assertByte(with: 193)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 72)
        assertByte(with: 65)
        
    }
    
    func testPutEightByteFloat() {
        builder.insert(value: Float64(12.5))
        builder.insert(value: Float64(-12.5))
        
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 41)
        assertByte(with: 192)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 41)
        assertByte(with: 64)
    }
    
    func testPutStruct() {
        builder.insert(value: S1(i1: 9999, i2: 13))
        
        assertByte(with: 15)
        assertByte(with: 39)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 13)
        skipBytes(count: 7)
    }
    
    func testPrimitiveAlingment() {
        builder.insert(value: true)
        builder.insert(value: Int32(16))
        builder.insert(value: Int16(7))
        builder.insert(value: Int16(8))
        builder.insert(value: Int(15))
        builder.insert(value: Float32(2.5))
        builder.insert(value: Float32(3.5))
        
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 96)
        assertByte(with: 64)//3.5
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 32)
        assertByte(with: 64)//2.5
        assertByte(with: 15)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        
        skipBytes(count: 4)
        
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 7)
        assertByte(with: 0)
        assertByte(with: 16)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        
        skipBytes(count: 3)
        
        assertByte(with: 1)
    }
    
    func testAlignmentWithStruct(){
        builder.insert(value: Int16(45))
        builder.insert(value: S1(i1: 9999, i2: 11))
        
        
        assertByte(with: 15)
        assertByte(with: 39)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)  // i1 = 9999
        assertByte(with: 11) // i2 = 11
        
        skipBytes(count: 13)
        
        assertByte(with: 45)
        assertByte(with: 0)
    }
    
    func testString(){
        let o = try!builder.insert(value: "maxim")
        
        XCTAssertEqual(o, 12)
        
        assertByte(with: 5)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 109)
        assertByte(with: 97)
        assertByte(with: 120)
        assertByte(with: 105)
        assertByte(with: 109)
        skipBytes(count: 3)
    }
    
    func testNullTerminatedString(){
        
        builder = FlatBuffersBuilder(options: FlatBuffersBuilderOptions(initialCapacity: 1, uniqueStrings: true, uniqueTables: true, uniqueVTables: true, forceDefaults: false, nullTerminatedUTF8: true))
        
        let o = try!builder.insert(value: "maxim")
        
        XCTAssertEqual(o, 12)
        
        assertByte(with: 5)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 109)
        assertByte(with: 97)
        assertByte(with: 120)
        assertByte(with: 105)
        assertByte(with: 109)
        assertByte(with: 0)
        skipBytes(count: 2)
    }
    
    func testStringWithPrimitives(){
        builder.insert(value: Int16(25))
        let o = try!builder.insert(value: "maxim")
        
        
        XCTAssertEqual(o, 12)
        
        assertByte(with: 5)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 109)
        assertByte(with: 97)
        assertByte(with: 120)
        assertByte(with: 105)
        assertByte(with: 109)
        
        skipBytes(count: 1)
        
        assertByte(with: 25)
        assertByte(with: 0)
    }
    
    func testStringWithPrimitivesAndFinish(){
        builder.insert(value: Int16(25))
        let o = try!builder.insert(value: "maxim")
        builder.insert(value: true)
        try!builder.finish(offset: o, fileIdentifier: nil)
        
        XCTAssertEqual(o, 12)
        
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        
        skipBytes(count: 3)
        
        assertByte(with: 1)
        
        assertByte(with: 5)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 109)
        assertByte(with: 97)
        assertByte(with: 120)
        assertByte(with: 105)
        assertByte(with: 109)
        
        skipBytes(count: 1)
        
        assertByte(with: 25)
        assertByte(with: 0)
    }
    
    func testStringWithPrimitivesAndFinishWithFileIdentifier(){
        builder.insert(value: Int16(25))
        let o = try!builder.insert(value: "maxim")
        builder.insert(value: true)
        try!builder.finish(offset: o, fileIdentifier: "test")
        
        XCTAssertEqual(o, 12)
        
        assertByte(with: 12)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 116)
        assertByte(with: 101)
        assertByte(with: 115)
        assertByte(with: 116)
        
        skipBytes(count: 3)
        
        assertByte(with: 1)
        
        assertByte(with: 5)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 109)
        assertByte(with: 97)
        assertByte(with: 120)
        assertByte(with: 105)
        assertByte(with: 109)
        
        skipBytes(count: 1)
        
        assertByte(with: 25)
        assertByte(with: 0)
    }
    
    func testObjectWithNameAndAge() {
        let s = try!builder.insert(value: "maxim")
        try!builder.startObject(withPropertyCount: 2)
        try!builder.insert(value: UInt8(35), defaultValue: 0, toStartedObjectAt: 1)
        try!builder.insert(offset: s, toStartedObjectAt: 0)
        let o = try!builder.endObject()
        try!builder.finish(offset: o, fileIdentifier: nil)
        
        assertByte(with: 12)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)// root offest
        assertByte(with: 8)
        assertByte(with: 0)// length of vTable
        assertByte(with: 12)
        assertByte(with: 0)// length of object
        assertByte(with: 4)
        assertByte(with: 0)// property 0 position
        assertByte(with: 11)
        assertByte(with: 0)// property 1 position
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)// vTable offset
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)// property 0 offset
        
        skipBytes(count: 3)
        
        assertByte(with: 35)// property 1 value
        assertByte(with: 5)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)// string length
        assertByte(with: 109)
        assertByte(with: 97)
        assertByte(with: 120)
        assertByte(with: 105)
        assertByte(with: 109)
        skipBytes(count: 3)
    }
    
    func testObjectWithNameReuseAndAge() {
        let s = try!builder.insert(value: "maxim")
        let s2 = try!builder.insert(value: "maxim")
        try!builder.startObject(withPropertyCount: 3)
        try!builder.insert(value: UInt8(35), defaultValue: 0, toStartedObjectAt: 1)
        try!builder.insert(offset: s, toStartedObjectAt: 0)
        try!builder.insert(offset: s2, toStartedObjectAt: 2)
        let o = try!builder.endObject()
        try!builder.finish(offset: o, fileIdentifier: nil)
        
        assertByte(with: 16)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)// root offest
        
        skipBytes(count: 2)
        
        assertByte(with: 10)
        assertByte(with: 0)// length of vTable
        assertByte(with: 16)
        assertByte(with: 0)// length of object
        assertByte(with: 8)
        assertByte(with: 0)// property 0 position
        assertByte(with: 15)
        assertByte(with: 0)// property 1 position
        assertByte(with: 4)
        assertByte(with: 0)// property 2 position
        assertByte(with: 10)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)// vTable offset
        assertByte(with: 12)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)// property 2 offset
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)// property 0 offset
        
        skipBytes(count: 3)
        
        assertByte(with: 35)// property 1 value
        assertByte(with: 5)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)// string length
        assertByte(with: 109)
        assertByte(with: 97)
        assertByte(with: 120)
        assertByte(with: 105)
        assertByte(with: 109)
        skipBytes(count: 3)
    }
    
    func testObjectWithoutNameReuseAndAge() {
        builder = FlatBuffersBuilder(options: FlatBuffersBuilderOptions(initialCapacity: 1, uniqueStrings: false, uniqueTables: true, uniqueVTables: true, forceDefaults: false, nullTerminatedUTF8: false))
        let s = try!builder.insert(value: "maxim")
        let s2 = try!builder.insert(value: "maxim")
        try!builder.startObject(withPropertyCount: 3)
        try!builder.insert(value: UInt8(35), defaultValue: 0, toStartedObjectAt:1)
        try!builder.insert(offset: s, toStartedObjectAt: 0)
        try!builder.insert(offset: s2, toStartedObjectAt: 2)
        let o = try!builder.endObject()
        try!builder.finish(offset: o, fileIdentifier: nil)
        
        assertByte(with: 16)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)// root offest
        
        skipBytes(count: 2)
        
        assertByte(with: 10)
        assertByte(with: 0)// length of vTable
        assertByte(with: 16)
        assertByte(with: 0)// length of object
        assertByte(with: 8)
        assertByte(with: 0)// property 0 position
        assertByte(with: 15)
        assertByte(with: 0)// property 1 position
        assertByte(with: 4)
        assertByte(with: 0)// property 2 position
        assertByte(with: 10)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)// vTable offset
        assertByte(with: 12)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)// property 2 offset
        assertByte(with: 20)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)// property 0 offset
        
        skipBytes(count: 3)
        
        assertByte(with: 35)// property 1 value
        assertByte(with: 5)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)// string length
        assertByte(with: 109)
        assertByte(with: 97)
        assertByte(with: 120)
        assertByte(with: 105)
        assertByte(with: 109)
        skipBytes(count: 3)
        
        assertByte(with: 5)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)// string length
        assertByte(with: 109)
        assertByte(with: 97)
        assertByte(with: 120)
        assertByte(with: 105)
        assertByte(with: 109)
        skipBytes(count: 3)
    }
    
    func testObjectWithNameAndAgeAndReferenceToSelf() {
        let s = try!builder.insert(value: "maxim")
        try!builder.startObject(withPropertyCount: 3)
        try!builder.insert(value: UInt8(35), defaultValue: 0, toStartedObjectAt: 1)
        try!builder.insert(offset: s, toStartedObjectAt: 0)
        let cursor = try!builder.insert(offset: 0, toStartedObjectAt: 2)
        let o = try!builder.endObject()
        try!builder.update(offset: o, atCursor: cursor)
        try!builder.finish(offset: o, fileIdentifier: nil)
        
        assertByte(with: 16)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)// root offest
        
        skipBytes(count: 2)
        
        assertByte(with: 10)
        assertByte(with: 0)// length of vTable
        assertByte(with: 16)
        assertByte(with: 0)// length of object
        assertByte(with: 8)
        assertByte(with: 0)// property 0 position
        assertByte(with: 15)
        assertByte(with: 0)// property 1 position
        assertByte(with: 4)
        assertByte(with: 0)// property 2 position
        assertByte(with: 10)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)// vTable offset
        assertByte(with: 252)
        assertByte(with: 255)
        assertByte(with: 255)
        assertByte(with: 255)// property 2 offset
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)// property 0 offset
        
        skipBytes(count: 3)
        
        assertByte(with: 35)// property 1 value
        assertByte(with: 5)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)// string length
        assertByte(with: 109)
        assertByte(with: 97)
        assertByte(with: 120)
        assertByte(with: 105)
        assertByte(with: 109)
        skipBytes(count: 3)
    }
    
    func testObjectWithStruct(){
        try!builder.startObject(withPropertyCount: 2)
        try!builder.insert(value: UInt8(35), defaultValue: 0, toStartedObjectAt:1)
        builder.insert(value: S1(i1: 45, i2: 78))
        try! builder.insertCurrentOffsetAsProperty(toStartedObjectAt: 0)
        let o = try!builder.endObject()
        try!builder.finish(offset: o, fileIdentifier: nil)
        
        assertByte(with: 12)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 28)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 27)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 45)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 78)
        skipBytes(count: 14)
        
        assertByte(with: 35)
    }
    
    func testObjectWithVectorOfInt16(){
        try!builder.startVector(count: 2, elementSize: 2)
        builder.insert(value: Int16(15))
        builder.insert(value: Int16(19))
        let v = builder.endVector()
        try!builder.startObject(withPropertyCount: 1)
        try! builder.insert(offset: v, toStartedObjectAt: 0)
        let o = try!builder.endObject()
        try!builder.finish(offset: o, fileIdentifier: nil)
        
        assertByte(with: 12)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        
        skipBytes(count: 2)
        
        assertByte(with: 6)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 6)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 2)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 19)
        assertByte(with: 0)
        assertByte(with: 15)
        assertByte(with: 0)
        
    }
    
    func testObjectWithVectorOfBoolean(){
        try!builder.startVector(count: 2, elementSize: 1)
        builder.insert(value: true)
        builder.insert(value: false)
        let v = builder.endVector()
        try!builder.startObject(withPropertyCount: 1)
        try! builder.insert(offset: v, toStartedObjectAt: 0)
        let o = try!builder.endObject()
        try!builder.finish(offset: o, fileIdentifier: nil)
        
        assertByte(with: 12)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        
        skipBytes(count: 2)
        
        assertByte(with: 6)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 6)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 2)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)//false
        assertByte(with: 1)//true
        
        skipBytes(count: 2)
    }
    
    func testObjectWithVectorOfStructs(){
        try!builder.startVector(count: 2, elementSize: 1)
        builder.insert(value: S1(i1: 12, i2: 19))
        builder.insert(value: S1(i1: 13, i2: 17))
        let v = builder.endVector()
        try!builder.startObject(withPropertyCount: 1)
        try! builder.insert(offset: v, toStartedObjectAt: 0)
        let o = try!builder.endObject()
        try!builder.finish(offset: o, fileIdentifier: nil)
        
        assertByte(with: 12)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        
        skipBytes(count: 2)
        
        assertByte(with: 6)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 6)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 2)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 13)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 17)
        
        skipBytes(count: 7)
        
        assertByte(with: 12)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 19)
        
        skipBytes(count: 7)
        
        skipBytes(count: 8) // TODO: it's not bad, but why is it necessary?
    }
    
    func testObjectWithVectorToOtherTwoObjects(){
        try!builder.startObject(withPropertyCount: 3)
        try!builder.insert(value: Int8(12), defaultValue: 0, toStartedObjectAt: 0)
        try!builder.insert(value: Int8(13), defaultValue: 0, toStartedObjectAt: 1)
        try!builder.insert(value: Int8(14), defaultValue: 0, toStartedObjectAt: 2)
        let o1 = try!builder.endObject()
        
        try!builder.startObject(withPropertyCount: 3)
        try!builder.insert(value: Int8(22), defaultValue: 0, toStartedObjectAt: 0)
        try!builder.insert(value: Int8(23), defaultValue: 0, toStartedObjectAt: 1)
        try!builder.insert(value: Int8(24), defaultValue: 0, toStartedObjectAt: 2)
        let o2 = try!builder.endObject()
        
        try!builder.startVector(count: 2, elementSize: 1)
        try!builder.insert(offset: o1)
        try!builder.insert(offset: o2)
        let v = builder.endVector()
        
        try!builder.startObject(withPropertyCount: 1)
        try! builder.insert(offset: v, toStartedObjectAt: 0)
        let o = try!builder.endObject()
        try!builder.finish(offset: o, fileIdentifier: nil)
        
        assertByte(with: 12)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        
        skipBytes(count: 2)
        
        assertByte(with: 6)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 6)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 2)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 20)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 36)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        
        skipBytes(count: 2)
        
        assertByte(with: 10)
        assertByte(with: 0)
        assertByte(with: 10)
        assertByte(with: 0)
        assertByte(with: 9)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 7)
        assertByte(with: 0)
        assertByte(with: 10)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        
        skipBytes(count: 3)
        
        assertByte(with: 24)
        assertByte(with: 23)
        assertByte(with: 22)
        assertByte(with: 10)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 7)
        assertByte(with: 0)
        assertByte(with: 6)
        assertByte(with: 0)
        assertByte(with: 5)
        assertByte(with: 0)
        assertByte(with: 10)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 14)
        assertByte(with: 13)
        assertByte(with: 12)
        
    }
    
    func testObjectWithVectorToOtherTwoObjectsAndVTableReuese(){
        try!builder.startObject(withPropertyCount: 2)
        try!builder.insert(value: Int16(12), defaultValue: 0, toStartedObjectAt: 0)
        try!builder.insert(value: Int16(13), defaultValue: 0, toStartedObjectAt: 1)
        let o1 = try!builder.endObject()
        
        try!builder.startObject(withPropertyCount: 2)
        try!builder.insert(value: Int16(22), defaultValue: 0, toStartedObjectAt: 0)
        try!builder.insert(value: Int16(23), defaultValue: 0, toStartedObjectAt: 1)
        let o2 = try!builder.endObject()
        
        try!builder.startVector(count: 2, elementSize: 1)
        try!builder.insert(offset: o1)
        try!builder.insert(offset: o2)
        let v = builder.endVector()
        
        try!builder.startObject(withPropertyCount: 1)
        try! builder.insert(offset: v, toStartedObjectAt: 0)
        let o = try!builder.endObject()
        try!builder.finish(offset: o, fileIdentifier: nil)
        
        assertByte(with: 12)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        
        skipBytes(count: 2)
        
        assertByte(with: 6)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 6)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 2)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 12)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 24)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        
        assertByte(with: 6)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 248)
        assertByte(with: 255)
        assertByte(with: 255)
        assertByte(with: 255)
        assertByte(with: 23)
        assertByte(with: 0)
        assertByte(with: 22)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 6)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 13)
        assertByte(with: 0)
        assertByte(with: 12)
        assertByte(with: 0)
    }
    
    func testObjectWithVectorToOtherTwoObjectsAndVTableWithoutReuese(){
        builder = FlatBuffersBuilder(options: FlatBuffersBuilderOptions(initialCapacity: 1, uniqueStrings: true, uniqueTables: true, uniqueVTables: false, forceDefaults: false, nullTerminatedUTF8: false))
        try!builder.startObject(withPropertyCount: 2)
        try!builder.insert(value: Int16(12), defaultValue: 0, toStartedObjectAt: 0)
        try!builder.insert(value: Int16(13), defaultValue: 0, toStartedObjectAt: 1)
        let o1 = try!builder.endObject()
        
        try!builder.startObject(withPropertyCount: 2)
        try!builder.insert(value: Int16(22), defaultValue: 0, toStartedObjectAt: 0)
        try!builder.insert(value: Int16(23), defaultValue: 0, toStartedObjectAt: 1)
        let o2 = try!builder.endObject()
        
        try!builder.startVector(count: 2, elementSize: 1)
        try!builder.insert(offset: o1)
        try!builder.insert(offset: o2)
        let v = builder.endVector()
        
        try!builder.startObject(withPropertyCount: 1)
        try! builder.insert(offset: v, toStartedObjectAt: 0)
        let o = try!builder.endObject()
        try!builder.finish(offset: o, fileIdentifier: nil)
        
        assertByte(with: 12)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        
        skipBytes(count: 2)
        
        assertByte(with: 6)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 6)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 2)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 20)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 32)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        
        //      assertByte(with: 1)
        //      assertByte(with: 0)
        //      assertByte(with: 0)
        //      assertByte(with: 0)
        skipBytes(count: 4)//TODO: Why?
        
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 6)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 23)
        assertByte(with: 0)
        assertByte(with: 22)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 6)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 13)
        assertByte(with: 0)
        assertByte(with: 12)
        assertByte(with: 0)
    }
    
    func testObjectWithVectorToSelf(){
        try!builder.startVector(count: 2, elementSize: 2)
        let c1 = try!builder.insert(offset: nil)
        let c2 = try!builder.insert(offset: nil)
        let v = builder.endVector()
        try!builder.startObject(withPropertyCount: 1)
        try! builder.insert(offset: v, toStartedObjectAt: 0)
        let o = try!builder.endObject()
        
        try!builder.update(offset: o, atCursor: c1)
        try!builder.update(offset: o, atCursor: c2)
        
        try!builder.finish(offset: o, fileIdentifier: nil)
        
        assertByte(with: 12)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        
        skipBytes(count: 2)
        
        assertByte(with: 6)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 6)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 2)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 244)
        assertByte(with: 255)
        assertByte(with: 255)
        assertByte(with: 255)
        assertByte(with: 240)
        assertByte(with: 255)
        assertByte(with: 255)
        assertByte(with: 255)
        
    }
    
    func testPutBadOffset(){
        var itThrows = false
        do {
            try builder.insert(offset: 12)
        } catch {
            itThrows = true
        }
        XCTAssert(itThrows)
    }
    
    func testReplaceWithBadOffset(){
        var itThrows = false
        do {
            try builder.update(offset: 12, atCursor: 0)
        } catch {
            itThrows = true
        }
        XCTAssert(itThrows)
    }
    
    func testReplaceWithBadCursor(){
        var itThrows = false
        do {
            try builder.update(offset: 0, atCursor: 12)
        } catch {
            itThrows = true
        }
        XCTAssert(itThrows)
    }
    
    func testOpenObjectWhileStillOpen(){
        var itThrows = false
        try!builder.startObject(withPropertyCount: 1)
        do {
            try builder.startObject(withPropertyCount: 1)
        } catch {
            itThrows = true
        }
        XCTAssert(itThrows)
    }
    
    func testAddPropertyWithoutOpenObject(){
        var itThrows = false
        do {
            try builder.insert(value: 1, defaultValue: 0, toStartedObjectAt: 0)
        } catch {
            itThrows = true
        }
        XCTAssert(itThrows)
    }
    
    func testAddPropertyWithoutBadIndex(){
        var itThrows = false
        try!builder.startObject(withPropertyCount: 1)
        do {
            try builder.insert(value: 1, defaultValue: 0, toStartedObjectAt: 1)
        } catch {
            itThrows = true
        }
        XCTAssert(itThrows)
    }
    
    func testAddOffsetWithoutOpenObject(){
        var itThrows = false
        do {
            try builder.insert(offset: 0, toStartedObjectAt: 0)
        } catch {
            itThrows = true
        }
        XCTAssert(itThrows)
    }
    
    func testAddOffsetWithoutBadIndex(){
        var itThrows = false
        try!builder.startObject(withPropertyCount: 1)
        do {
            try builder.insert(offset: 0, toStartedObjectAt: 1)
        } catch {
            itThrows = true
        }
        XCTAssert(itThrows)
    }
    
    func testAddCurrentOffsetWithoutOpenObject(){
        var itThrows = false
        do {
            try builder.insertCurrentOffsetAsProperty(toStartedObjectAt: 0)
        } catch {
            itThrows = true
        }
        XCTAssert(itThrows)
    }
    
    func testAddCurrentOffsetWithoutBadIndex(){
        var itThrows = false
        try!builder.startObject(withPropertyCount: 1)
        do {
            try builder.insertCurrentOffsetAsProperty(toStartedObjectAt: 1)
        } catch {
            itThrows = true
        }
        XCTAssert(itThrows)
    }
    
    func testCloseObjectWithoutOpen(){
        var itThrows = false
        do {
            _ = try builder.endObject()
        } catch {
            itThrows = true
        }
        XCTAssert(itThrows)
    }
    
    func testStartVectorWhenVectorAlreadyStarted(){
        var itThrows = false
        try!builder.startVector(count: 1, elementSize: 1)
        do {
            try builder.startVector(count: 1, elementSize: 1)
        } catch {
            itThrows = true
        }
        XCTAssert(itThrows)
        skipBytes(count: 3)
    }
    
    func testFinishWithBadOffset(){
        var itThrows = false
        do {
            try builder.finish(offset: 12, fileIdentifier: nil)
        } catch {
            itThrows = true
        }
        XCTAssert(itThrows)
    }
    
    func testFinishWithTooShortIdentifier(){
        var itThrows = false
        do {
            try builder.finish(offset: 0, fileIdentifier: "ab")
        } catch {
            itThrows = true
        }
        XCTAssert(itThrows)
    }
    
    func testFinishWithTooLongIdentifier(){
        var itThrows = false
        do {
            try builder.finish(offset: 0, fileIdentifier: "abcde")
        } catch {
            itThrows = true
        }
        XCTAssert(itThrows)
    }
    
    func testFinishWhileObjectIsOpen(){
        var itThrows = false
        try!builder.startObject(withPropertyCount: 1)
        do {
            try builder.finish(offset: 0, fileIdentifier: nil)
        } catch {
            itThrows = true
        }
        XCTAssert(itThrows)
    }
    
    func testCreateStringWhileObjectIsOpen(){
        var itThrows = false
        try!builder.startObject(withPropertyCount: 1)
        do {
            _ = try builder.insert(value: "Mo")
        } catch {
            itThrows = true
        }
        XCTAssert(itThrows)
    }
    
    func testCreateNilString(){
        let c = try!builder.insert(value: nil)
        XCTAssertEqual(c, 0)
    }
    
    func testDefaultValuesNotSet(){
        try!builder.startObject(withPropertyCount: 2)
        try!builder.insert(value: Int32(12), defaultValue: 0, toStartedObjectAt: 0)
        try!builder.insert(value: Int32(5), defaultValue: 5, toStartedObjectAt: 1)
        _ = try!builder.endObject()
        
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 12)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
    }
    
    func testDefaultValuesForced(){
        builder = FlatBuffersBuilder(options: FlatBuffersBuilderOptions(initialCapacity: 1, uniqueStrings: true, uniqueTables: true, uniqueVTables: true, forceDefaults: true, nullTerminatedUTF8: false))
        try!builder.startObject(withPropertyCount: 2)
        try!builder.insert(value: Int32(12), defaultValue: 0, toStartedObjectAt: 0)
        try!builder.insert(value: Int32(5), defaultValue: 5, toStartedObjectAt: 1)
        _ = try!builder.endObject()
        
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 12)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 4)
        assertByte(with: 0)
        assertByte(with: 8)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 5)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 12)
        assertByte(with: 0)
        assertByte(with: 0)
        assertByte(with: 0)
        
        printData()
    }
    
    func assertByte(with: UInt8){
        XCTAssertEqual(builder.makeData[byteIndex], with)
        byteIndex += 1
    }
    
    func skipBytes(count: Int){
        byteIndex += count
    }
    
    func printData(){
        dump(builder.makeData)
    }
    
    /*
     func testPerformanceExample() {
     // This is an example of a performance test case.
     self.measure {
     // Put the code you want to measure the time of here.
     }
     }*/
    
}



struct S1 : Scalar {
    let i1 : Int
    let i2 : Int8
}
func ==(o1 : S1, o2 : S1) -> Bool {
    return false
}
