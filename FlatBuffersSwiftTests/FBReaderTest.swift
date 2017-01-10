//
//  ReaderTest.swift
//  FBSwift3
//
//  Created by Maxim Zaks on 28.10.16.
//  Copyright © 2016 Maxim Zaks. All rights reserved.
//

import XCTest
@testable import FlatBuffersSwift

class FBReaderTest: XCTestCase {
    
    func testReadDirect() {
        
        let data = createSimpleObject()
        
        let reader = FBMemoryReader(data: data)
        
        let objectOffset = reader.rootObjectOffset
        XCTAssertEqual(objectOffset, 16)
        
        let stringOffset = reader.getOffset(objectOffset: objectOffset!, propertyIndex: 1)
        XCTAssertEqual(stringOffset, 28)
        
        let stringBuffer = reader.getStringBuffer(stringOffset: stringOffset)
        XCTAssertEqual(stringBuffer?§, "max")
        
        let booleanValue1 : Bool? = reader.get(objectOffset: objectOffset!, propertyIndex: 0)
        XCTAssertTrue(booleanValue1!)
        
        let booleanValue2 : Bool? = reader.get(objectOffset: objectOffset!, propertyIndex: 2)
        XCTAssertNil(booleanValue2)
        
        let booleanValueDefault : Bool = reader.get(objectOffset: objectOffset!, propertyIndex: 2, defaultValue: false)
        XCTAssertFalse(booleanValueDefault)
    }
    
    func testReadDirectWithVector() {
        
        let data = createObjectWithVectors()
        let reader = FBMemoryReader(data: data)
        
        let objectOffset = reader.rootObjectOffset
        XCTAssertEqual(objectOffset, 12)
        
        let sVectorOffset = reader.getOffset(objectOffset: objectOffset!, propertyIndex: 0)
        XCTAssertEqual(sVectorOffset, 32)
        
        let sVectorLength = reader.getVectorElementCount(vectorOffset: sVectorOffset)
        XCTAssertEqual(sVectorLength, 3)
        
        let sOffset1 = reader.getVectorElementOffset(vectorOffset: sVectorOffset!, index: 0)
        XCTAssertEqual(sOffset1, 48)
        
        let sOffset2 = reader.getVectorElementOffset(vectorOffset: sVectorOffset!, index: 1)
        XCTAssertEqual(sOffset2, 56)
        
        let sOffset3 = reader.getVectorElementOffset(vectorOffset: sVectorOffset!, index: 2)
        XCTAssertEqual(sOffset3, 64)
        
        let stringBuffer1 = reader.getStringBuffer(stringOffset: sOffset1)
        XCTAssertEqual(stringBuffer1?§, "max3")
        
        let stringBuffer2 = reader.getStringBuffer(stringOffset: sOffset2)
        XCTAssertEqual(stringBuffer2?§, "max2")
        
        let stringBuffer3 = reader.getStringBuffer(stringOffset: sOffset3)
        XCTAssertEqual(stringBuffer3?§, "max1")
        
        let bVectorOffset = reader.getOffset(objectOffset: objectOffset!, propertyIndex: 1)
        XCTAssertEqual(bVectorOffset, 24)
        
        let bVectorLength = reader.getVectorElementCount(vectorOffset: bVectorOffset)
        XCTAssertEqual(bVectorLength, 2)
        
        let b1 : Bool? = reader.getVectorScalarElement(vectorOffset: bVectorOffset!, index: 0)
        XCTAssertEqual(b1, false)
        
        let b2 : Bool? = reader.getVectorScalarElement(vectorOffset: bVectorOffset!, index: 1)
        XCTAssertEqual(b2, true)
    }
    
    func testReadInvalidRootDirect() {
        
        let data : [UInt8] = [12]
        let reader = FBMemoryReader(buffer: UnsafeRawPointer(data), count: data.count)
        
        let objectOffset = reader.rootObjectOffset
        XCTAssertNil(objectOffset)
        
    }
    
    func testReadPropertyWithHighPropertyIndex() {
        let data = createObjectWithVectors()
        let reader = FBMemoryReader(data: Data(data))
        
        let root = reader.rootObjectOffset
        
        let i : Int? = reader.get(objectOffset: root!, propertyIndex: 10)
        
        XCTAssertNil(i)
    }
    
