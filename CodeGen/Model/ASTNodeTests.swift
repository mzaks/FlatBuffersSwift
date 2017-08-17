//
//  ASTNodeTests.swift
//  CodeGen
//
//  Created by Maxim Zaks on 10.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import XCTest

class ASTNodeTests: XCTestCase {
    
    func testEmptyString() {
        let s: StaticString = """
        
            
    \t
"""
        let result = eatWhiteSpace(s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNil(result)
    }
    
    func testEatWhiteSpaceTillString() {
        let s: StaticString = """
        
            
    \t
foo
"""
        let result = eatWhiteSpace(s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(s.utf8CodeUnitCount - 3, s.utf8Start.distance(to: result!))
    }
    
    func testEatString(){
        let s: StaticString = """
    \t \n
    foo
"""
        let result = eat("foo", from: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(s.utf8CodeUnitCount, s.utf8Start.distance(to: result!))
    }
}

