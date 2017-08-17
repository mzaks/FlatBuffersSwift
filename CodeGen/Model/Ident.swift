//
//  Ident.swift
//  CodeGen
//
//  Created by Maxim Zaks on 10.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import Foundation

struct Ident {
    let value: String
}

extension Ident: ASTNode {
    static func with(pointer p: UnsafePointer<UInt8>, length: Int) -> (Ident, UnsafePointer<UInt8>)? {
        guard let p1 = eatWhiteSpace(p, length: length) else {return nil}
        guard A_Z.contains(p1.pointee) || a_z.contains(p1.pointee) || __ == p1.pointee else {
            return nil
        }
        var p2 = p1
        while A_Z.contains(p2.pointee)
            || a_z.contains(p2.pointee)
            || _0_9.contains(p2.pointee)
            || __ == p2.pointee {
                p2 = p2.advanced(by: 1)
        }
        guard let value = String(bytesNoCopy: UnsafeMutableRawPointer(mutating: p1), length: p1.distance(to: p2), encoding: .utf8, freeWhenDone: false) else {
            return nil
        }
        return (Ident(value: value), p2)
    }
}
