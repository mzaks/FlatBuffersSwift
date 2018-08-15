//
//  Table.swift
//  CodeGen
//
//  Created by Maxim Zaks on 10.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import Foundation

struct Table {
    let name: Ident
    let fields: [Field]
    let metaData: MetaData?
    let comments: [Comment]
}

struct Struct {
    let name: Ident
    let fields: [Field]
    let metaData: MetaData?
    let comments: [Comment]
}

extension Table: ASTNode {
    static func with(pointer: UnsafePointer<UInt8>, length: Int) -> (Table, UnsafePointer<UInt8>)? {
        guard let r = parse("table", pointer: pointer, length: length) else {
            return nil
        }
        return (Table(name: r.0.name, fields: r.0.fields, metaData: r.0.metaData, comments: r.0.comments), r.1)
    }
}

extension Struct: ASTNode {
    static func with(pointer: UnsafePointer<UInt8>, length: Int) -> (Struct, UnsafePointer<UInt8>)? {
        guard let r = parse("struct", pointer: pointer, length: length) else {
            return nil
        }
        return (Struct(name: r.0.name, fields: r.0.fields, metaData: r.0.metaData, comments: r.0.comments), r.1)
    }
}

fileprivate func parse(_ prefix: StaticString, pointer: UnsafePointer<UInt8>, length: Int) -> ((name: Ident, fields: [Field], metaData: MetaData?, comments: [Comment]), UnsafePointer<UInt8>)? {
    var p0 = pointer
    var length = length
    var comments = [Comment]()
    while let r = Comment.with(pointer: p0, length: length) {
        comments.append(r.0)
        length -= p0.distance(to: r.1)
        p0 = r.1
    }
    guard let p1 = eat(prefix, from: p0, length: length) else {return nil}
    length = length - p0.distance(to: p1)
    guard let (name, p2) = Ident.with(pointer: p1, length: length) else {parserError(pointer, length: pointer.distance(to: p1))}
    length -= p1.distance(to: p2)
    var p2_1 = p2
    var metaData: MetaData? = nil
    if let r = MetaData.with(pointer: p2_1, length: length) {
        metaData = r.0
        length -= p2_1.distance(to: r.1)
        p2_1 = r.1
    }
    guard let p3 = eat("{", from: p2_1, length: length) else {parserError(pointer, length: pointer.distance(to: p2_1))}
    length -= p2_1.distance(to: p3)
    var fields = [Field]()
    var p4 = p3
    while let (field, _p4) = Field.with(pointer: p4, length: length) {
        fields.append(field)
        length -= p4.distance(to: _p4)
        p4 = _p4
    }
    guard let p5 = eat("}", from: p4, length: length) else {parserError(pointer, length: pointer.distance(to: p4))}
    return ((name: name, fields: fields, metaData: metaData, comments: comments), p5)
}

extension Table {
    func computeFieldNamesWithVTableIndex(lookup: IdentLookup, withUniontypes: Bool = true) -> [(name: String, index: Int, root: Field)] {
        var result = [(name: String, index: Int, root: Field)]()
        var bonus = 0
        let sorted = sortedFields
        for i in 0..<sorted.count {
            let field = sorted[i]
            let index = i + bonus
            if let typeName = field.type.ref?.value,
                field.type.vector == false,
                lookup.unions[typeName] != nil {
                if withUniontypes {
                    // synthesised union typeField
                    let typeIdent = Ident(value: field.name.value + "_type")
                    let typeType = Type(scalar: .i8, vector: false, ref: nil, string: false)
                    let typeField = Field(name: typeIdent, type: typeType, defaultValue: nil, defaultIdent: nil, metaData: field.metaData)
                    result.append((field.fieldName + "_type", index, typeField))
                    result.append((field.fieldName, index + 1, field))
                } else {
                    result.append((field.fieldName, index, field))
                }
                bonus += 1
            } else {
                result.append((field.fieldName, index, field))
            }
        }
        return result
    }
    
    func computeFieldNamesWithVTableIndexSortedBySize(lookup: IdentLookup) -> [(name: String, index: Int, root: Field)] {
        return computeFieldNamesWithVTableIndex(lookup: lookup).sorted { (v1, v2) -> Bool in
            return v1.root.type.swiftSize(lookup: lookup) < v2.root.type.swiftSize(lookup: lookup)
        }
    }
    
    private var sortedFields: [Field] {
        let ids = fields.compactMap { (f) -> (Int, Field)? in
            if let id = f.id, let index = Int(id) {
                return (index, f)
            }
            return nil
        }
        if ids.isEmpty {
            return fields
        }
        if ids.count < fields.count {
            fatalError("Not all fields in table \(name.value) have id attribute")
        }
        return ids.sorted { (v1, v2) -> Bool in
            return v1.0 < v2.0
        }.map { (v) -> Field in
            return v.1
        }
    }
}

extension Struct {
    func swiftSize(lookup: IdentLookup) -> Int {
        return size(lookup: lookup, visited: [])
    }
    fileprivate func size(lookup: IdentLookup, visited: Set<String>) -> Int {
        // ⚠️ this implementation does not take memory alignment into consideration
        var result = 0
        for f in fields {
            if let scalar = f.type.scalar {
                result += scalar.swiftSize
                continue
            }
            if let ref = f.type.ref, f.type.vector == false {
                if let _enum = lookup.enums[ref.value] {
                    result += _enum.type.swiftSize(lookup: lookup)
                    continue
                }
                if let _struct = lookup.structs[ref.value] {
                    let name = _struct.name.value
                    if visited.contains(name){
                        fatalError("Recursion!!! Struct \(name) already visited")
                    }
                    var newVisited = visited
                    newVisited.insert(name)
                    result += _struct.size(lookup: lookup, visited: newVisited)
                    continue
                }
            }
            fatalError("field \(f.fieldName) is not of fixed size")
        }
        return result
    }
}

extension Table {
    func findCycle(lookup: IdentLookup, visited: Set<String>) -> Bool {
        if visited.contains(name.value) {
            return true
        }
        var newVisited = visited
        newVisited.insert(name.value)

        for f in fields {
            if let ref = f.type.ref?.value {
                if let t = lookup.tables[ref] {
                    if t.findCycle(lookup: lookup, visited: newVisited) {
                        return true
                    }
                } else if let u = lookup.unions[ref] {
                    for u_case in u.cases {
                        guard let t = lookup.tables[u_case.value] else {
                            fatalError("Union case \(u_case.value) is not a table")
                        }
                        if t.findCycle(lookup: lookup, visited: newVisited) {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
}
