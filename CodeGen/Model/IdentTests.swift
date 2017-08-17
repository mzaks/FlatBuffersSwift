//
//  IdentTests.swift
//  CodeGen
//
//  Created by Maxim Zaks on 10.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import Foundation

import XCTest

class IdentTests: XCTestCase {
    
    func testReadLowerCaseIdent() {
        let s: StaticString = """

	table
"""
        let result = Ident.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.value, "table")
    }
    
    func testReadCapitalisedIdent() {
        let s: StaticString = """

    Table
"""
        let result = Ident.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.value, "Table")
        
    }
    
    func testReadUnderscoredIdent() {
        let s: StaticString = """

    _Table
"""
        let result = Ident.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.value, "_Table")
        
    }
    
    func testReadComplexIdent() {
        let s: StaticString = """

    _Table_01_FOR_my_own1234
"""
        let result = Ident.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.value, "_Table_01_FOR_my_own1234")
        
    }
    
    func testIgnoreIdentStartingWithNumber() {
        let s: StaticString = """

    1table
"""
        let result = Ident.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNil(result)
    }
}
