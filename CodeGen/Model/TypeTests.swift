//
//  TypeTests.swift
//  CodeGenTests
//
//  Created by Maxim Zaks on 10.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import XCTest

class TypeTests: XCTestCase {
    
    func testMultipleTypes() {
        let s: StaticString = """

bool byte ubyte short ushort int uint long ulong float double string Foo [bool] [Bar] [string]
"""
        var result = Type.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.scalar, .bool)
        XCTAssertNil(result!.0.ref)
        XCTAssertFalse(result!.0.string)
        XCTAssertFalse(result!.0.vector)
        
        var length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = Type.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.scalar, .i8)
        XCTAssertNil(result!.0.ref)
        XCTAssertFalse(result!.0.string)
        XCTAssertFalse(result!.0.vector)
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = Type.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.scalar, .u8)
        XCTAssertNil(result!.0.ref)
        XCTAssertFalse(result!.0.string)
        XCTAssertFalse(result!.0.vector)
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = Type.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.scalar, .i16)
        XCTAssertNil(result!.0.ref)
        XCTAssertFalse(result!.0.string)
        XCTAssertFalse(result!.0.vector)
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = Type.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.scalar, .u16)
        XCTAssertNil(result!.0.ref)
        XCTAssertFalse(result!.0.string)
        XCTAssertFalse(result!.0.vector)
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = Type.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.scalar, .i32)
        XCTAssertNil(result!.0.ref)
        XCTAssertFalse(result!.0.string)
        XCTAssertFalse(result!.0.vector)
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = Type.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.scalar, .u32)
        XCTAssertNil(result!.0.ref)
        XCTAssertFalse(result!.0.string)
        XCTAssertFalse(result!.0.vector)
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = Type.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.scalar, .i64)
        XCTAssertNil(result!.0.ref)
        XCTAssertFalse(result!.0.string)
        XCTAssertFalse(result!.0.vector)
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = Type.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.scalar, .u64)
        XCTAssertNil(result!.0.ref)
        XCTAssertFalse(result!.0.string)
        XCTAssertFalse(result!.0.vector)
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = Type.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.scalar, .f32)
        XCTAssertNil(result!.0.ref)
        XCTAssertFalse(result!.0.string)
        XCTAssertFalse(result!.0.vector)
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = Type.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.0.scalar, .f64)
        XCTAssertNil(result!.0.ref)
        XCTAssertFalse(result!.0.string)
        XCTAssertFalse(result!.0.vector)
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = Type.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertNil(result!.0.scalar)
        XCTAssertNil(result!.0.ref)
        XCTAssertTrue(result!.0.string)
        XCTAssertFalse(result!.0.vector)
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = Type.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertNil(result!.0.scalar)
        XCTAssertEqual(result!.0.ref?.value, "Foo")
        XCTAssertFalse(result!.0.string)
        XCTAssertFalse(result!.0.vector)
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = Type.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.0.scalar, .bool)
        XCTAssertNil(result!.0.ref?.value)
        XCTAssertFalse(result!.0.string)
        XCTAssertTrue(result!.0.vector)
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = Type.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertNil(result!.0.scalar)
        XCTAssertEqual(result!.0.ref?.value, "Bar")
        XCTAssertFalse(result!.0.string)
        XCTAssertTrue(result!.0.vector)
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = Type.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertNil(result!.0.scalar)
        XCTAssertNil(result!.0.ref)
        XCTAssertTrue(result!.0.string)
        XCTAssertTrue(result!.0.vector)
    }
    
    func testBrokenDef() {
        let s: StaticString = "[string"
        let result = Type.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNil(result)
    }
    
    func testStrangeVector() {
        let s: StaticString = " [   string  \n  ]   "
        let result = Type.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertNil(result!.0.scalar)
        XCTAssertNil(result!.0.ref)
        XCTAssertTrue(result!.0.string)
        XCTAssertTrue(result!.0.vector)
    }
    
    func testMultipleTypesToSwift() {
        let s: StaticString = """

bool byte ubyte short ushort int uint long ulong float double string Foo [bool] [Bar] [string]
"""
        
        var types: [Type] = []
        var p = s.utf8Start
        var length = s.utf8CodeUnitCount
        while let r = Type.with(pointer: p, length: length) {
            types.append(r.0)
            length -= p.distance(to: r.1)
            p = r.1
        }
        
        XCTAssertEqual(types.count, 16)
        let swiftTypes = "Bool Int8 UInt8 Int16 UInt16 Int32 UInt32 Int64 UInt64 Float32 Float64 String Foo [Bool] [Bar] [String]"
        let result = types.map { $0.swift }.joined(separator: " ")
        XCTAssertEqual(result, swiftTypes)
    }
}

