//
//  SchemaTests.swift
//  CodeGenTests
//
//  Created by Maxim Zaks on 19.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import XCTest

class SchemaTests: XCTestCase {
    
    func testSchema() {
        let s: StaticString = """
// sample

namespace MyGame;

attribute "priority";

enum Color : byte { Red = 1, Green, Blue }

union Any { Monster, Weapon, Pickup }

struct Vec3 {
  x:float;
  y:float;
  z:float;
}

table Monster {
  pos:Vec3;
  mana:short = 150;
  hp:short = 100;
  name:string;
  // this is a deprected field
  friendly:bool = false (deprecated, priority: 1);
  inventory:[ubyte];
  color:Color = Blue;
  test:Any;
}

table T1 {
  name: string;
}

// anothe comment
root_type Monster;
"""
        let result = Schema.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.rootType?.ident.value, "Monster")
        XCTAssertEqual(result?.0.namespace?.parts.count, 1)
        XCTAssertEqual(result?.0.namespace?.parts[0].value, "MyGame")
        XCTAssertEqual(result?.0.attributes.count, 1)
        XCTAssertEqual(result?.0.attributes[0].value.value, "priority")
        XCTAssertEqual(result?.0.enums.count, 1)
        XCTAssertEqual(result?.0.enums[0].name.value, "Color")
        XCTAssertEqual(result?.0.unions.count, 1)
        XCTAssertEqual(result?.0.unions[0].name.value, "Any")
        XCTAssertEqual(result?.0.structs.count, 1)
        XCTAssertEqual(result?.0.structs[0].name.value, "Vec3")
        XCTAssertEqual(result?.0.tables.count, 2)
        XCTAssertEqual(result?.0.tables[0].name.value, "Monster")
        XCTAssertEqual(result?.0.tables[1].name.value, "T1")
    }
    
    func testIdentLookup() {
        let s: StaticString = """
enum E1: byte {A, B}
table T1 {n: int;}
table T2 {b: bool;}
struct S1 {a:int;}
table T3 {t1: T1;}
union U1 {T1, T2}
enum E2: byte {A, B}
root_type T1;
"""
        let schema = Schema.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        let result = schema?.0.identLookup
        
        XCTAssertEqual(result?.tables.count, 3)
        XCTAssertNotNil(result?.tables["T1"])
        XCTAssertNotNil(result?.tables["T2"])
        XCTAssertNotNil(result?.tables["T3"])
        XCTAssertEqual(result?.enums.count, 2)
        XCTAssertNotNil(result?.enums["E1"])
        XCTAssertNotNil(result?.enums["E2"])
        XCTAssertEqual(result?.structs.count, 1)
        XCTAssertNotNil(result?.structs["S1"])
        XCTAssertEqual(result?.unions.count, 1)
        XCTAssertNotNil(result?.unions["U1"])
    }
    
    func testHasRecursion1(){
        let s: StaticString = """
table T1 {t: T2;}
table T2 {b: bool;}
root_type T1;
"""
        let schema = Schema.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        let result = schema?.0.hasRecursions
        XCTAssert(result == false)
    }
    func testHasRecursion2(){
        let s: StaticString = """
table T1 {t: T2;}
table T2 {t: T1;}
root_type T1;
"""
        let schema = Schema.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        let result = schema?.0.hasRecursions
        XCTAssert(result == true)
    }
    
    func testHasRecursion3(){
        let s: StaticString = """
table T1 {i: int; t: T2;}
table T2 {b: bool; t: T1;}
root_type T1;
"""
        let schema = Schema.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        let result = schema?.0.hasRecursions
        XCTAssert(result == true)
    }
    
    func testHasRecursion4(){
        let s: StaticString = """
table T1 {t1: T1;}
table T2 {b: bool; t: T1;}
root_type T1;
"""
        let schema = Schema.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        let result = schema?.0.hasRecursions
        XCTAssert(result == true)
    }
    
    func testHasRecursion5(){
        let s: StaticString = """
table T1 {t1: T11;}
table T11 {i: int;}
table T2 {b: bool; t: T1;}
root_type T1;
"""
        let schema = Schema.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        let result = schema?.0.hasRecursions
        XCTAssert(result == false)
    }
    
    func testHasRecursion6(){
        let s: StaticString = """
table T1 {u: U;}
table T11 {i: int;}
table T2 {b: bool; t: T1;}
union U {T11, T2}
root_type T1;
"""
        let schema = Schema.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        let result = schema?.0.hasRecursions
        XCTAssert(result == true)
    }
    
    func testGenerate(){
        let s: StaticString = """
table T1 {u: U; s: S1;}
table T11 {i: int; s: S1;e:E2;}
table T2 {b: bool; t: T1;}
union U {T11, T2}
struct S1 {a:int;s:S2;}
struct S2 {b:bool;e:E2;}
table T3 {t1: T1;}
enum E2: byte {A, B}
root_type T1;
"""
        let expected = """
import Foundation
import FlatBuffersSwift

public final class T1 {
    public var u: U?
    public var s: S1?
    public init(u: U? = nil, s: S1? = nil) {
        self.u = u
        self.s = s
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}
extension T1.Direct {
    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset? = nil) {
        guard let reader = reader as? T else {
            return nil
        }
        self._reader = reader
        if let myOffset = myOffset {
            self._myOffset = myOffset
        } else {
            if let rootOffset = reader.rootObjectOffset {
                self._myOffset = rootOffset
            } else {
                return nil
            }
        }
    }
    public var hashValue: Int { return Int(_myOffset) }
    public static func ==<T>(t1 : T1.Direct<T>, t2 : T1.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var u: U.Direct<T>? {

        return U.Direct.from(reader: _reader, propertyIndex : 0, objectOffset : _myOffset)
    }
    public var s: S1? {

        return _reader.get(objectOffset: _myOffset, propertyIndex: 2)
    }
}
extension T1 {
    public static func from(data: Data) -> T1? {
        let reader = FlatBuffersMemoryReader(data: data, withoutCopy: false)
        return T1.from(selfReader: Direct<FlatBuffersMemoryReader>(reader: reader))
    }
    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> T1? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? T1 {
            return o
        }
        let o = T1()
        selfReader._reader.cache?.objectPool[selfReader._myOffset] = o
        o.u = U.from(selfReader: selfReader.u)
        o.s = selfReader.s

        return o
    }
}
extension FlatBuffersBuilder {
    public func insertT1(u_type: Int8 = 0, u: Offset? = nil, s: S1? = nil) throws -> (Offset, [Int?]) {
        var valueCursors = [Int?](repeating: nil, count: 3)
        try self.startObject(withPropertyCount: 3)
        valueCursors[0] = try self.insert(value: u_type, defaultValue: 0, toStartedObjectAt: 0)
        if let u = u {
            valueCursors[1] = try self.insert(offset: u, toStartedObjectAt: 1)
        }
        if let s = s {
            self.insert(value: s)
            valueCursors[2] = try self.insertCurrentOffsetAsProperty(toStartedObjectAt: 2)
        }
        return try (self.endObject(), valueCursors)
    }
}
extension T1 {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }
        if builder.inProgress.contains(ObjectIdentifier(self)){
            return 0
        }
        builder.inProgress.insert(ObjectIdentifier(self))
        let u = try self.u?.insert(builder)
        let u_type = self.u?.unionCase ?? 0
        let (myOffset, valueCursors) = try builder.insertT1(
            u_type: u_type,
            u: u,
            s: s
        )
        if u == 0,
           let o = self.u,
           let cursor = valueCursors[1] {
            builder.deferedBindings.append((o.value, cursor))
        }
        if builder.options.uniqueTables {
            builder.cache[ObjectIdentifier(self)] = myOffset
        }
        builder.inProgress.remove(ObjectIdentifier(self))
        return myOffset
    }
    public func makeData(withOptions options : FlatBuffersBuilderOptions = FlatBuffersBuilderOptions()) throws -> Data {
        let builder = FlatBuffersBuilder(options: options)
        let offset = try insert(builder)
        try builder.finish(offset: offset, fileIdentifier: nil)
        try performLateBindings(builder)
        return builder.makeData
    }
}
public enum U {
    case withT11(T11), withT2(T2)
    fileprivate static func from(selfReader: U.Direct<FlatBuffersMemoryReader>?) -> U? {
        guard let selfReader = selfReader else {
            return nil
        }
        switch selfReader {
        case .withT11(let o):
            guard let o1 = T11.from(selfReader: o) else {
                return nil
            }
            return .withT11(o1)
        case .withT2(let o):
            guard let o1 = T2.from(selfReader: o) else {
                return nil
            }
            return .withT2(o1)
        }
    }
    public enum Direct<R : FlatBuffersReader> {
        case withT11(T11.Direct<R>), withT2(T2.Direct<R>)
        fileprivate static func from(reader: R, propertyIndex : Int, objectOffset : Offset?) -> U.Direct<R>? {
            guard let objectOffset = objectOffset else {
                return nil
            }
            let unionCase : Int8 = reader.get(objectOffset: objectOffset, propertyIndex: propertyIndex, defaultValue: 0)
            guard let caseObjectOffset : Offset = reader.offset(objectOffset: objectOffset, propertyIndex:propertyIndex + 1) else {
                return nil
            }
            switch unionCase {
            case 1:
                guard let o = T11.Direct<R>(reader: reader, myOffset: caseObjectOffset) else {
                    return nil
            }
            return U.Direct.withT11(o)
            case 2:
                guard let o = T2.Direct<R>(reader: reader, myOffset: caseObjectOffset) else {
                    return nil
            }
            return U.Direct.withT2(o)
            default:
                break
            }
            return nil
        }
        var asT11: T11.Direct<R>? {
            switch self {
            case .withT11(let v):
                return v
            default:
                return nil
            }
        }
        var asT2: T2.Direct<R>? {
            switch self {
            case .withT2(let v):
                return v
            default:
                return nil
            }
        }
    }
    var unionCase: Int8 {
        switch self {
          case .withT11(_): return 1
          case .withT2(_): return 2
        }
    }
    func insert(_ builder: FlatBuffersBuilder) throws -> Offset {
        switch self {
          case .withT11(let o): return try o.insert(builder)
          case .withT2(let o): return try o.insert(builder)
        }
    }
    var asT11: T11? {
        switch self {
        case .withT11(let v):
            return v
        default:
            return nil
        }
    }
    var asT2: T2? {
        switch self {
        case .withT2(let v):
            return v
        default:
            return nil
        }
    }
    var value: AnyObject {
        switch self {
        case .withT11(let v): return v
        case .withT2(let v): return v
        }
    }
}
public final class T11 {
    public var i: Int32
    public var s: S1?
    public var e: E2?
    public init(i: Int32 = 0, s: S1? = nil, e: E2? = E2.A) {
        self.i = i
        self.s = s
        self.e = e
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}
extension T11.Direct {
    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset? = nil) {
        guard let reader = reader as? T else {
            return nil
        }
        self._reader = reader
        if let myOffset = myOffset {
            self._myOffset = myOffset
        } else {
            if let rootOffset = reader.rootObjectOffset {
                self._myOffset = rootOffset
            } else {
                return nil
            }
        }
    }
    public var hashValue: Int { return Int(_myOffset) }
    public static func ==<T>(t1 : T11.Direct<T>, t2 : T11.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var i: Int32 {

        return _reader.get(objectOffset: _myOffset, propertyIndex: 0, defaultValue: 0)
    }
    public var s: S1? {

        return _reader.get(objectOffset: _myOffset, propertyIndex: 1)
    }
    public var e: E2? {

        return E2(rawValue:_reader.get(objectOffset: _myOffset, propertyIndex: 2, defaultValue: E2.A.rawValue))
    }
}
extension T11 {

    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> T11? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? T11 {
            return o
        }
        let o = T11()
        selfReader._reader.cache?.objectPool[selfReader._myOffset] = o
        o.i = selfReader.i
        o.s = selfReader.s
        o.e = selfReader.e

        return o
    }
}
extension FlatBuffersBuilder {
    public func insertT11(i: Int32 = 0, s: S1? = nil, e: E2 = E2.A) throws -> (Offset, [Int?]) {
        var valueCursors = [Int?](repeating: nil, count: 3)
        try self.startObject(withPropertyCount: 3)
        valueCursors[2] = try self.insert(value: e.rawValue, defaultValue: E2.A.rawValue, toStartedObjectAt: 2)
        valueCursors[0] = try self.insert(value: i, defaultValue: 0, toStartedObjectAt: 0)
        if let s = s {
            self.insert(value: s)
            valueCursors[1] = try self.insertCurrentOffsetAsProperty(toStartedObjectAt: 1)
        }
        return try (self.endObject(), valueCursors)
    }
}
extension T11 {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }


        let (myOffset, _) = try builder.insertT11(
            i: i,
            s: s,
            e: e ?? E2.A
        )

        if builder.options.uniqueTables {
            builder.cache[ObjectIdentifier(self)] = myOffset
        }

        return myOffset
    }

}
public struct S1: Scalar {
    public let a: Int32
    public let s: S2
    public static func ==(v1:S1, v2:S1) -> Bool {
        return v1.a==v2.a && v1.s==v2.s
    }
}
public struct S2: Scalar {
    public let b: Bool
    public let e: E2
    public static func ==(v1:S2, v2:S2) -> Bool {
        return v1.b==v2.b && v1.e==v2.e
    }
}
public enum E2: Int8, FlatBuffersEnum {
    case A, B
    public static func fromScalar<T>(_ scalar: T) -> E2? where T : Scalar {
        guard let value = scalar as? RawValue else {
            return nil
        }
        return E2(rawValue: value)
    }
}
public final class T2 {
    public var b: Bool
    public var t: T1?
    public init(b: Bool = false, t: T1? = nil) {
        self.b = b
        self.t = t
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}
extension T2.Direct {
    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset? = nil) {
        guard let reader = reader as? T else {
            return nil
        }
        self._reader = reader
        if let myOffset = myOffset {
            self._myOffset = myOffset
        } else {
            if let rootOffset = reader.rootObjectOffset {
                self._myOffset = rootOffset
            } else {
                return nil
            }
        }
    }
    public var hashValue: Int { return Int(_myOffset) }
    public static func ==<T>(t1 : T2.Direct<T>, t2 : T2.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var b: Bool {

        return _reader.get(objectOffset: _myOffset, propertyIndex: 0, defaultValue: false)
    }
    public var t: T1.Direct<T>? {
        guard let offset = _reader.offset(objectOffset: _myOffset, propertyIndex:1) else {return nil}
        return T1.Direct(reader: _reader, myOffset: offset)
    }
}
extension T2 {

    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> T2? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? T2 {
            return o
        }
        let o = T2()
        selfReader._reader.cache?.objectPool[selfReader._myOffset] = o
        o.b = selfReader.b
        o.t = T1.from(selfReader:selfReader.t)

        return o
    }
}
extension FlatBuffersBuilder {
    public func insertT2(b: Bool = false, t: Offset? = nil) throws -> (Offset, [Int?]) {
        var valueCursors = [Int?](repeating: nil, count: 2)
        try self.startObject(withPropertyCount: 2)
        valueCursors[0] = try self.insert(value: b, defaultValue: false, toStartedObjectAt: 0)
        if let t = t {
            valueCursors[1] = try self.insert(offset: t, toStartedObjectAt: 1)
        }
        return try (self.endObject(), valueCursors)
    }
}
extension T2 {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }
        if builder.inProgress.contains(ObjectIdentifier(self)){
            return 0
        }
        builder.inProgress.insert(ObjectIdentifier(self))
        let t = try self.t?.insert(builder)
        let (myOffset, valueCursors) = try builder.insertT2(
            b: b,
            t: t
        )
        if t == 0,
           let o = self.t,
           let cursor = valueCursors[1] {
            builder.deferedBindings.append((o, cursor))
        }
        if builder.options.uniqueTables {
            builder.cache[ObjectIdentifier(self)] = myOffset
        }
        builder.inProgress.remove(ObjectIdentifier(self))
        return myOffset
    }

}
fileprivate func performLateBindings(_ builder : FlatBuffersBuilder) throws {
    for binding in builder.deferedBindings {
        if let offset = builder.cache[ObjectIdentifier(binding.object)] {
            try builder.update(offset: offset, atCursor: binding.cursor)
        } else {
            throw FlatBuffersBuildError.couldNotPerformLateBinding
        }
    }
    builder.deferedBindings.removeAll()
}

"""
        
        let schema = Schema.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        let result = schema?.0.swift
        print(result!)
        XCTAssertEqual(expected, result!)
    }
}
