//
//  MetaDataTests.swift
//  CodeGenTests
//
//  Created by Maxim Zaks on 17.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import XCTest

class MetaDataTests: XCTestCase {
    
    func testReadMetaData() {
        let s: StaticString = """
(deprecated, id:1, meta : "hi")
"""
        let result = MetaData.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.values.count, 3)
        XCTAssertEqual(result?.0.values[0].0.value, "deprecated")
        XCTAssertNil(result?.0.values[0].1)
        XCTAssertEqual(result?.0.values[1].0.value, "id")
        XCTAssertEqual(result?.0.values[1].1?.value, "1")
        XCTAssertEqual(result?.0.values[2].0.value, "meta")
        XCTAssertEqual(result?.0.values[2].1?.value, "\"hi\"")
    }
}
