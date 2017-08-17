//
//  CommentTests.swift
//  CodeGenTests
//
//  Created by Maxim Zaks on 30.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import XCTest

class CommentTests: XCTestCase {
    
    func testComment() {
        let s: StaticString = """
// hello there
"""
        let result = Comment.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.value, " hello there")
    }
    
    func testCommentWithSomeTextOnOtherLine() {
        let s: StaticString = "// this is something\nbla"
        let result = Comment.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.value, " this is something")
    }
}
