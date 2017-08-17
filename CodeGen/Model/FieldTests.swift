//
//  FieldTests.swift
//  FlatBuffersSwift
//
//  Created by Maxim Zaks on 10.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import XCTest

class FieldTests: XCTestCase {
    
    func testReadField() {
        let s: StaticString = """
foo: int;
"""
        let result = Field.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.name.value, "foo")
        XCTAssertEqual(result?.0.type.scalar, .i32)
    }
    
    func testReadFieldWithMetaData() {
        let s: StaticString = """
foo: int (id: 2);
"""
        let result = Field.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.name.value, "foo")
        XCTAssertEqual(result?.0.type.scalar, .i32)
        XCTAssertEqual(result?.0.metaData?.values[0].0.value, "id")
        XCTAssertEqual(result?.0.metaData?.values[0].1?.value, "2")
    }
    
    func testReadFieldWithDefault() {
        let s: StaticString = """
foo: int = 123;
"""
        let result = Field.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.name.value, "foo")
        XCTAssertEqual(result?.0.type.scalar, .i32)
        XCTAssertEqual(result?.0.defaultValue?.value, "123")
        XCTAssertNil(result?.0.defaultIdent)
        XCTAssert(result!.0.isDeprecated == false)
        XCTAssertEqual(result!.0.fieldName, "foo")
    }
    
    func testReadFieldWithDefaultAndMetaData() {
        let s: StaticString = """
foo: int = 123 (deprecated);
"""
        let result = Field.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.name.value, "foo")
        XCTAssertEqual(result?.0.type.scalar, .i32)
        XCTAssertEqual(result?.0.defaultValue?.value, "123")
        XCTAssertNil(result?.0.defaultIdent)
        XCTAssertEqual(result?.0.metaData?.values[0].0.value, "deprecated")
        XCTAssert(result!.0.isDeprecated)
        XCTAssertEqual(result!.0.fieldName, "__foo")
    }
    
    func testReadFieldWithDefaultIdent() {
        let s: StaticString = """
foo: Greeting = hi;
"""
        let result = Field.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.name.value, "foo")
        XCTAssertEqual(result?.0.type.ref?.value, "Greeting")
        XCTAssertEqual(result?.0.defaultIdent?.value, "hi")
        XCTAssertNil(result?.0.defaultValue)
    }
    
    func testReadBadField0() {
        let s: StaticString = """
	
"""
        let result = Field.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNil(result)
        
    }
    func testReadBadField1() {
        let s: StaticString = """
foo
"""
        let result = Field.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNil(result)
        
    }
    func testReadBadField2() {
        let s: StaticString = """
foo:
"""
        let result = Field.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNil(result)
    }
    func testReadBadField3() {
        let s: StaticString = """
foo:int
"""
        let result = Field.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNil(result)
    }
}
