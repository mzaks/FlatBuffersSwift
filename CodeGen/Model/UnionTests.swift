//
//  UnionTests.swift
//  CodeGenTests
//
//  Created by Maxim Zaks on 19.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import XCTest

class UnionTests: XCTestCase {
    
    func testUnion() {
        let s: StaticString = """
    /// bla blup
    union Foo2 (something) {Bar, Baz}
"""
        let result = Union.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.name.value, "Foo2")
        XCTAssertEqual(result?.0.metaData?.values[0].0.value, "something")
        XCTAssertEqual(result?.0.cases.count, 2)
        XCTAssertEqual(result?.0.cases[0].value, "Bar")
        XCTAssertEqual(result?.0.cases[1].value, "Baz")
        XCTAssertEqual(result?.0.comments.count, 1)
        XCTAssertEqual(result?.0.comments[0].value, "/ bla blup")
    }
    
    func testGen(){
        let s: StaticString = """
    union Foo2 (something) {A, B}
"""
        let expected = """
public enum Foo2 {
    case withA(A), withB(B)
    fileprivate static func from(selfReader: Foo2.Direct<FlatBuffersMemoryReader>?) -> Foo2? {
        guard let selfReader = selfReader else {
            return nil
        }
        switch selfReader {
        case .withA(let o):
            guard let o1 = A.from(selfReader: o) else {
                return nil
            }
            return .withA(o1)
        case .withB(let o):
            guard let o1 = B.from(selfReader: o) else {
                return nil
            }
            return .withB(o1)
        }
    }
    public enum Direct<R : FlatBuffersReader> {
        case withA(A.Direct<R>), withB(B.Direct<R>)
        fileprivate static func from(reader: R, propertyIndex : Int, objectOffset : Offset?) -> Foo2.Direct<R>? {
            guard let objectOffset = objectOffset else {
                return nil
            }
            let unionCase : Int8 = reader.get(objectOffset: objectOffset, propertyIndex: propertyIndex, defaultValue: 0)
            guard let caseObjectOffset : Offset = reader.offset(objectOffset: objectOffset, propertyIndex:propertyIndex + 1) else {
                return nil
            }
            switch unionCase {
            case 1:
                guard let o = A.Direct<R>(reader: reader, myOffset: caseObjectOffset) else {
                    return nil
            }
            return Foo2.Direct.withA(o)
            case 2:
                guard let o = B.Direct<R>(reader: reader, myOffset: caseObjectOffset) else {
                    return nil
            }
            return Foo2.Direct.withB(o)
            default:
                break
            }
            return nil
        }
        var asA: A.Direct<R>? {
            switch self {
            case .withA(let v):
                return v
            default:
                return nil
            }
        }
        var asB: B.Direct<R>? {
            switch self {
            case .withB(let v):
                return v
            default:
                return nil
            }
        }
    }
    var unionCase: Int8 {
        switch self {
          case .withA(_): return 1
          case .withB(_): return 2
        }
    }
    func insert(_ builder: FlatBuffersBuilder) throws -> Offset {
        switch self {
          case .withA(let o): return try o.insert(builder)
          case .withB(let o): return try o.insert(builder)
        }
    }
    var asA: A? {
        switch self {
        case .withA(let v):
            return v
        default:
            return nil
        }
    }
    var asB: B? {
        switch self {
        case .withB(let v):
            return v
        default:
            return nil
        }
    }
    var value: AnyObject {
        switch self {
        case .withA(let v): return v
        case .withB(let v): return v
        }
    }
}
"""
        let result = Union.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)?.0.swift
        print(result!)
        XCTAssertEqual(result, expected)
    }
}
