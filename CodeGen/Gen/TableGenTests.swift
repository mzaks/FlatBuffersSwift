//
//  TableGenTests.swift
//  CodeGenTests
//
//  Created by Maxim Zaks on 22.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import XCTest

class TableGenTests: XCTestCase {
    let s: StaticString = """
struct S1 {
    a: bool;
}
table T0 {
    a: string;
}
enum E: byte {A, B}
union U1 {T0, T1}
table T1 {
    i: int;
    b: bool;
    d: double (deprecated);
    bs: [bool];
    name: string;
    names: [string];
    _self: T0;
    selfs: [T0];
    s: S1;
    s_s: [S1];
    e: E;
    es: [E];
    u: U1;
}
"""
    
    func testProtocolReaderExtension() {
        let expected = """
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
    public var i: Int32 {
        return _reader.get(objectOffset: _myOffset, propertyIndex: 0, defaultValue: 0)
    }
    public var b: Bool {
        return _reader.get(objectOffset: _myOffset, propertyIndex: 1, defaultValue: false)
    }
    public var __d: Float64 {
        return _reader.get(objectOffset: _myOffset, propertyIndex: 2, defaultValue: 0)
    }
    public var bs: FlatBuffersScalarVector<Bool, T> {
        return FlatBuffersScalarVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:3))
    }
    public var name: UnsafeBufferPointer<UInt8>? {
        return _reader.stringBuffer(stringOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:4))
    }
    public var names: FlatBuffersStringVector<T> {
        return FlatBuffersStringVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:5))
    }
    public var _self: T0.Direct<T>? {
        return T0.Direct(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:6))
    }
    public var selfs: FlatBuffersTableVector<T0.Direct<T>, T> {
        return FlatBuffersTableVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:7))
    }
    public var s: S1? {
        return _reader.get(objectOffset: _myOffset, propertyIndex: 8)
    }
    public var s_s: FlatBuffersScalarVector<S1, T> {
        return FlatBuffersScalarVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:9))
    }
    public var e: E? {
        return E(rawValue:_reader.get(objectOffset: _myOffset, propertyIndex: 10, defaultValue: E.A.rawValue))
    }
    public var es: FlatBuffersEnumVector<Int8, T, E> {
        return FlatBuffersEnumVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:11))
    }
    public var u: U1.Direct<T>? {
        return U1.Direct.from(reader: _reader, propertyIndex : 12, objectOffset : _myOffset)
    }
}
"""
        let schema = Schema.with(pointer:s.utf8Start, length: s.utf8CodeUnitCount)?.0
        let lookup = schema?.identLookup
        let table = lookup?.tables["T1"]
        let result = table?.readerProtocolExtension(lookup: lookup!)
        print(result!)
        XCTAssertEqual(expected, result)
    }
    
    func testProtocolReaderExtensionWithExplicitIndex() {
        let s: StaticString = """
table T1 {
    i: int (id: 1);
    b: bool (id: 0);
    d: double (id: 2, deprecated);
}
"""
        let expected = """
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
    public var b: Bool {
        return _reader.get(objectOffset: _myOffset, propertyIndex: 0, defaultValue: false)
    }
    public var i: Int32 {
        return _reader.get(objectOffset: _myOffset, propertyIndex: 1, defaultValue: 0)
    }
    public var __d: Float64 {
        return _reader.get(objectOffset: _myOffset, propertyIndex: 2, defaultValue: 0)
    }
}
"""
        let schema = Schema.with(pointer:s.utf8Start, length: s.utf8CodeUnitCount)?.0
        let lookup = schema?.identLookup
        let table = lookup?.tables["T1"]
        let result = table?.readerProtocolExtension(lookup: lookup!)
        print(result!)
        XCTAssertEqual(expected, result)
    }
    
    func testSwiftClass() {
        let expected = """
public final class T1 {
    public var i: Int32
    public var b: Bool
    public var __d: Float64
    public var bs: [Bool]
    public var name: String?
    public var names: [String]
    public var _self: T0?
    public var selfs: [T0]
    public var s: S1?
    public var s_s: [S1]
    public var e: E?
    public var es: [E]
    public var u: U1?
    public init(i: Int32 = 0, b: Bool = false, __d: Float64 = 0, bs: [Bool] = [], name: String? = nil, names: [String] = [], _self: T0? = nil, selfs: [T0] = [], s: S1? = nil, s_s: [S1] = [], e: E? = E.A, es: [E] = [], u: U1? = nil) {
        self.i = i
        self.b = b
        self.__d = __d
        self.bs = bs
        self.name = name
        self.names = names
        self._self = _self
        self.selfs = selfs
        self.s = s
        self.s_s = s_s
        self.e = e
        self.es = es
        self.u = u
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}
"""
        let schema = Schema.with(pointer:s.utf8Start, length: s.utf8CodeUnitCount)?.0
        let lookup = schema?.identLookup
        let table = lookup?.tables["T1"]
        let result = table?.swiftClass(lookup: lookup!)
        print(result!)
        XCTAssertEqual(expected, result)
    }
    
    func testFromData() {
        let expected = """
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
        return T1(
            i: selfReader.i,
            b: selfReader.b,
            __d: selfReader.__d,
            bs: selfReader.bs.flatMap{$0},
            name: selfReader.name§,
            names: selfReader.names.flatMap{ $0§ },
            _self: T0.from(selfReader:selfReader._self),
            selfs: selfReader.selfs.flatMap{ T0.from(selfReader:$0) },
            s: selfReader.s,
            s_s: selfReader.s_s.flatMap{$0},
            e: selfReader.e,
            es: selfReader.es.flatMap{$0},
            u: U1.from(selfReader: selfReader.u)
        )
    }
}
"""
        let schema = Schema.with(pointer:s.utf8Start, length: s.utf8CodeUnitCount)?.0
        let lookup = schema?.identLookup
        let table = lookup?.tables["T1"]
        let result = table?.fromDataExtenstion(lookup: lookup!, isRoot: true)
        print(result!)
        XCTAssertEqual(expected, result)
    }
    