    func testReadPropertyWithLowPropertyIndex() {
        let data = createObjectWithVectors()
        let reader = FBMemoryReader(data: data)
        
        let root = reader.rootObjectOffset
        let i : Int? = reader.get(objectOffset: root!, propertyIndex: -1)
        
        XCTAssertNil(i)
    }
    
    func testReadPropertyOffestWithWrongPropertyIndex() {
        let data = createObjectWithVectors()
        let reader = FBMemoryReader(data: data)
        
        let root = reader.rootObjectOffset
        let o = reader.getOffset(objectOffset: root!, propertyIndex: -1)
        
        XCTAssertNil(o)
    }
    
    func testReadPropertyWhereVTableReferenceIsBroken() {
        let data : [UInt8] = [4,0,0,0,5]
        
        let reader = FBMemoryReader(data: Data(data))
        
        let root = reader.rootObjectOffset
        let i : Int? = reader.get(objectOffset: root!, propertyIndex: 0)
        
        XCTAssertNil(i)
    }
    
    func testReadFromFile() {
        var data = createSimpleObject()
        
        let (fh, fileUrl) = createTempFileHandle()
        defer {
            fh.closeFile()
            try!FileManager.default.removeItem(at: fileUrl as URL)
        }
        fh.write(data)
        
        let reader = FBFileReader(fileHandle : fh)
        let objectOffset = reader.rootObjectOffset
        XCTAssertEqual(objectOffset, 16)
        
        let stringOffset = reader.getOffset(objectOffset: objectOffset!, propertyIndex: 1)
        XCTAssertEqual(stringOffset, 28)
        
        let stringBuffer = reader.getStringBuffer(stringOffset: stringOffset)
        XCTAssertEqual(stringBuffer?§, "max")
        
        let booleanValue1 : Bool? = reader.get(objectOffset: objectOffset!, propertyIndex: 0)
        XCTAssertTrue(booleanValue1!)
        
        let booleanValue2 : Bool? = reader.get(objectOffset: objectOffset!, propertyIndex: 2)
        XCTAssertNil(booleanValue2)
        
        // XCTAssertFalse(reader.hasProperty(objectOffset!, propertyIndex: 2))
        
        let booleanValueDefault : Bool = reader.get(objectOffset: objectOffset!, propertyIndex: 2, defaultValue: false)
        XCTAssertFalse(booleanValueDefault)
    }
    
    func testFromFileWithVector() {
        
        let data = createObjectWithVectors()
        
        let (fh, fileUrl) = createTempFileHandle()
        defer {
            fh.closeFile()
            try!FileManager.default.removeItem(at: fileUrl as URL)
        }
        fh.write(data)
        
        let reader = FBFileReader(fileHandle : fh)
        
        let objectOffset = reader.rootObjectOffset
        XCTAssertEqual(objectOffset, 12)
        
        let sVectorOffset = reader.getOffset(objectOffset: objectOffset!, propertyIndex: 0)
        XCTAssertEqual(sVectorOffset, 32)
        
        let sVectorLength = reader.getVectorElementCount(vectorOffset: sVectorOffset)
        XCTAssertEqual(sVectorLength, 3)
        
        let sOffset1 = reader.getVectorElementOffset(vectorOffset: sVectorOffset!, index: 0)
        XCTAssertEqual(sOffset1, 48)
        
        let sOffset2 = reader.getVectorElementOffset(vectorOffset: sVectorOffset!, index: 1)
        XCTAssertEqual(sOffset2, 56)
        
        let sOffset3 = reader.getVectorElementOffset(vectorOffset: sVectorOffset!, index: 2)
        XCTAssertEqual(sOffset3, 64)
        
        let stringBuffer1 = reader.getStringBuffer(stringOffset: sOffset1)
        XCTAssertEqual(stringBuffer1?§, "max3")
        
        let stringBuffer2 = reader.getStringBuffer(stringOffset: sOffset2)
        XCTAssertEqual(stringBuffer2?§, "max2")
        
        let stringBuffer3 = reader.getStringBuffer(stringOffset: sOffset3)
        XCTAssertEqual(stringBuffer3?§, "max1")
        
        let bVectorOffset = reader.getOffset(objectOffset: objectOffset!, propertyIndex: 1)
        XCTAssertEqual(bVectorOffset, 24)
        
        let bVectorLength = reader.getVectorElementCount(vectorOffset: bVectorOffset)
        XCTAssertEqual(bVectorLength, 2)
        
        let b1 : Bool? = reader.getVectorScalarElement(vectorOffset: bVectorOffset!, index: 0)
        XCTAssertEqual(b1, false)
        
        let b2 : Bool? = reader.getVectorScalarElement(vectorOffset: bVectorOffset!, index: 1)
        XCTAssertEqual(b2, true)
    }
    
