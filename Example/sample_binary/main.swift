//
//  main.swift
//  sample_binary
//
//  Implementation of the Flatbuffers tutorial on how to use FlatBuffers to create and read binary buffers
//
//  Created by Joakim Hassila on 2016-05-12.
//  Copyright © 2016 Joakim Hassila. All rights reserved.
//

import FlatBuffersSwift

let builder = FlatBufferBuilder(config: BinaryBuildConfig(initialCapacity: 1000))

// Create some weapons for the Monster: A 'sword' and an 'axe'.
let sword = Weapon(name: "Sword", damage: 3)
let axe = Weapon(name: "Axe", damage: 5)
let weapons : [Weapon?] = [sword, axe]

// Set up the Monster
let orc = Monster()
orc.pos = Vec3(x: 1.0, y: 2.0, z: 3.0)
orc.name = "MyMonster"
orc.color = Color.Red
orc.hp = 80
orc.inventory = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ]
orc.weapons = weapons
orc.equipped = weapons[1]

// Finally, serialize the Monster to FlatBuffers format
let orc_serialized = orc.toByteArray()

// We now have a FlatBuffer we can store on disk or send over a network.
    
// ** file/network code goes here :) **

// Instead, we're going to access it right away (as if we just received it).

let reader = FlatBufferReader(buffer: orc_serialized, config: BinaryReadConfig())

// Get access to the root:

let monster = Monster.fromFlatBufferReader(reader)

// Get and test some scalar types from the FlatBuffer.
assert(monster.hp == 80)
assert(monster.mana == 150)  // default value, was not set
assert(monster.name == "MyMonster")
    
// Get and test the FlatBuffer's `struct`.
if let pos = monster.pos {
    assert(pos.x == 1.0)
    assert(pos.y == 2.0)
    assert(pos.z == 3.0)
}
else
{
    print("No monster.pos!")
}

// Get and test the inventory vector
for i in 0 ..< monster.inventory.count
{
    assert(monster.inventory[i] == UInt8(i))
}

let expected_weapon_names = ["Sword", "Axe"]
let expected_weapon_damages : [Int16] = [3,5]

for i in 0 ..< monster.weapons.count
{
    assert(monster.weapons[i]!.name == expected_weapon_names[i])
    assert(monster.weapons[i]!.damage == expected_weapon_damages[i])
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
