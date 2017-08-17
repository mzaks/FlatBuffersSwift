//
//  StringLiteral.swift
//  CodeGen
//
//  Created by Maxim Zaks on 10.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import Foundation

struct StringLiteral {
    let value: String
}

extension StringLiteral: ASTNode {
    static func with(pointer: UnsafePointer<UInt8>, length: Int) -> (StringLiteral, UnsafePointer<UInt8>)? {
        guard let p1 = eat("\"", from: pointer, length: length) else {return nil}
        var p2 = p1
        while p2.pointee != UInt8(34) && p1.distance(to: p2) < length {
            p2 = p2.advanced(by: 1)
        }
        guard let p3 = eat("\"", from: p2, length: length) else {return nil}
        guard let value = String(bytesNoCopy: UnsafeMutableRawPointer(mutating: p1), length: p1.distance(to: p2), encoding: .utf8, freeWhenDone: false) else {
            return nil
        }
        return (StringLiteral(value: value), p3)
    }
}
