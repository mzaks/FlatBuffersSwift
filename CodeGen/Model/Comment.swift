//
//  Comment.swift
//  FlatBuffersSwift
//
//  Created by Maxim Zaks on 30.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import Foundation

struct Comment {
    let value: String
}

extension Comment: ASTNode {
    static func with(pointer: UnsafePointer<UInt8>, length: Int) -> (Comment, UnsafePointer<UInt8>)? {
        guard let p1 = eat("//", from: pointer, length: length) else {return nil}
        var p2 = p1
        while p2.pointee != UInt8(10)
            && p2.pointee != UInt8(13)
            && p2.pointee != UInt8(0)
            && p1.distance(to: p2) < length {
            p2 = p2.advanced(by: 1)
        }
        guard let value = String(bytesNoCopy: UnsafeMutableRawPointer(mutating: p1), length: p1.distance(to: p2), encoding: .utf8, freeWhenDone: false) else {
            return nil
        }
        return (Comment(value: value), p2)
    }
}
