//
//  StringLiteralTests.swift
//  CodeGenTests
//
//  Created by Maxim Zaks on 10.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import XCTest

class StringLiteralTests: XCTestCase {

    func testReadMultilineString() {
        let s: StaticString = """
"hello there"
"""
        let result = StringLiteral.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.value, "hello there")
    }
    
    func testReadQuotedString() {
        let s: StaticString = "\"hello there\""
        let result = StringLiteral.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.value, "hello there")
    }
    func testNotClosedString() {
        let s: StaticString = "\"hello there"
        let result = StringLiteral.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNil(result)
    }
}
