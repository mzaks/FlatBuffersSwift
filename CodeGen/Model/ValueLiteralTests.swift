//
//  ValueLiteralTests.swift
//  CodeGenTests
//
//  Created by Maxim Zaks on 10.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import XCTest

class ValueLiteralTests: XCTestCase {
    
    func testValues() {
        let s: StaticString = """
"hello there" 12 -12 0.1 -0.1 true      false 1.2e10
"""
        var result = ValueLiteral.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.value, "\"hello there\"")
        
        var length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = ValueLiteral.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.value, "12")
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = ValueLiteral.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.value, "-12")
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = ValueLiteral.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.value, "0.1")
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = ValueLiteral.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.value, "-0.1")
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = ValueLiteral.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.value, "true")
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = ValueLiteral.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.value, "false")
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = ValueLiteral.with(pointer: result!.1, length: length)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.value, "1.2e10")
        
        length = s.utf8CodeUnitCount - s.utf8Start.distance(to: result!.1)
        result = ValueLiteral.with(pointer: result!.1, length: length)
        XCTAssertNil(result)
    }
    
    func testNotValue() {
        let s: StaticString = """
    
hello
"""
        let result = ValueLiteral.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNil(result)
    }
}
