//
//  LazyVectorAccessTests.swift
//  FlatBuffersSwift
//
//  Created by Maxim Zaks on 07.01.16.
//  Copyright © 2016 maxim.zaks. All rights reserved.
//

import XCTest
import FlatBuffersSwift

class LazyVectorAccessTests: XCTestCase {
    

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAccessingLazyVector() {
        let count = 5
        let vector = LazyVector(count: count){_ in
            return 4
        }
        
        XCTAssert(vector[-1] == nil)
        XCTAssert(vector[0] == 4)
        XCTAssert(vector[4] == 4)
        XCTAssert(vector[5] == nil)
    }
    
    func testLazyVectorCount() {
        let count = 5
        let vector = LazyVector(count: count){_ in
            return 4
        }
        
        XCTAssert(vector.count == count)
    }

    func testGeneratorFunctionIsCalledOnlyOnce() {
        let count = 5
        var called = [Bool](count: count, repeatedValue: false)
        let vector = LazyVector(count: count) { (index)-> Int in
            XCTAssert(!called[index])
            called[index] = true
            return 4
        }
        
        XCTAssert(vector[0] == 4)
        XCTAssert(vector[4] == 4)
        XCTAssert(vector[0] == 4)
        XCTAssert(vector[0] == 4)
        XCTAssert(vector[0] == 4)
    }
    
    
    func testIteratingOverLazyVector() {
        let count = 5
        var called = [Bool](count: count, repeatedValue: false)
        let vector = LazyVector(count: count) { (index)-> Int in
            XCTAssert(!called[index])
            called[index] = true
            return 4
        }
        
        for value in vector {
            XCTAssert(value == 4)
        }
        for value in vector.reverse() {
            XCTAssert(value == 4)
        }
    }
    
}
