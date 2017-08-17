//
//  SchemaTests.swift
//  CodeGenTests
//
//  Created by Maxim Zaks on 19.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import XCTest

class SchemaTests: XCTestCase {
    
    func testSchema() {
        let s: StaticString = """
// sample

namespace MyGame;

attribute "priority";

enum Color : byte { Red = 1, Green, Blue }

union Any { Monster, Weapon, Pickup }

struct Vec3 {
  x:float;
  y:float;
  z:float;
}

table Monster {
  pos:Vec3;
  mana:short = 150;
  hp:short = 100;
  name:string;
  // this is a deprected field
  friendly:bool = false (deprecated, priority: 1);
  inventory:[ubyte];
  color:Color = Blue;
  test:Any;
}

table T1 {
  name: string;
}

// anothe comment
root_type Monster;
"""
        let result = Schema.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.rootType?.ident.value, "Monster")
        XCTAssertEqual(result?.0.namespace?.parts.count, 1)
        XCTAssertEqual(result?.0.namespace?.parts[0].value, "MyGame")
        XCTAssertEqual(result?.0.attributes.count, 1)
        XCTAssertEqual(result?.0.attributes[0].value.value, "priority")
        XCTAssertEqual(result?.0.enums.count, 1)
        XCTAssertEqual(result?.0.enums[0].name.value, "Color")
        XCTAssertEqual(result?.0.unions.count, 1)
        XCTAssertEqual(result?.0.unions[0].name.value, "Any")
        XCTAssertEqual(result?.0.structs.count, 1)
        XCTAssertEqual(result?.0.structs[0].name.value, "Vec3")
        XCTAssertEqual(result?.0.tables.count, 2)
        XCTAssertEqual(result?.0.tables[0].name.value, "Monster")
        XCTAssertEqual(result?.0.tables[1].name.value, "T1")
    }
    
    func testIdentLookup() {
        let s: StaticString = """
enum E1: byte {A, B}
table T1 {n: int;}
table T2 {b: bool;}
struct S1 {a:int;}
table T3 {t1: T1;}
union U1 {T1, T2}
enum E2: byte {A, B}
root_type T1;
"""
        let schema = Schema.with(pointer: s.utf8Start, length: s.utf8CodeUnitCount)
        let result = schema?.0.identLookup
        
        XCTAssertEqual(result?.tables.count, 3)
        XCTAssertNotNil(result?.tables["T1"])
        XCTAssertNotNil(result?.tables["T2"])
        XCTAssertNotNil(result?.tables["T3"])
        XCTAssertEqual(result?.enums.count, 2)
        XCTAssertNotNil(result?.enums["E1"])
        XCTAssertNotNil(result?.enums["E2"])
        XCTAssertEqual(result?.structs.count, 1)
        XCTAssertNotNil(result?.structs["S1"])
        XCTAssertEqual(result?.unions.count, 1)
        XCTAssertNotNil(result?.unions["U1"])
    }
}
