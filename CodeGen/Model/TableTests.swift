//
//  TableTests.swift
//  CodeGenTests
//
//  Created by Maxim Zaks on 10.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import XCTest

class TableTests: XCTestCase {
    
    func testTable() {
        let s: StaticString = """
    table Foo {
        i: int;
        b: bool;
    }
"""
        let result = Table.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.name.value, "Foo")
        XCTAssertEqual(result?.0.fields.count, 2)
        XCTAssertEqual(result?.0.fields[0].name.value, "i")
        XCTAssertEqual(result?.0.fields[0].type.scalar, .i32)
        XCTAssertEqual(result?.0.fields[1].name.value, "b")
        XCTAssertEqual(result?.0.fields[1].type.scalar, .bool)
    }
    
    func testWithCommentsTable() {
        let s: StaticString = """
    // hello
    /// bla
    table Foo {
        i: int;
        b: bool;
    }
"""
        let result = Table.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.name.value, "Foo")
        XCTAssertEqual(result?.0.fields.count, 2)
        XCTAssertEqual(result?.0.fields[0].name.value, "i")
        XCTAssertEqual(result?.0.fields[0].type.scalar, .i32)
        XCTAssertEqual(result?.0.fields[1].name.value, "b")
        XCTAssertEqual(result?.0.fields[1].type.scalar, .bool)
        XCTAssertEqual(result?.0.comments.count, 2)
        XCTAssertEqual(result?.0.comments[0].value, " hello")
        XCTAssertEqual(result?.0.comments[1].value, "/ bla")
    }
    
    func testTableWithMeta() {
        let s: StaticString = """
    table Foo (exclude) {
        i: int;
        b: bool;
    }
"""
        let result = Table.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.name.value, "Foo")
        XCTAssertEqual(result?.0.metaData?.values[0].0.value, "exclude")
        XCTAssertEqual(result?.0.fields.count, 2)
        XCTAssertEqual(result?.0.fields[0].name.value, "i")
        XCTAssertEqual(result?.0.fields[0].type.scalar, .i32)
        XCTAssertEqual(result?.0.fields[1].name.value, "b")
        XCTAssertEqual(result?.0.fields[1].type.scalar, .bool)
    }
    
    func testStructIsNotTable() {
        let s: StaticString = """
    // foo
    struct Foo (exclude) {
        i: int;
        b: bool;
    }
"""
        let result = Table.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNil(result)
    }
    
    func testSwiftStruct(){
        let s: StaticString = """
    struct Foo (exclude) {
        i: int;
        b: bool;
    }
"""
        let result = Struct.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)?.0.swift
        let expected = """
public struct Foo: Scalar {
    public let i: Int32
    public let b: Bool
    public static func ==(v1:Foo, v2:Foo) -> Bool {
        return v1.i==v2.i && v1.b==v2.b
    }
}
"""
        print(result!)
        print(expected)
        XCTAssertEqual(expected.count, result?.count)
        XCTAssertEqual(expected, result)
    }
    
    func testTableIsNotStruct() {
        let s: StaticString = """
    table Foo (exclude) {
        i: int;
        b: bool;
    }
"""
        let result = Struct.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNil(result)
    }
    
    func testStructWithMeta() {
        let s: StaticString = """
    struct Foo (exclude) {
        i: int;
        b: bool;
    }
"""
        let result = Struct.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.name.value, "Foo")
        XCTAssertEqual(result?.0.metaData?.values[0].0.value, "exclude")
        XCTAssertEqual(result?.0.fields.count, 2)
        XCTAssertEqual(result?.0.fields[0].name.value, "i")
        XCTAssertEqual(result?.0.fields[0].type.scalar, .i32)
        XCTAssertEqual(result?.0.fields[1].name.value, "b")
        XCTAssertEqual(result?.0.fields[1].type.scalar, .bool)
    }
    
    func testSimpleFieldsList() {
        let s: StaticString = """
    table Foo {
        i: int;
        b: bool;
    }
"""
        let schema = Schema.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)!.0
        let lookup = schema.identLookup
        let table = lookup.tables["Foo"]!
        let names = table.computeFieldNamesWithVTableIndex(lookup: lookup)
        XCTAssertEqual(names.count, 2)
        XCTAssertEqual(names[0].0, "i")
        XCTAssertEqual(names[0].1, 0)
        XCTAssertEqual(names[1].0, "b")
        XCTAssertEqual(names[1].1, 1)
    }
    
    func testSimpleFieldsListWithId() {
        let s: StaticString = """
    table Foo {
        i: int (id:1);
        b: bool(id:0);
    }
"""
        let schema = Schema.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)!.0
        let lookup = schema.identLookup
        let table = lookup.tables["Foo"]!
        let names = table.computeFieldNamesWithVTableIndex(lookup: lookup)
        XCTAssertEqual(names.count, 2)
        XCTAssertEqual(names[0].0, "b")
        XCTAssertEqual(names[0].1, 0)
        XCTAssertEqual(names[1].0, "i")
        XCTAssertEqual(names[1].1, 1)
    }
    
    func testFieldsListWithUnion() {
        let s: StaticString = """
    union U1 {A, B}
    union U2 {C, D}
    table Foo {
        i: int;
        u1: U1;
        b: bool;
        u2: U2;
    }
"""
        let schema = Schema.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)!.0
        let lookup = schema.identLookup
        let table = lookup.tables["Foo"]!
        let names = table.computeFieldNamesWithVTableIndex(lookup: lookup)
        XCTAssertEqual(names.count, 6)
        XCTAssertEqual(names[0].name, "i")
        XCTAssertEqual(names[0].index, 0)
        XCTAssertEqual(names[1].0, "u1_type")
        XCTAssertEqual(names[1].1, 1)
        XCTAssertEqual(names[2].0, "u1")
        XCTAssertEqual(names[2].1, 2)
        XCTAssertEqual(names[3].0, "b")
        XCTAssertEqual(names[3].1, 3)
        XCTAssertEqual(names[4].0, "u2_type")
        XCTAssertEqual(names[4].1, 4)
        XCTAssertEqual(names[5].0, "u2")
        XCTAssertEqual(names[5].1, 5)
    }
    
    func testFieldsListWithUnionAndId() {
        let s: StaticString = """
    union U1 {A, B}
    union U2 {C, D}
    table Foo {
        i: int(id: 3);
        u1: U1(id: 1);
        b: bool(id:0);
        u2: U2 (id:2);
    }
"""
        let schema = Schema.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)!.0
        let lookup = schema.identLookup
        let table = lookup.tables["Foo"]!
        let names = table.computeFieldNamesWithVTableIndex(lookup: lookup)
        XCTAssertEqual(names.count, 6)
        XCTAssertEqual(names[0].name, "b")
        XCTAssertEqual(names[0].index, 0)
        XCTAssertEqual(names[1].0, "u1_type")
        XCTAssertEqual(names[1].1, 1)
        XCTAssertEqual(names[2].0, "u1")
        XCTAssertEqual(names[2].1, 2)
        XCTAssertEqual(names[3].0, "u2_type")
        XCTAssertEqual(names[3].1, 3)
        XCTAssertEqual(names[4].0, "u2")
        XCTAssertEqual(names[4].1, 4)
        XCTAssertEqual(names[5].0, "i")
        XCTAssertEqual(names[5].1, 5)
    }
    
    func testFieldsListWithUnionAndIdWithoutUnionType() {
        let s: StaticString = """
    union U1 {A, B}
    union U2 {C, D}
    table Foo {
        i: int(id: 3);
        u1: U1(id: 1);
        b: bool(id:0);
        u2: U2 (id:2);
    }
"""
        let schema = Schema.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)!.0
        let lookup = schema.identLookup
        let table = lookup.tables["Foo"]!
        let names = table.computeFieldNamesWithVTableIndex(lookup: lookup, withUniontypes: false)
        XCTAssertEqual(names.count, 4)
        XCTAssertEqual(names[0].name, "b")
        XCTAssertEqual(names[0].index, 0)
        XCTAssertEqual(names[1].0, "u1")
        XCTAssertEqual(names[1].1, 1)
        XCTAssertEqual(names[2].0, "u2")
        XCTAssertEqual(names[2].1, 3)
        XCTAssertEqual(names[3].0, "i")
        XCTAssertEqual(names[3].1, 5)
    }
    
    func testFieldsListWithUnionAndIdSortedBySize() {
        let s: StaticString = """
    union U1 {A, B}
    union U2 {C, D}
    table Foo {
        i: int(id: 3);
        u1: U1(id: 1);
        b: bool(id:0);
        u2: U2 (id:2);
    }
"""
        let schema = Schema.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)!.0
        let lookup = schema.identLookup
        let table = lookup.tables["Foo"]!
        let names = table.computeFieldNamesWithVTableIndexSortedBySize(lookup: lookup)
        XCTAssertEqual(names.count, 6)
        XCTAssertEqual(names[0].name, "b")
        XCTAssertEqual(names[0].index, 0)
        XCTAssertEqual(names[1].0, "u1_type")
        XCTAssertEqual(names[1].1, 1)
        XCTAssertEqual(names[2].0, "u2_type")
        XCTAssertEqual(names[2].1, 3)
        XCTAssertEqual(names[3].0, "u1")
        XCTAssertEqual(names[3].1, 2)
        XCTAssertEqual(names[4].0, "u2")
        XCTAssertEqual(names[4].1, 4)
        XCTAssertEqual(names[5].0, "i")
        XCTAssertEqual(names[5].1, 5)
    }
    func testFieldsListWithUnionAndStructAndIdSortedBySize() {
        let s: StaticString = """
    union U1 {A, B}
    union U2 {C, D}
    enum E1: byte {a, b}
    struct A {
        a: bool;
        e: E1;
    }
    struct B {
        a1: A;
        a: bool;
    }
    table Foo {
        i: int(id: 3);
        u1: U1(id: 1);
        b: bool(id:0);
        u2: U2 (id:2);
        b: B (id: 4);
        a: A (id: 5);
    }
"""
        let schema = Schema.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)!.0
        let lookup = schema.identLookup
        let table = lookup.tables["Foo"]!
        let names = table.computeFieldNamesWithVTableIndexSortedBySize(lookup: lookup)
        XCTAssertEqual(names.count, 8)
        XCTAssertEqual(names[0].name, "b")
        XCTAssertEqual(names[0].index, 0)
        XCTAssertEqual(names[1].0, "u1_type")
        XCTAssertEqual(names[1].1, 1)
        XCTAssertEqual(names[2].0, "u2_type")
        XCTAssertEqual(names[2].1, 3)
        XCTAssertEqual(names[3].0, "a")
        XCTAssertEqual(names[3].1, 7)
        XCTAssertEqual(names[4].0, "b")
        XCTAssertEqual(names[4].1, 6)
        XCTAssertEqual(names[5].0, "u1")
        XCTAssertEqual(names[5].1, 2)
        XCTAssertEqual(names[6].0, "u2")
        XCTAssertEqual(names[6].1, 4)
        XCTAssertEqual(names[7].0, "i")
        XCTAssertEqual(names[7].1, 5)
    }
}
