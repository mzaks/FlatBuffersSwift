//
//  Sample2.swift
//  CodeGen
//
//  Created by Maxim Zaks on 26.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import Foundation

/*
public enum Foo2 {
    case tableA(A), tableB(B)
    fileprivate static func from(selfReader: Foo2.Direct<FlatBuffersMemoryReader>?) -> Foo2? {
        guard let selfReader = selfReader else {
            return nil
        }
        switch selfReader {
        case .tableA(let o):
            guard let o1 = A.from(selfReader: o) else {
                return nil
            }
            return .tableA(o1)
        case .tableB(let o):
            guard let o1 = B.from(selfReader: o) else {
                return nil
            }
            return .tableB(o1)
        }
    }
    public enum Direct<R : FlatBuffersReader> {
        case tableA(A.Direct<R>), tableB(B.Direct<R>)
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
                return Foo2.Direct.tableA(o)
            case 2:
                guard let o = B.Direct<R>(reader: reader, myOffset: caseObjectOffset) else {
                    return nil
                }
                return Foo2.Direct.tableB(o)
            default:
                break
            }
            return nil
        }
    }
}


public enum U1 {
    case a(A), b(B)
    fileprivate static func from(selfReader: U1.Direct<FlatBuffersMemoryReader>?) -> U1? {
        guard let selfReader = selfReader else {
            return nil
        }
        switch selfReader {
        case .a(let o):
            guard let o1 = A.from(selfReader: o) else {
                return nil
            }
            return .a(o1)
        case .b(let o):
            guard let o1 = B.from(selfReader: o) else {
                return nil
            }
            return .b(o1)
        }
    }
    public enum Direct<R : FlatBuffersReader> {
        case a(A.Direct<R>), b(B.Direct<R>)
        fileprivate static func from(reader: R, propertyIndex : Int, objectOffset : Offset?) -> U1.Direct<R>? {
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
                return U1.Direct.a(o)
            case 2:
                guard let o = B.Direct<R>(reader: reader, myOffset: caseObjectOffset) else {
                    return nil
                }
                return U1.Direct.b(o)
            default:
                break
            }
            return nil
        }
    }
}
*/
public final class A {
    var b: Bool
    init(b: Bool = false) {
        self.b = b
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}

extension A.Direct {
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
    public static func ==<T>(t1 : A.Direct<T>, t2 : A.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var b: Bool {
        return _reader.get(objectOffset: _myOffset, propertyIndex: 0, defaultValue: false)
    }
}

extension A {
    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> A? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? A {
            return o
        }
        return A(
            b: selfReader.b
        )
    }
}

public final class B {
    var i: Int
    init(i: Int = 0) {
        self.i = i
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}

extension B.Direct {
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
    public static func ==<T>(t1 : B.Direct<T>, t2 : B.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var i: Int {
        return _reader.get(objectOffset: _myOffset, propertyIndex: 0, defaultValue: 0)
    }
}

extension B {
    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> B? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? B {
            return o
        }
        return B(
            i: selfReader.i
        )
    }
}
