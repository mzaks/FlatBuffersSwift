//
//  main.swift
//  sample_binary
//
//  Implementation of the Flatbuffers tutorial
//
//  Created by Joakim Hassila on 2016-05-12.
//  Copyright © 2016 Joakim Hassila. All rights reserved.
//

import FlatBuffersSwift

let builder = FlatBufferBuilder.create(BinaryBuildConfig(initialCapacity: 1000))

// First, lets add some weapons for the Monster: A 'sword' and an 'axe'.
let sword = Weapon(name: "Sword", damage: 3)
let axe = Weapon(name: "Axe", damage: 5)
let weapons : [Weapon?] = [sword, axe]

// Second, serialize the rest of the objects needed by the Monster.
let position = Vec3(x: 1.0, y: 2.0, z: 3.0)
let inventory : [UInt8] = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ]

let orc = Monster(pos: position, mana: 150, hp: 80, name: "MyMonster", inventory: inventory, color: Color.Red, weapons: weapons, equipped: axe)

let orc_serialized = orc.toByteArray() // Serialize the object graph

// We now have a FlatBuffer we can store on disk or send over a network.
    
// ** file/network code goes here :) **

// Instead, we're going to access it right away (as if we just received it).

let reader = FlatBufferReader.create(orc_serialized, config: BinaryReadConfig())

let monster = Monster.fromFlatBufferReader(reader)

// Get and test some scalar types from the FlatBuffer.
assert(monster.hp == 80)
assert(monster.mana == 150)  // default
assert(monster.name == "MyMonster")
    
// Get and test a field of the FlatBuffer's `struct`.
if let pos = monster.pos {
    assert(pos.z == 3.0)
}
else
{
    print("No pos!")
}

let inv = monster.inventory
assert(inv[9] == 9)

let expected_weapon_names = ["Sword", "Axe"]
let expected_weapon_damages : [Int16] = [3,5]
let weps = monster.weapons

for i in 0 ..< weps.count
{
    assert(weps[i]!.name == expected_weapon_names[i])
    assert(weps[i]!.damage == expected_weapon_damages[i])
}

// Get and test the `Equipment` union (`equipped` field).

if let equipped = monster.equipped {
    switch equipped {
        case let equipped as Weapon:
            assert(equipped.name == "Axe")
            assert(equipped.damage == 5)
        default:
            print("implement what to do for forward compatibility")
    }
}
else
{
    print("Nothing equipped!")
}

print("The FlatBuffer was successfully created and verified!")
