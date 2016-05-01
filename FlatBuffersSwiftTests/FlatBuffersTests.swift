//
//  FlatBuffersTests.swift
//  FlatBuffersTests
//
//  Created by Maxim Zaks on 01.11.15.
//  Copyright © 2015 maxim.zaks. All rights reserved.
//

import XCTest
@testable import FlatBuffersSwift
import Foundation

class FlatBuffersTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPutBooleanValues() {
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        fbb.put(true)
        fbb.put(false)
        
        XCTAssertEqual(fbb.data,
            [0, // second bool value
             1  // fist bool value
            ])
    }
    
    func testPutBooleanValues2() {
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        var a = true
        var b = false
        fbb.put(&a, length: strideofValue(a))
        fbb.put(&b, length: strideofValue(b))
        
        XCTAssertEqual(fbb.data,
            [0, // second bool value
                1  // fist bool value
            ])
    }
    
    func testPutIntValues() {
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        fbb.put(27)
        XCTAssertEqual(fbb.data,[27, 0, 0, 0, 0, 0, 0, 0])
        fbb.put(Int8(27))
        XCTAssertEqual(fbb.data,[
            27,
            27, 0, 0, 0, 0, 0, 0, 0])
        fbb.put(UInt8(27))
        XCTAssertEqual(fbb.data,[
            27,
            27,
            27, 0, 0, 0, 0, 0, 0, 0])
        fbb.put(Int16(27))
        XCTAssertEqual(fbb.data,[
            27, 0,
            27,
            27,
            27, 0, 0, 0, 0, 0, 0, 0])
        fbb.put(UInt16(27))
        XCTAssertEqual(fbb.data,[
            27, 0,
            27, 0,
            27,
            27,
            27, 0, 0, 0, 0, 0, 0, 0])
        fbb.put(Int32(27))
        XCTAssertEqual(fbb.data,[
            27, 0, 0, 0,
            27, 0,
            27, 0,
            27,
            27,
            27, 0, 0, 0, 0, 0, 0, 0])
        fbb.put(UInt32(27))
        XCTAssertEqual(fbb.data,[
            27, 0, 0, 0,
            27, 0, 0, 0,
            27, 0,
            27, 0,
            27,
            27,
            27, 0, 0, 0, 0, 0, 0, 0])
        fbb.put(Int64(27))
        XCTAssertEqual(fbb.data,[
            27, 0, 0, 0, 0, 0, 0, 0,
            27, 0, 0, 0,
            27, 0, 0, 0,
            27, 0,
            27, 0,
            27,
            27,
            27, 0, 0, 0, 0, 0, 0, 0])
        fbb.put(UInt64(27))
        XCTAssertEqual(fbb.data,[
            27, 0, 0, 0, 0, 0, 0, 0,
            27, 0, 0, 0, 0, 0, 0, 0,
            27, 0, 0, 0,
            27, 0, 0, 0,
            27, 0,
            27, 0,
            27,
            27,
            27, 0, 0, 0, 0, 0, 0, 0])
        fbb.put(UInt(27))
        XCTAssertEqual(fbb.data,[
            27, 0, 0, 0, 0, 0, 0, 0,
            27, 0, 0, 0, 0, 0, 0, 0,
            27, 0, 0, 0, 0, 0, 0, 0,
            27, 0, 0, 0,
            27, 0, 0, 0,
            27, 0,
            27, 0,
            27,
            27,
            27, 0, 0, 0, 0, 0, 0, 0])
        
    }
    
    func testPutIntValues2() {
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        var a1 = 27
        fbb.put(&a1, length: strideofValue(a1))
        XCTAssertEqual(fbb.data,[27, 0, 0, 0, 0, 0, 0, 0])
        var a2 : Int8 = 27
        fbb.put(&a2, length: strideofValue(a2))
        XCTAssertEqual(fbb.data,[
            27,
            27, 0, 0, 0, 0, 0, 0, 0])
        var a3 : UInt8 = 27
        fbb.put(&a3, length: strideofValue(a3))
        XCTAssertEqual(fbb.data,[
            27,
            27,
            27, 0, 0, 0, 0, 0, 0, 0])
        var a4 : UInt16 = 27
        fbb.put(&a4, length: strideofValue(a4))
        
        XCTAssertEqual(fbb.data,[
            27, 0,
            27,
            27,
            27, 0, 0, 0, 0, 0, 0, 0])
    }
    
    func testPutFloatValues() {
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        fbb.put(27.0)
        XCTAssertEqual(fbb.data,[
            0, 0, 0, 0, 0, 0, 59, 64
            ])
        fbb.put(27.5)
        XCTAssertEqual(fbb.data,[
            0, 0, 0, 0, 0, 128, 59, 64,
            0, 0, 0, 0, 0,   0, 59, 64
            ])
        fbb.put(Float(27.5))
        XCTAssertEqual(fbb.data,[
            0, 0, 220, 65,
            0, 0, 0, 0, 0, 128, 59, 64,
            0, 0, 0, 0, 0,   0, 59, 64
            ])
        fbb.put(Float32(27.5))
        XCTAssertEqual(fbb.data,[
            0, 0, 220, 65,
            0, 0, 220, 65,
            0, 0, 0, 0, 0, 128, 59, 64,
            0, 0, 0, 0, 0,   0, 59, 64
            ])
        fbb.put(Float64(27.5))
        XCTAssertEqual(fbb.data,[
            0, 0, 0, 0, 0, 128, 59, 64,
            0, 0, 220, 65,
            0, 0, 220, 65,
            0, 0, 0, 0, 0, 128, 59, 64,
            0, 0, 0, 0, 0,   0, 59, 64
            ])
    }
    
    func testCreateString() {
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        let offset = try! fbb.createString("max")
        
        XCTAssertEqual(offset, 7)
        XCTAssertEqual(fbb.data,
            [3,0,0,0, // lenght of the string 'max'
             109,     // 'm'
             97,      // 'a'
             120      // 'x'
            ])
    }
    
    func testCreateEmptyString() {
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        let offset = try! fbb.createString("")
        
        XCTAssertEqual(offset, 4)
        XCTAssertEqual(fbb.data,
            [0,0,0,0, // lenght of the empty string
            ])
    }
    
    func testCreateVectorOffBools() {
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        try! fbb.startVector(3)
        fbb.put(true)
        fbb.put(true)
        fbb.put(false)
        let offset = fbb.endVector()
        
        XCTAssertEqual(offset, 7)
        XCTAssertEqual(fbb.data,
            [3,0,0,0, // lenght of the array
             0,       // last
             1,       // mid
             1        // first
            ])
    }
    
    func testCreateObject() {
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        let sOffset = try! fbb.createString("max")
        XCTAssertEqual(fbb.data, [3,0,0,0,109,97,120])
        try! fbb.openObject(3)
        XCTAssertEqual(fbb.data, [3,0,0,0,109,97,120])
        try! fbb.addPropertyToOpenObject(0, value: true, defaultValue: false)
        XCTAssertEqual(fbb.data, [1,3,0,0,0,109,97,120])
        try! fbb.addPropertyOffsetToOpenObject(1, offset: sOffset)
        XCTAssertEqual(fbb.data, [5,0,0,0,1,3,0,0,0,109,97,120])
        let oOffset = try! fbb.closeObject()
        
        XCTAssertEqual(oOffset, 16)
        XCTAssertEqual(fbb.data,
            [ 10,  0,              // vTable length
               9,  0,              // object data buffer length
               8,  0,              // relative offest of first property
               4,  0,              // relative offest of second property
               0,  0,              // relative offest of third property - 0,0 meaning it is not set
              10,  0,  0,  0,      // start of the object data buffer and vTable offset
               5,  0,  0,  0,      // second property string offest
               1,                  // first property boolean value
               3,  0,  0,0,        // string length
             109, 97,120]          // string 'max'
        )
    }
    
    func testCreateTwoEqualObjectAndReuseVTable() {
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        let sOffset = try! fbb.createString("max")
        XCTAssertEqual(fbb.data, [3,0,0,0,109,97,120])
        try! fbb.openObject(3)
        XCTAssertEqual(fbb.data, [3,0,0,0,109,97,120])
        try! fbb.addPropertyToOpenObject(0, value: true, defaultValue: false)
        XCTAssertEqual(fbb.data, [1,3,0,0,0,109,97,120])
        try! fbb.addPropertyOffsetToOpenObject(1, offset: sOffset)
        XCTAssertEqual(fbb.data, [5,0,0,0,1,3,0,0,0,109,97,120])
        let oOffset = try! fbb.closeObject()
        
        XCTAssertEqual(oOffset, 16)
        XCTAssertEqual(fbb.data,
            [10,0,9,0,8,0,4,0,0,0,10,0,0,0,5,0,0,0,1,3,0,0,0,109,97,120]
        )
        
        try! fbb.openObject(3)
        XCTAssertEqual(fbb.data, [10,0,9,0,8,0,4,0,0,0,10,0,0,0,5,0,0,0,1,3,0,0,0,109,97,120])
        try! fbb.addPropertyToOpenObject(0, value: true, defaultValue: false)
        XCTAssertEqual(fbb.data, [1,10,0,9,0,8,0,4,0,0,0,10,0,0,0,5,0,0,0,1,3,0,0,0,109,97,120])
        try! fbb.addPropertyOffsetToOpenObject(1, offset: sOffset)
        XCTAssertEqual(fbb.data,
            [24,0,0,0,1,
             10,0,9,0,8,0,4,0,0,0,10,0,0,0,5,0,0,0,1,
             3,0,0,0,109,97,120]
        )
        let oOffset2 = try! fbb.closeObject()
        XCTAssertEqual(oOffset2, (16/*offsetFirstObject*/ + 10/*vTableFirstObject*/ + 1/*true*/ + 4/*stringOffset*/ + 4/*vTableOffsetCurrentObject*/))
        XCTAssertEqual(fbb.data,
            // 239,255,255,255,255,255,255,255 = start of the second object data buffer and offset where to find reused
            [
             247,255,255,255,                 // -9 position where to find reusable vTabel for second object
             24,0,0,0,                         // second property of second object 'max'
             1,                               // first property of second object 'true'
             10,0,9,0,8,0,4,0,0,0,10,0,0,0,5,0,0,0,1, // first object
             3,0,0,0,109,97,120] // string length and content 'max'
        )
    }
    
    func testCreateObjectAndFinish() {
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        let sOffset = try! fbb.createString("max")
        try! fbb.openObject(3)
        try! fbb.addPropertyToOpenObject(0, value: true, defaultValue: false)
        try! fbb.addPropertyOffsetToOpenObject(1, offset: sOffset)
        let oOffset = try! fbb.closeObject()
        let data = try! fbb.finish(oOffset, fileIdentifier: "test")
        
        XCTAssertEqual(data,
            [
               18,  0,  0,  0,      // root object offset
              116,101,115,116,      // 'test' file identifier
               10,  0,              // vTable length
                9,  0,              // object data buffer length
                8,  0,              // relative offest of first property
                4,  0,              // relative offest of second property
                0,  0,              // relative offest of third property - 0,0 meaning it is not set
                10,  0,  0,  0,      // start of the object data buffer and vTable offset
                5,  0,  0,  0,      // second property string offest
                1,                  // first property boolean value
                3,  0,  0,0,        // string length
                109, 97,120]          // string 'max'
        )
    }
    
    func testCreateObjectAndFinishWithoutFileIdentifier() {
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        let sOffset = try! fbb.createString("max")
        try! fbb.openObject(3)
        try! fbb.addPropertyToOpenObject(0, value: true, defaultValue: false)
        try! fbb.addPropertyOffsetToOpenObject(1, offset: sOffset)
        let oOffset = try! fbb.closeObject()
        let data = try! fbb.finish(oOffset, fileIdentifier: nil)
        
        XCTAssertEqual(data,
            [
                14,  0,  0,  0,      // root object offset
                10,  0,              // vTable length
                9,  0,              // object data buffer length
                8,  0,              // relative offest of first property
                4,  0,              // relative offest of second property
                0,  0,              // relative offest of third property - 0,0 meaning it is not set
                10,  0,  0,  0,      // start of the object data buffer and vTable offset
                5,  0,  0,  0,      // second property string offest
                1,                  // first property boolean value
                3,  0,  0,0,        // string length
                109, 97,120]          // string 'max'
        )
    }
    
    func testCreateObjectAndReadRootObjectOffset() {
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        let sOffset = try! fbb.createString("max")
        try! fbb.openObject(3)
        try! fbb.addPropertyToOpenObject(0, value: true, defaultValue: false)
        try! fbb.addPropertyOffsetToOpenObject(1, offset: sOffset)
        let oOffset = try! fbb.closeObject()
        let data = try! fbb.finish(oOffset, fileIdentifier: nil)
        
        XCTAssertEqual(data,
            [
                14,  0,  0,  0,      // root object offset
                10,  0,              // vTable length
                9,  0,              // object data buffer length
                8,  0,              // relative offest of first property
                4,  0,              // relative offest of second property
                0,  0,              // relative offest of third property - 0,0 meaning it is not set
                10,  0,  0,  0,      // start of the object data buffer and vTable offset
                5,  0,  0,  0,      // second property string offest
                1,                  // first property boolean value
                3,  0,  0,0,        // string length
                109, 97,120]          // string 'max'
        )
        
        let reader = FlatBufferReader(buffer: data, config: BinaryReadConfig())
        let objectOffset = reader.rootObjectOffset
        XCTAssertEqual(objectOffset, 14)
    }
    
    func testCreateObjectAndReadFirstBoolFromRootObject() {
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        let sOffset = try! fbb.createString("max")
        try! fbb.openObject(3)
        try! fbb.addPropertyToOpenObject(0, value: true, defaultValue: false)
        try! fbb.addPropertyOffsetToOpenObject(1, offset: sOffset)
        let oOffset = try! fbb.closeObject()
        let data = try! fbb.finish(oOffset, fileIdentifier: nil)
        
        XCTAssertEqual(data,
            [
                14,  0,  0,  0,      // root object offset
                10,  0,              // vTable length
                9,  0,              // object data buffer length
                8,  0,              // relative offest of first property
                4,  0,              // relative offest of second property
                0,  0,              // relative offest of third property - 0,0 meaning it is not set
                10,  0,  0,  0,      // start of the object data buffer and vTable offset
                5,  0,  0,  0,      // second property string offest
                1,                  // first property boolean value
                3,  0,  0,0,        // string length
                109, 97,120]          // string 'max'
        )
        
        let reader = FlatBufferReader(buffer: data, config: BinaryReadConfig())
        let objectOffset = reader.rootObjectOffset
        let b1 = reader.get(objectOffset, propertyIndex: 0, defaultValue: false)
        XCTAssertEqual(b1, true)
    }
    
    func testCreateObjectAndReadPropertyOutsideOfTheVTable() { // Important for backwards compatibility
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        let sOffset = try! fbb.createString("max")
        try! fbb.openObject(3)
        try! fbb.addPropertyToOpenObject(0, value: true, defaultValue: false)
        try! fbb.addPropertyToOpenObject(2, value: true, defaultValue: false)
        try! fbb.addPropertyOffsetToOpenObject(1, offset: sOffset)
        let oOffset = try! fbb.closeObject()
        let data = try! fbb.finish(oOffset, fileIdentifier: nil)
        
        XCTAssertEqual(data,
            [
                14,  0,  0,  0,      // root object offset
                10,  0,              // vTable length
                10,  0,              // object data buffer length
                9,  0,              // relative offest of first property
                4,  0,              // relative offest of second property
                8,  0,              // relative offest of third property
                10,  0,  0,  0,      // start of the object data buffer and vTable offset
                6,  0,  0,  0,      // second property string offest
                1,                  // third property boolean value
                1,                  // first property boolean value
                3,  0,  0,0,        // string length
                109, 97,120]          // string 'max'
        )
        
        let reader = FlatBufferReader(buffer: data, config: BinaryReadConfig())
        let objectOffset = reader.rootObjectOffset
        let badProperty = reader.get(objectOffset, propertyIndex: 3, defaultValue: false)
        XCTAssertEqual(badProperty, false)
        let thirdProperty = reader.get(objectOffset, propertyIndex: 2, defaultValue: false)
        XCTAssertEqual(thirdProperty, true)
    }
    
    func testCreateObjectAndReadStringFromRootObject() {
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        let sOffset = try! fbb.createString("max")
        try! fbb.openObject(3)
        try! fbb.addPropertyToOpenObject(0, value: true, defaultValue: false)
        try! fbb.addPropertyOffsetToOpenObject(1, offset: sOffset)
        let oOffset = try! fbb.closeObject()
        let data = try! fbb.finish(oOffset, fileIdentifier: nil)
        
        XCTAssertEqual(data,
            [
                14,  0,  0,  0,      // root object offset
                10,  0,              // vTable length
                9,  0,              // object data buffer length
                8,  0,              // relative offest of first property
                4,  0,              // relative offest of second property
                0,  0,              // relative offest of third property - 0,0 meaning it is not set
                10,  0,  0,  0,      // start of the object data buffer and vTable offset
                5,  0,  0,  0,      // second property string offest
                1,                  // first property boolean value
                3,  0,  0,0,        // string length
                109, 97,120]          // string 'max'
        )
        
        let reader = FlatBufferReader(buffer: data, config: BinaryReadConfig())
        let objectOffset = reader.rootObjectOffset
        let stringOffset : Offset? = reader.getOffset(objectOffset, propertyIndex: 1)
        let string = reader.getString(stringOffset)
        XCTAssertEqual(string, "max")
    }
    
    func testReadStringFromNestedObject() {
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        let sOffset = try! fbb.createString("max")
        try! fbb.openObject(3)
        try! fbb.addPropertyToOpenObject(0, value: true, defaultValue: false)
        try! fbb.addPropertyOffsetToOpenObject(1, offset: sOffset)
        let oOffset1 = try! fbb.closeObject()
        
        try! fbb.openObject(3)
        try! fbb.addPropertyToOpenObject(0, value: true, defaultValue: false)
        try! fbb.addPropertyOffsetToOpenObject(1, offset: oOffset1)
        let oOffset2 = try! fbb.closeObject()
        
        let data = try! fbb.finish(oOffset2, fileIdentifier: nil)
        
        let reader = FlatBufferReader(buffer: data, config: BinaryReadConfig())
        let objectOffset = reader.rootObjectOffset
        let objectOffset2 : Offset = reader.getOffset(objectOffset, propertyIndex: 1)!
        let stringOffset : Offset? = reader.getOffset(objectOffset2, propertyIndex: 1)
        let string = reader.getString(stringOffset)
        XCTAssertEqual(string, "max")
    }
    
    func testReadIntFromVector() {
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        try! fbb.startVector(2)
        fbb.put(34) // puting stuff in reversed order!!!
        fbb.put(43) // puting stuff in reversed order!!!
        let sOffset = fbb.endVector()
        
        try! fbb.openObject(3)
        try! fbb.addPropertyToOpenObject(0, value: true, defaultValue: false)
        try! fbb.addPropertyOffsetToOpenObject(1, offset: sOffset)
        let oOffset1 = try! fbb.closeObject()
        
        let data = try! fbb.finish(oOffset1, fileIdentifier: nil)
        
        let reader = FlatBufferReader(buffer: data, config: BinaryReadConfig())
        let objectOffset = reader.rootObjectOffset
        let objectOffset2 : Offset = reader.getOffset(objectOffset, propertyIndex: 1)!
        let length = reader.getVectorLength(objectOffset2)
        XCTAssertEqual(length, 2)
        XCTAssertEqual(reader.getVectorScalarElement(objectOffset2, index: 0) as Int, 43)
        XCTAssertEqual(reader.getVectorScalarElement(objectOffset2, index: 1) as Int, 34)
    }
    
    func testReadStringFromVector() {
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        let sOffset = try! fbb.createString("max")
        try! fbb.startVector(1)
        try! fbb.putOffset(sOffset)
        let vOffset = fbb.endVector()
        
        try! fbb.openObject(3)
        try! fbb.addPropertyToOpenObject(0, value: true, defaultValue: false)
        try! fbb.addPropertyOffsetToOpenObject(1, offset: vOffset)
        let oOffset1 = try! fbb.closeObject()
        
        let data = try! fbb.finish(oOffset1, fileIdentifier: nil)
        
        let reader = FlatBufferReader(buffer: data, config: BinaryReadConfig())
        let objectOffset = reader.rootObjectOffset
        let objectOffset2 : Offset = reader.getOffset(objectOffset, propertyIndex: 1)!
        let length = reader.getVectorLength(objectOffset2)
        XCTAssertEqual(length, 1)
        let objectOffset3 : Offset? = reader.getVectorOffsetElement(objectOffset2, index: 0)
        XCTAssertEqual(reader.getString(objectOffset3), "max")
    }
    
    func testReplaceOffsetInVector() {
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        let sOffset = try! fbb.createString("max")
        
        try! fbb.startVector(1)
        let cursor = try! fbb.putOffset(0)
        let vOffset = fbb.endVector()
        
        try! fbb.replaceOffset(sOffset, atCursor: cursor)
        let data = try! fbb.finish(vOffset, fileIdentifier: nil)
        
        let reader = FlatBufferReader(buffer: data, config: BinaryReadConfig())
        let objectOffset = reader.rootObjectOffset
        let length = reader.getVectorLength(objectOffset)
        XCTAssertEqual(length, 1)
        let objectOffset3 : Offset? = reader.getVectorOffsetElement(objectOffset, index: 0)
        XCTAssertEqual(reader.getString(objectOffset3), "max")
    }
    
    func testReplaceOffsetInObject() {
        let fbb = FlatBufferBuilder(config:BinaryBuildConfig())
        let sOffset = try! fbb.createString("max")
        
        try! fbb.openObject(1)
        let cursor = try! fbb.addPropertyOffsetToOpenObject(0, offset: 0)
        let oOffset = try! fbb.closeObject()
        
        try! fbb.replaceOffset(sOffset, atCursor: cursor)
        let data = try! fbb.finish(oOffset, fileIdentifier: nil)
        
        let reader = FlatBufferReader(buffer: data, config: BinaryReadConfig())
        let objectOffset = reader.rootObjectOffset
        let objectOffset3 : Offset? = reader.getOffset(objectOffset, propertyIndex: 0)
        XCTAssertEqual(reader.getString(objectOffset3), "max")
    }
    
}
