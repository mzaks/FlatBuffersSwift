//
//  Type.swift
//  CodeGen
//
//  Created by Maxim Zaks on 10.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import Foundation

struct Type {
    let scalar: Scalar?
    let vector: Bool
    let ref: Ident?
    let string: Bool
    enum Scalar {
        case i8, u8, i16, u16, i32, u32, i64, u64, f32, f64, bool
        var swift: String {
            switch self {
            case .i8:
                return "Int8"
            case .u8:
                return "UInt8"
            case .i16:
                return "Int16"
            case .u16:
                return "UInt16"
            case .i32:
                return "Int32"
            case .u32:
                return "UInt32"
            case .i64:
                return "Int64"
            case .u64:
                return "UInt64"
            case .f32:
                return "Float32"
            case .f64:
                return "Float64"
            case .bool:
                return "Bool"
            }
        }
        var defaultValue: String {
            return self == .bool ? "false" : "0"
        }
        var swiftSize: Int {
            switch self {
            case .i8:
                return 1
            case .u8:
                return 1
            case .i16:
                return 2
            case .u16:
                return 2
            case .i32:
                return 4
            case .u32:
                return 4
            case .i64:
                return 8
            case .u64:
                return 8
            case .f32:
                return 4
            case .f64:
                return 8
            case .bool:
                return 1
            }
        }
    }
    var swift: String {
        var value = ""
        if string {
            value = "String"
        } else if let ref = ref {
            value = ref.value
        } else if let scalar = scalar {
            value = scalar.swift
        }
        if vector {
            return "[\(value)]"
        }
        return value
    }
    func swiftFB(lookup: IdentLookup) -> String {
        var value = ""
        if string {
            value = "Offset?"
        } else if let ref = ref {
            if lookup.enums[ref.value] != nil{
                value = ref.value
            } else if lookup.structs[ref.value] != nil {
                value = ref.value + "?"
            } else {
                value = "Offset?"
            }
        } else if let scalar = scalar {
            value = scalar.swift
        }
        if vector {
            return "Offset?"
        }
        return value
    }
    var swiftWithOptional: String {
        let value = swift
        if vector == false {
            if string {
                return "String?"
            } else if let ref = ref {
                return ref.value + "?"
            }
        }
        return value
    }
    func defaultValue(lookup: IdentLookup) -> String {
        if vector {
            return "[]"
        } else if let ref = ref {
            if let e = lookup.enums[ref.value]{
                return e.name.value + "." + e.cases[0].ident.value
            }
            return "nil"
        } else if let scalar = scalar {
            return scalar.defaultValue
        } else if string {
            return "nil"
        }
        fatalError("Unexpected case")
    }
    func defaultValueFB(lookup: IdentLookup) -> String {
        if vector {
            return "nil"
        } else if let ref = ref {
            if let e = lookup.enums[ref.value]{
                return e.name.value + "." + e.cases[0].ident.value
            }
            return "nil"
        } else if let scalar = scalar {
            return scalar.defaultValue
        } else if string {
            return "nil"
        }
        fatalError("Unexpected case")
    }
    
    func swiftSize(lookup: IdentLookup) -> Int {
        if string || vector {
            return 4
        }
        if let scalar = self.scalar {
            return scalar.swiftSize
        }
        if let ref = self.ref {
            if lookup.tables[ref.value] != nil || lookup.unions[ref.value] != nil {
                return 4
            }
            if let _enum = lookup.enums[ref.value] {
                return _enum.type.swiftSize(lookup:lookup)
            }
            if let _struct = lookup.structs[ref.value] {
                return _struct.swiftSize(lookup:lookup)
            }
        }
        fatalError("Unexpected case")
    }
    
    func isTable(_ lookup: IdentLookup) -> Bool {
        if let ref = ref?.value {
            return lookup.tables[ref] != nil
        }
        return false
    }
    func isUnion(_ lookup: IdentLookup) -> Bool {
        if let ref = ref?.value {
            return lookup.unions[ref] != nil
        }
        return false
    }
    func isStruct(_ lookup: IdentLookup) -> Bool {
        if let ref = ref?.value {
            return lookup.structs[ref] != nil
        }
        return false
    }
    func isEnum(_ lookup: IdentLookup) -> Bool {
        if let ref = ref?.value {
            return lookup.enums[ref] != nil
        }
        return false
    }
    func isRecursive(_ lookup: IdentLookup) -> Bool {
        guard let ref = ref?.value else { return false }
        if let table = lookup.tables[ref] {
            return table.findCycle(lookup: lookup, visited: [])
        }
        if let union = lookup.unions[ref]{
            for indent in union.cases {
                if let table = lookup.tables[indent.value] {
                    if table.findCycle(lookup: lookup, visited: []) {
                        return true
                    }
                }
            }
        }
        return false
    }
}

extension Type: ASTNode {
    static func with(pointer p: UnsafePointer<UInt8>, length: Int) -> (Type, UnsafePointer<UInt8>)? {
        guard let p1 = eatWhiteSpace(p, length: length) else {return nil}
        var length = length - p.distance(to: p1)
        if let p2 = eat("[", from: p1, length: length) {
            length -= 1
            if let (t, p3) = Type.with(pointer: p2, length: length) {
                length -= p2.distance(to: p3)
                if let p4 = eat("]", from: p3, length: length) {
                    return (Type(scalar: t.scalar, vector: true, ref: t.ref, string: t.string), p4)
                }
            }
            return nil
        }
        if let p2 = eat("bool", from: p1, length: length) {
            return (Type(scalar: .bool, vector: false, ref: nil, string: false), p2)
        }
        if let p2 = eat("byte", from: p1, length: length) {
            return (Type(scalar: .i8, vector: false, ref: nil, string: false), p2)
        }
        if let p2 = eat("ubyte", from: p1, length: length) {
            return (Type(scalar: .u8, vector: false, ref: nil, string: false), p2)
        }
        if let p2 = eat("short", from: p1, length: length) {
            return (Type(scalar: .i16, vector: false, ref: nil, string: false), p2)
        }
        if let p2 = eat("ushort", from: p1, length: length) {
            return (Type(scalar: .u16, vector: false, ref: nil, string: false), p2)
        }
        if let p2 = eat("int", from: p1, length: length) {
            return (Type(scalar: .i32, vector: false, ref: nil, string: false), p2)
        }
        if let p2 = eat("uint", from: p1, length: length) {
            return (Type(scalar: .u32, vector: false, ref: nil, string: false), p2)
        }
        if let p2 = eat("long", from: p1, length: length) {
            return (Type(scalar: .i64, vector: false, ref: nil, string: false), p2)
        }
        if let p2 = eat("ulong", from: p1, length: length) {
            return (Type(scalar: .u64, vector: false, ref: nil, string: false), p2)
        }
        if let p2 = eat("float", from: p1, length: length) {
            return (Type(scalar: .f32, vector: false, ref: nil, string: false), p2)
        }
        if let p2 = eat("double", from: p1, length: length) {
            return (Type(scalar: .f64, vector: false, ref: nil, string: false), p2)
        }
        if let p2 = eat("string", from: p1, length: length) {
            return (Type(scalar: nil, vector: false, ref: nil, string: true), p2)
        }
        if let (name, p2) = Ident.with(pointer: p, length: length) {
            return (Type(scalar: nil, vector: false, ref: name, string: false), p2)
        }
        return nil
    }
}
