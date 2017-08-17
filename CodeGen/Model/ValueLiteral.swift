//
//  ValueLiteral.swift
//  FlatBuffersSwift
//
//  Created by Maxim Zaks on 10.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import Foundation

struct ValueLiteral {
    let value: String
}

extension ValueLiteral: ASTNode {
    static func with(pointer: UnsafePointer<UInt8>, length: Int) -> (ValueLiteral, UnsafePointer<UInt8>)? {
        guard let p1 = eatWhiteSpace(pointer, length: length) else {return nil}
        var length = length - pointer.distance(to: p1)
        if let p2 = eat("\"", from: p1, length: length) {
            length -= p1.distance(to: p2)
            var p3 = p2
            while p3.pointee != UInt8(34) {
                p3 = p3.advanced(by: 1)
                if p2.distance(to: p3) > length {
                    return nil
                }
            }
            guard let p4 = eat("\"", from: p3, length: length) else {return nil}
            guard let value = String(bytesNoCopy: UnsafeMutableRawPointer(mutating: p1), length: p1.distance(to: p4), encoding: .utf8, freeWhenDone: false) else {
                return nil
            }
            return (ValueLiteral(value: value), p4)
        }
        if p1.pointee == UInt8(45) || _0_9.contains(p1.pointee) {
            var p2 = p1
            while p2.pointee == UInt8(45) // -
                || p2.pointee == UInt8(43) // +
                || p2.pointee == UInt8(46) // .
                || p2.pointee == UInt8(69) // E
                || p2.pointee == UInt8(101) // e
                || _0_9.contains(p2.pointee) {
                    p2 = p2.advanced(by: 1)
                    if p1.distance(to: p2) > length {
                        return nil
                    }
            }
            guard let value = String(bytesNoCopy: UnsafeMutableRawPointer(mutating: p1), length: p1.distance(to: p2), encoding: .utf8, freeWhenDone: false) else {
                return nil
            }
            return (ValueLiteral(value: value), p2)
        }
        if let p2 = eat("true", from: p1, length: length) {
            return (ValueLiteral(value: "true"), p2)
        }
        if let p2 = eat("false", from: p1, length: length) {
            return (ValueLiteral(value: "false"), p2)
        }
        return nil
    }
}