    func testReadInvalidRootFromFile() {
        
        let data : [UInt8] = [12]
        
        let (fh, fileUrl) = createTempFileHandle()
        defer {
            fh.closeFile()
            try!FileManager.default.removeItem(at: fileUrl as URL)
        }
        fh.write(Data(bytes: data))
        
        let reader = FBFileReader(fileHandle : fh)
        
        let objectOffset = reader.rootObjectOffset
        XCTAssertNil(objectOffset)
        
    }
    
    func createSimpleObject() -> Data {
        let fbb = FBBuilder(config:FBBuildConfig(
            initialCapacity : 1,
            uniqueStrings : true,
            uniqueTables : true,
            uniqueVTables : true,
            forceDefaults : false,
            nullTerminatedUTF8 : false)
        )
        let sOffset = try! fbb.createString(value: "max")
        try! fbb.openObject(numOfProperties: 3)
        try! fbb.addPropertyToOpenObject(propertyIndex: 0, value: true, defaultValue: false)
        try! fbb.addPropertyOffsetToOpenObject(propertyIndex: 1, offset: sOffset)
        let oOffset = try! fbb.closeObject()
        try! fbb.finish(offset: oOffset, fileIdentifier: nil)
        let data = fbb.data
        
        return data
    }
    
    func createObjectWithVectors() -> Data{
        let fbb = FBBuilder(config:FBBuildConfig(
            initialCapacity : 1,
            uniqueStrings : true,
            uniqueTables : true,
            uniqueVTables : true,
            forceDefaults : false,
            nullTerminatedUTF8 : false)
        )
        let sOffset1 = try! fbb.createString(value: "max1")
        let sOffset2 = try! fbb.createString(value: "max2")
        let sOffset3 = try! fbb.createString(value: "max3")
        
        try! fbb.startVector(count: 3, elementSize: 4)
        try!fbb.putOffset(offset: sOffset1)
        try!fbb.putOffset(offset: sOffset2)
        try!fbb.putOffset(offset: sOffset3)
        let sVectorOffset = fbb.endVector()
        
        try! fbb.startVector(count: 2, elementSize: 1)
        fbb.put(value: true)
        fbb.put(value: false)
        let bVectorOffset = fbb.endVector()
        
        try! fbb.openObject(numOfProperties: 2)
        try! fbb.addPropertyOffsetToOpenObject(propertyIndex: 0, offset: sVectorOffset)
        try! fbb.addPropertyOffsetToOpenObject(propertyIndex: 1, offset: bVectorOffset)
        let oOffset = try! fbb.closeObject()
        try! fbb.finish(offset: oOffset, fileIdentifier: nil)
        let data = fbb.data
        
        return data
    }
    
    func createTempFileHandle() -> (handle : FileHandle, url : NSURL){
        // The template string:
        let template = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("file.XXXXXX") as NSURL
        
        // Fill buffer with a C string representing the local file system path.
        var buffer = [Int8](repeating: 0, count: Int(PATH_MAX))
        template.getFileSystemRepresentation(&buffer, maxLength: buffer.count)
        
        
        // Create unique file name (and open file):
        let fd = mkstemp(&buffer)
        let url = NSURL(fileURLWithFileSystemRepresentation: buffer, isDirectory: false, relativeTo: nil)
        print(url.path!)
        return (FileHandle(fileDescriptor: fd, closeOnDealloc: true), url)
    }
}
