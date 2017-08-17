//
//  ASTNode.swift
//  CodeGen
//
//  Created by Maxim Zaks on 10.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import Foundation

protocol ASTNode {
    static func with(pointer: UnsafePointer<UInt8>, length: Int) -> (Self, UnsafePointer<UInt8>)?
}

func eat(_ s: StaticString, from p: UnsafePointer<UInt8>, length: Int) -> UnsafePointer<UInt8>? {
    guard let p1 = eatWhiteSpace(p, length: length) else {return nil}
    let count = s.utf8CodeUnitCount
    guard count + p.distance(to: p1) <= length else {return nil}
    for i in 0 ..< count {
        if s.utf8Start.advanced(by: i).pointee != p1.advanced(by: i).pointee {
            return nil
        }
    }
    return p1.advanced(by: count)
}

func eatWhiteSpace(_ p: UnsafePointer<UInt8>, length: Int) -> UnsafePointer<UInt8>? {
    var p1 = p
    while p1.pointee < 33 {
        p1 = p1.advanced(by: 1)
        if p.distance(to: p1) > length {
            return nil
        }
    }
    return p1
}

func parserError(_ p: UnsafePointer<UInt8>, length: Int) -> Never {
    guard let value = String(bytesNoCopy: UnsafeMutableRawPointer(mutating: p), length: length, encoding: .utf8, freeWhenDone: false) else {
        fatalError("Parser error unknown")
    }
    fatalError("parser error after: \(value)")
}

let A_Z = (UInt8(65)...90)
let a_z = (UInt8(97)...122)
let _0_9 = (UInt8(48)...57)
let __ = UInt8(95)
