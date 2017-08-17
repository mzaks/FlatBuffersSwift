//
//  Field.swift
//  FlatBuffersSwift
//
//  Created by Maxim Zaks on 10.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import Foundation

struct Field {
    let name: Ident
    let type: Type
    let defaultValue: ValueLiteral?
    let defaultIdent: Ident?
    let metaData: MetaData?
}

extension Field: ASTNode {
    static func with(pointer p: UnsafePointer<UInt8>, length: Int) -> (Field, UnsafePointer<UInt8>)? {
        var p0 = p
        var length = length
        var comments = [Comment]()
        while let r = Comment.with(pointer: p0, length: length) {
            comments.append(r.0)
            length -= p0.distance(to: r.1)
            p0 = r.1
        }
        guard let (name, p1) = Ident.with(pointer: p0, length: length) else {return nil}
        length = length - p0.distance(to: p1)
        guard let p2 = eat(":", from: p1, length: length) else {return nil}
        length -= p1.distance(to: p2)
        guard let (type, p3) = Type.with(pointer: p2, length: length) else {return nil}
        length -= p2.distance(to: p3)
        var p5 = p3
        var defaultValue: ValueLiteral? = nil
        var defaultIdent: Ident? = nil
        if let p4 = eat("=", from: p3, length: length) {
            length -= p3.distance(to: p4)
            if let r = ValueLiteral.with(pointer: p4, length: length) {
                defaultValue = r.0
                p5 = r.1
            } else if let r = Ident.with(pointer: p4, length: length) {
                defaultIdent = r.0
                p5 = r.1
            } else {
                return nil
            }
            length -= p4.distance(to:p5)
        }
        var p6 = p5
        var metaData: MetaData? = nil
        if let r = MetaData.with(pointer: p6, length: length) {
            metaData = r.0
            length -= p6.distance(to: r.1)
            p6 = r.1
        }
        guard let p7 = eat(";", from: p6, length: length) else {return nil}
        return (Field(name: name, type: type, defaultValue: defaultValue, defaultIdent: defaultIdent, metaData: metaData), p7)
    }
}

extension Field {
    var id: String? {
        let idMeta = metaData?.values.first { (arg0) -> Bool in
            let (ident, _) = arg0
            return ident.value == "id"
        }
        return idMeta?.1?.value
    }
    var isDeprecated: Bool {
        let deprecatedMetaData = metaData?.values.first { (arg0) -> Bool in
            let (ident, _) = arg0
            return ident.value == "deprecated"
        }
        return deprecatedMetaData != nil
    }
    var fieldName: String {
        return isDeprecated ? "__\(name.value)" : name.value
    }
}
