//
//  MetaData.swift
//  FlatBuffersSwift
//
//  Created by Maxim Zaks on 17.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import Foundation

struct MetaData {
    let values: [(Ident, ValueLiteral?)]
}

extension MetaData: ASTNode {
    static func with(pointer: UnsafePointer<UInt8>, length: Int) -> (MetaData, UnsafePointer<UInt8>)? {
        guard let p1 = eat("(", from: pointer, length: length) else {return nil}
        var length = length - pointer.distance(to: p1)
        var values = [(Ident, ValueLiteral?)]()
        var p2 = p1
        while let (name, _p2) = Ident.with(pointer: p2, length: length) {
            length -= p2.distance(to: _p2)
            p2 = _p2
            var value : ValueLiteral?
            if let _p3 = eat(":", from: p2, length: length) {
                length -= p2.distance(to: _p3)
                p2 = _p3
                if let (_value, _p4) = ValueLiteral.with(pointer: p2, length: length) {
                    value = _value
                    length -= p2.distance(to: _p4)
                    p2 = _p4
                }
            }
            values.append((name, value))
            guard let _p5 = eat(",", from: p2, length: length) else {break}
            length -= p2.distance(to: _p5)
            p2 = _p5
        }
        
        if values.isEmpty {
            return nil
        }
        
        guard let p3 = eat(")", from: p2, length: length) else {return nil}
        
        return (MetaData(values: values), p3)
    }
}