    func testInsertExtension() {
        let expected = """
extension FlatBuffersBuilder {
    public func insertT1(i: Int32 = 0, b: Bool = false, bs: Offset? = nil, name: Offset? = nil, names: Offset? = nil, _self: Offset? = nil, selfs: Offset? = nil, s: S1? = nil, s_s: Offset? = nil, e: E = E.A, es: Offset? = nil, u_type: Int8 = 0, u: Offset? = nil) throws -> Offset {
        try self.startObject(withPropertyCount: 14)
        try self.insert(value: b, defaultValue: false, toStartedObjectAt: 1)
        if let s = s {
            self.insert(value: s)
            try self.insertCurrentOffsetAsProperty(toStartedObjectAt: 8)
        }
        try self.insert(value: e.rawValue, defaultValue: E.A.rawValue, toStartedObjectAt: 10)
        try self.insert(value: u_type, defaultValue: 0, toStartedObjectAt: 12)
        try self.insert(value: i, defaultValue: 0, toStartedObjectAt: 0)
        if let bs = bs {
            try self.insert(offset: bs, toStartedObjectAt: 3)
        }
        if let name = name {
            try self.insert(offset: name, toStartedObjectAt: 4)
        }
        if let names = names {
            try self.insert(offset: names, toStartedObjectAt: 5)
        }
        if let _self = _self {
            try self.insert(offset: _self, toStartedObjectAt: 6)
        }
        if let selfs = selfs {
            try self.insert(offset: selfs, toStartedObjectAt: 7)
        }
        if let s_s = s_s {
            try self.insert(offset: s_s, toStartedObjectAt: 9)
        }
        if let es = es {
            try self.insert(offset: es, toStartedObjectAt: 11)
        }
        if let u = u {
            try self.insert(offset: u, toStartedObjectAt: 13)
        }
        return try self.endObject()
    }
}
"""
        let schema = Schema.with(pointer:s.utf8Start, length: s.utf8CodeUnitCount)?.0
        let lookup = schema?.identLookup
        let table = lookup?.tables["T1"]
        let result = table?.insertExtenstion(lookup: lookup!)
        print(result!)
        XCTAssertEqual(expected, result)
    }
    
    func testInsertMethod() {
        let expected = """
extension T1 {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }
        let bs: Offset?
        if self.bs.isEmpty {
            bs = nil
        } else {
            try builder.startVector(count: self.bs.count, elementSize: MemoryLayout<Bool>.stride)
            for o in self.bs.reversed() {
                builder.insert(value: o)
            }
            bs = builder.endVector()
        }
        let name = self.name == nil ? nil : try builder.insert(value: self.name)
        let names = self.names == nil ? nil : try builder.insert(value: self.names)
        let _self = try self._self?.insert(builder)
        let selfs: Offset?
        if self.selfs.isEmpty {
            selfs = nil
        } else {
            let offsets = try self.selfs.map{ try $0.insert(builder) }
            try builder.startVector(count: self.selfs.count, elementSize: MemoryLayout<Offset>.stride)
            for o in offsets.reversed() {
                builder.insert(value: o)
            }
            selfs = builder.endVector()
        }
        let s_s: Offset?
        if self.s_s.isEmpty {
            s_s = nil
        } else {
            try builder.startVector(count: self.s_s.count, elementSize: MemoryLayout<S1>.stride)
            for o in self.s_s.reversed() {
                builder.insert(value: o)
            }
            s_s = builder.endVector()
        }
        let es: Offset?
        if self.es.isEmpty {
            es = nil
        } else {
            try builder.startVector(count: self.es.count, elementSize: MemoryLayout<E>.stride)
            for o in self.es.reversed() {
                builder.insert(value: o.rawValue)
            }
            es = builder.endVector()
        }
        let u = try self.u?.insert(builder)
        let u_type = try self.u?.unionCase ?? 0
        return try builder.insertT1(
            i: i,
            b: b,
            bs: bs,
            name: name,
            names: names,
            _self: _self,
            selfs: selfs,
            s: s,
            s_s: s_s,
            e: e ?? E.A,
            es: es,
            u_type: u_type,
            u: u
        )
    }
}
"""
        let schema = Schema.with(pointer:s.utf8Start, length: s.utf8CodeUnitCount)?.0
        let lookup = schema?.identLookup
        let table = lookup?.tables["T1"]
        let result = table?.insertMethod(lookup: lookup!)
        print(result!)
        XCTAssertEqual(expected, result)
    }
    
    func testGenAll() {
        let schema = Schema.with(pointer:s.utf8Start, length: s.utf8CodeUnitCount)?.0
        let lookup = schema!.identLookup
        print(lookup.enums["E"]!.swift)
        print(lookup.structs["S1"]!.swift)
        print(lookup.unions["U1"]!.swift)
        let t0 = lookup.tables["T0"]!
        print(t0.readerProtocolExtension(lookup: lookup))
        print(t0.swiftClass(lookup: lookup))
        print(t0.fromDataExtenstion(lookup: lookup))
        let t1 = lookup.tables["T1"]!
        print(t1.readerProtocolExtension(lookup: lookup))
        print(t1.swiftClass(lookup: lookup))
        print(t1.fromDataExtenstion(lookup: lookup))
    }
}
