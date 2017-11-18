//
//  Enum.swift
//  FlatBuffersSwift
//
//  Created by Maxim Zaks on 18.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import Foundation

struct EnumCase {
    let ident: Ident
    let value: ValueLiteral?
}

extension EnumCase: ASTNode {
    static func with(pointer: UnsafePointer<UInt8>, length: Int) -> (EnumCase, UnsafePointer<UInt8>)? {
        guard let (name, p1) = Ident.with(pointer: pointer, length: length) else {return nil}
        var length = length - pointer.distance(to: p1)
        if let p2 = eat("=", from: p1, length: length) {
            length -= p1.distance(to: p2)
            if let r = ValueLiteral.with(pointer: p2, length: length) {
                return (EnumCase(ident: name, value: r.0), r.1)
            } else {
                return nil
            }
        }
        return (EnumCase(ident: name, value: nil), p1)
    }
}

struct Enum {
    let name: Ident
    let type: Type
    let cases: [EnumCase]
    let metaData: MetaData?
    let comments: [Comment]
}

extension Enum: ASTNode {
    static func with(pointer: UnsafePointer<UInt8>, length: Int) -> (Enum, UnsafePointer<UInt8>)? {
        var p0 = pointer
        var length = length
        var comments = [Comment]()
        while let r = Comment.with(pointer: p0, length: length) {
            comments.append(r.0)
            length -= p0.distance(to: r.1)
            p0 = r.1
        }
        guard let p1 = eat("enum", from: p0, length: length) else {return nil}
        length = length - p0.distance(to: p1)
        guard let (name, p2) = Ident.with(pointer: p1, length: length) else {return nil}
        length -= p1.distance(to: p2)
        guard let p2_01 = eat(":", from: p2, length: length) else {return nil}
        length = length - p2.distance(to: p2_01)
        guard let (type, p2_02) = Type.with(pointer: p2_01, length: length) else {return nil}
        length = length - p2_01.distance(to: p2_02)
        var p2_1 = p2_02
        var metaData: MetaData? = nil
        if let r = MetaData.with(pointer: p2_1, length: length) {
            metaData = r.0
            length -= p2_1.distance(to: r.1)
            p2_1 = r.1
        }
        guard let p3 = eat("{", from: p2_1, length: length) else {return nil}
        length -= p2_1.distance(to: p3)
        var cases = [EnumCase]()
        var p4 = p3
        while let (_case, _p4) = EnumCase.with(pointer: p4, length: length) {
            cases.append(_case)
            length -= p4.distance(to: _p4)
            p4 = _p4
            guard let _p5 = eat(",", from: p4, length: length) else {break}
            length -= p4.distance(to: _p5)
            p4 = _p5
        }
        guard let p5 = eat("}", from: p4, length: length) else {return nil}
        return (Enum(name: name, type: type, cases: cases, metaData: metaData, comments: comments), p5)
    }
}

extension Enum {
    var swift: String {
        if type.vector {fatalError("enum \(name.value) type cannot be a vector")}
        if type.string {fatalError("enum \(name.value) type cannot be a string")}
        if type.ref != nil {fatalError("enum \(name.value) type cannot be \(type.ref!.value)")}
        if type.scalar == .bool {fatalError("enum \(name.value) type cannot be bool")}
        if type.scalar == .f32 {fatalError("enum \(name.value) type cannot be float")}
        if type.scalar == .f64 {fatalError("enum \(name.value) type cannot be double")}
        if cases.isEmpty {fatalError("enum \(name.value) does not have cases")}
        if let v = cases[0].value, v.value != "0" {fatalError("enum \(name.value) first case is not 0")}
        func gen(_ cases: [EnumCase]) -> String{
            let result: [String] = cases.map {
                var s = $0.ident.value
                if let v = $0.value {
                    s = "\(s) = \(v.value)"
                }
                return s
            }
            return result.joined(separator: ", ")
        }
        return """
public enum \(self.name.value): \(type.swift), FlatBuffersEnum {
    case \(gen(cases))
    public static func fromScalar<T>(_ scalar: T) -> \(self.name.value)? where T : Scalar {
        guard let value = scalar as? RawValue else {
            return nil
        }
        return \(self.name.value)(rawValue: value)
    }
}
"""
    }
}
