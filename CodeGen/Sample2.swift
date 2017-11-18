//
//  Sample2.swift
//  CodeGen
//
//  Created by Maxim Zaks on 26.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import Foundation

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
    
    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> T1? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? T1 {
            return o
        }
        return T1(
            u: U.from(selfReader: selfReader.u),
            s: selfReader.s
        )
    }
}
extension FlatBuffersBuilder {
    public func insertT1(u_type: Int8 = 0, u: Offset? = nil, s: S1? = nil) throws -> Offset {
        try self.startObject(withPropertyCount: 3)
        try self.insert(value: u_type, defaultValue: 0, toStartedObjectAt: 0)
        if let u = u {
            try self.insert(offset: u, toStartedObjectAt: 1)
        }
        if let s = s {
            self.insert(value: s)
            try self.insertCurrentOffsetAsProperty(toStartedObjectAt: 2)
        }
        return try self.endObject()
    }
}
extension T1 {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }
        let u = try self.u?.insert(builder)
        let u_type = self.u?.unionCase ?? 0
        return try builder.insertT1(
            u_type: u_type,
            u: u,
            s: s
        )
    }
}
public enum U {
    case tableT11(T11), tableT2(T2)
    fileprivate static func from(selfReader: U.Direct<FlatBuffersMemoryReader>?) -> U? {
        guard let selfReader = selfReader else {
            return nil
        }
        switch selfReader {
        case .tableT11(let o):
            guard let o1 = T11.from(selfReader: o) else {
                return nil
            }
            return .tableT11(o1)
        case .tableT2(let o):
            guard let o1 = T2.from(selfReader: o) else {
                return nil
            }
            return .tableT2(o1)
        }
    }
    public enum Direct<R : FlatBuffersReader> {
        case tableT11(T11.Direct<R>), tableT2(T2.Direct<R>)
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
                return U.Direct.tableT11(o)
            case 2:
                guard let o = T2.Direct<R>(reader: reader, myOffset: caseObjectOffset) else {
                    return nil
                }
                return U.Direct.tableT2(o)
            default:
                break
            }
            return nil
        }
    }
    var unionCase: Int8 {
        switch self {
        case .tableT11(_): return 1
        case .tableT2(_): return 2
        }
    }
    func insert(_ builder: FlatBuffersBuilder) throws -> Offset {
        switch self {
        case .tableT11(let o): return try o.insert(builder)
        case .tableT2(let o): return try o.insert(builder)
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
        return T11(
            i: selfReader.i,
            s: selfReader.s,
            e: selfReader.e
        )
    }
}
extension FlatBuffersBuilder {
    public func insertT11(i: Int32 = 0, s: S1? = nil, e: E2 = E2.A) throws -> Offset {
        try self.startObject(withPropertyCount: 3)
        try self.insert(value: e.rawValue, defaultValue: E2.A.rawValue, toStartedObjectAt: 2)
        try self.insert(value: i, defaultValue: 0, toStartedObjectAt: 0)
        if let s = s {
            self.insert(value: s)
            try self.insertCurrentOffsetAsProperty(toStartedObjectAt: 1)
        }
        return try self.endObject()
    }
}
extension T11 {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }
        
        return try builder.insertT11(
            i: i,
            s: s,
            e: e ?? E2.A
        )
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
        return T1.Direct(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:1))
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
        return T2(
            b: selfReader.b,
            t: T1.from(selfReader:selfReader.t)
        )
    }
}
extension FlatBuffersBuilder {
    public func insertT2(b: Bool = false, t: Offset? = nil) throws -> Offset {
        try self.startObject(withPropertyCount: 2)
        try self.insert(value: b, defaultValue: false, toStartedObjectAt: 0)
        if let t = t {
            try self.insert(offset: t, toStartedObjectAt: 1)
        }
        return try self.endObject()
    }
}
extension T2 {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }
        let t = try self.t?.insert(builder)
        return try builder.insertT2(
            b: b,
            t: t
        )
    }
}
