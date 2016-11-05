//
//  FriendsTest.swift
//  FBSwift3
//
//  Created by Maxim Zaks on 05.11.16.
//  Copyright © 2016 Maxim Zaks. All rights reserved.
//

import XCTest
import FlatBuffersSwift

class FriendsTest: XCTestCase {
    
    func testListWithOneEntry() {
        
        let f1 = Friend()
        f1.name = "Maxim"
        
        let list = PeopleList()
        list.people = [f1]
        let data = try!list.toData()
        
        let newList = PeopleList.from(data: data)
        
        XCTAssertEqual(newList?.people.count, 1)
        
        XCTAssertEqual(newList?.people[0]?.name, "Maxim")
    }
    
    func testListWithOneEntryWithDirectRecursion() {
        let f1 = Friend()
        f1.name = "Maxim"
        f1.father = f1
        
        let list = PeopleList()
        list.people = [f1]
        let data = try!list.toData()
        
        let newList = PeopleList.from(data: data)
        
        XCTAssertEqual(newList?.people.count, 1)
        
        XCTAssertEqual(newList?.people[0]?.name, "Maxim")
        XCTAssertEqual(newList?.people[0]?.father?.name, "Maxim")
        XCTAssertTrue(newList?.people[0] === newList?.people[0]?.father)
    }
    
    func testListWithOneEntryWithRecursionThrougVector() {
        let f1 = Friend()
        f1.name = "Maxim"
        f1.friends = [f1]
        
        let list = PeopleList()
        list.people = [f1]
        let data = try!list.toData()
        
        let newList = PeopleList.from(data: data)
        
        XCTAssertEqual(newList?.people.count, 1)
        
        XCTAssertEqual(newList?.people[0]?.name, "Maxim")
        XCTAssertEqual(newList?.people[0]?.friends[0]?.name, "Maxim")
        XCTAssertTrue(newList?.people[0] === newList?.people[0]?.friends[0])
    }
    
    func testListWithOneEntryWithRecursionThrougUnion() {
        let f1 = Friend()
        f1.name = "Maxim"
        f1.lover = Male(ref:f1)
        
        let list = PeopleList()
        list.people = [f1]
        let data = try!list.toData()
        
        let newList = PeopleList.from(data: data)
        
        XCTAssertEqual(newList?.people.count, 1)
        
        XCTAssertEqual(newList?.people[0]?.name, "Maxim")
        let male = (newList?.people[0]?.lover as? Male)
        XCTAssertEqual(male?.ref?.name, "Maxim")
        XCTAssertTrue(newList?.people[0] === male?.ref)
    }
    
    func testListWithTwoEntriesWithRecursionThrougUnion() {
        let f1 = Friend()
        f1.name = "Maxim"
        let f2 = Friend()
        f2.name = "Daria"
        f1.lover = Female(ref: f2)
        f2.lover = Male(ref:f1)
        
        let list = PeopleList()
        list.people = [f1]
        let data = try!list.toData()
        
        let newList = PeopleList.from(data: data)
        
        XCTAssertEqual(newList?.people.count, 1)
        
        XCTAssertEqual(newList?.people[0]?.name, "Maxim")
        let female = (newList?.people[0]?.lover as? Female)
        XCTAssertEqual(female?.ref?.name, "Daria")
        let male = female?.ref?.lover as? Male
        XCTAssertEqual(male?.ref?.name, "Maxim")
        XCTAssertTrue(newList?.people[0] === male?.ref)
    }
    
    func testComplexGraph(){
        
        let data = try!complexList().toData()
        
        let newList = PeopleList.from(data: data)
        
        XCTAssertEqual(newList?.people.count, 5)
        
        XCTAssertEqual(newList?.people[0]?.name, "a")
        XCTAssertEqual(newList?.people[1]?.name, "b")
        XCTAssertEqual(newList?.people[2]?.name, "c")
        XCTAssertEqual(newList?.people[3]?.name, "d")
        XCTAssertEqual(newList?.people[4]?.name, "e")
        
        let friendsA = newList?.people[0]?.friends
        XCTAssertEqual(friendsA?.count, 4)
        XCTAssertEqual(friendsA?[0]?.name, "b")
        XCTAssertEqual(friendsA?[1]?.name, "c")
        XCTAssertEqual(friendsA?[2]?.name, "d")
        XCTAssertEqual(friendsA?[3]?.name, "a")
        
        XCTAssertTrue(newList?.people[1] === friendsA?[0])
        XCTAssertTrue(newList?.people[3] === friendsA?[0]?.friends[0])
        XCTAssertTrue(newList?.people[2] === friendsA?[0]?.friends[0]?.friends[0])
        XCTAssertTrue(newList?.people[0] === friendsA?[0]?.friends[0]?.friends[0]?.friends[0])
        let friendsC = friendsA?[0]?.friends[0]?.friends[0]
        XCTAssertTrue(newList?.people[1] === friendsC?.friends[1])
    }
    
    func testComplexGraphDirectRead(){
        
        let data = try!complexList().toData()
        
        let reader = FBMemoryReader(data: data)
        
        let newList = PeopleList_Direct(reader)
        
        XCTAssertEqual(newList?.peopleCount, 5)
        
        XCTAssertEqual(newList?.getPeopleElement(atIndex: 0)?.name?§, "a")
        XCTAssertEqual(newList?.getPeopleElement(atIndex: 1)?.name?§, "b")
        XCTAssertEqual(newList?.getPeopleElement(atIndex: 2)?.name?§, "c")
        XCTAssertEqual(newList?.getPeopleElement(atIndex: 3)?.name?§, "d")
        XCTAssertEqual(newList?.getPeopleElement(atIndex: 4)?.name?§, "e")
        
        let a = newList?.getPeopleElement(atIndex: 0)
        XCTAssertEqual(a?.friendsCount, 4)
        XCTAssertEqual(a?.getFriendsElement(atIndex: 0)?.name?§, "b")
        XCTAssertEqual(a?.getFriendsElement(atIndex: 1)?.name?§, "c")
        XCTAssertEqual(a?.getFriendsElement(atIndex: 2)?.name?§, "d")
        XCTAssertEqual(a?.getFriendsElement(atIndex: 3)?.name?§, "a")
        
        XCTAssertTrue(newList?.getPeopleElement(atIndex: 1) == a?.getFriendsElement(atIndex: 0))
        XCTAssertTrue(newList?.getPeopleElement(atIndex: 3) ==
            a?.getFriendsElement(atIndex: 0)?.getFriendsElement(atIndex: 0)
        )
        XCTAssertTrue(newList?.getPeopleElement(atIndex: 2) ==
            a?.getFriendsElement(atIndex: 0)?.getFriendsElement(atIndex: 0)?.getFriendsElement(atIndex: 0)
        )
        XCTAssertTrue(newList?.getPeopleElement(atIndex: 0) ==
            a?.getFriendsElement(atIndex: 0)?.getFriendsElement(atIndex: 0)?.getFriendsElement(atIndex: 0)?.getFriendsElement(atIndex: 0)
        )
        XCTAssertTrue(newList?.getPeopleElement(atIndex: 1) ==
            a?.getFriendsElement(atIndex: 0)?.getFriendsElement(atIndex: 0)?.getFriendsElement(atIndex: 0)?.getFriendsElement(atIndex: 1)
        )
    }
    
    func testComplexGraphFromFile(){
        
        let data = try!complexList().toData()
        
        let fileHandle = writeToFileAndReturnHandle(data)
        let fileReader = FBFileReader(fileHandle: fileHandle)
        
        let newList = PeopleList.from(reader:fileReader)
        
        XCTAssertEqual(newList?.people.count, 5)
        
        XCTAssertEqual(newList?.people[0]?.name, "a")
        XCTAssertEqual(newList?.people[1]?.name, "b")
        XCTAssertEqual(newList?.people[2]?.name, "c")
        XCTAssertEqual(newList?.people[3]?.name, "d")
        XCTAssertEqual(newList?.people[4]?.name, "e")
        
        let friendsA = newList?.people[0]?.friends
        XCTAssertEqual(friendsA?.count, 4)
        XCTAssertEqual(friendsA?[0]?.name, "b")
        XCTAssertEqual(friendsA?[1]?.name, "c")
        XCTAssertEqual(friendsA?[2]?.name, "d")
        XCTAssertEqual(friendsA?[3]?.name, "a")
        
        XCTAssertTrue(newList?.people[1] === friendsA?[0])
        XCTAssertTrue(newList?.people[3] === friendsA?[0]?.friends[0])
        XCTAssertTrue(newList?.people[2] === friendsA?[0]?.friends[0]?.friends[0])
        XCTAssertTrue(newList?.people[0] === friendsA?[0]?.friends[0]?.friends[0]?.friends[0])
        let friendsC = friendsA?[0]?.friends[0]?.friends[0]
        XCTAssertTrue(newList?.people[1] === friendsC?.friends[1])
    }
    
    func testComplexGraphDirectReadFromFile(){
        
        let data = try!complexList().toData()
        
        let fileHandle = writeToFileAndReturnHandle(data)
        let reader = FBFileReader(fileHandle: fileHandle)
        
        let newList = PeopleList_Direct(reader)
        
        XCTAssertEqual(newList?.peopleCount, 5)
        
        XCTAssertEqual(newList?.getPeopleElement(atIndex: 0)?.name?§, "a")
        XCTAssertEqual(newList?.getPeopleElement(atIndex: 1)?.name?§, "b")
        XCTAssertEqual(newList?.getPeopleElement(atIndex: 2)?.name?§, "c")
        XCTAssertEqual(newList?.getPeopleElement(atIndex: 3)?.name?§, "d")
        XCTAssertEqual(newList?.getPeopleElement(atIndex: 4)?.name?§, "e")
        
        let a = newList?.getPeopleElement(atIndex: 0)
        XCTAssertEqual(a?.friendsCount, 4)
        XCTAssertEqual(a?.getFriendsElement(atIndex: 0)?.name?§, "b")
        XCTAssertEqual(a?.getFriendsElement(atIndex: 1)?.name?§, "c")
        XCTAssertEqual(a?.getFriendsElement(atIndex: 2)?.name?§, "d")
        XCTAssertEqual(a?.getFriendsElement(atIndex: 3)?.name?§, "a")
        
        XCTAssertTrue(newList?.getPeopleElement(atIndex: 1) == a?.getFriendsElement(atIndex: 0))
        XCTAssertTrue(newList?.getPeopleElement(atIndex: 3) ==
            a?.getFriendsElement(atIndex: 0)?.getFriendsElement(atIndex: 0)
        )
        XCTAssertTrue(newList?.getPeopleElement(atIndex: 2) ==
            a?.getFriendsElement(atIndex: 0)?.getFriendsElement(atIndex: 0)?.getFriendsElement(atIndex: 0)
        )
        XCTAssertTrue(newList?.getPeopleElement(atIndex: 0) ==
            a?.getFriendsElement(atIndex: 0)?.getFriendsElement(atIndex: 0)?.getFriendsElement(atIndex: 0)?.getFriendsElement(atIndex: 0)
        )
        XCTAssertTrue(newList?.getPeopleElement(atIndex: 1) ==
            a?.getFriendsElement(atIndex: 0)?.getFriendsElement(atIndex: 0)?.getFriendsElement(atIndex: 0)?.getFriendsElement(atIndex: 1)
        )
    }
    
    func complexList() -> PeopleList {
        let a = Friend(name: "a", friends: [], father: nil, mother: nil, lover: nil)
        let b = Friend(name: "b", friends: [], father: nil, mother: nil, lover: nil)
        let c = Friend(name: "c", friends: [], father: nil, mother: nil, lover: nil)
        let d = Friend(name: "d", friends: [], father: nil, mother: nil, lover: nil)
        let e = Friend(name: "e", friends: [], father: nil, mother: nil, lover: nil)
        
        a.friends = [b,c,d,a]
        b.friends = [d]
        d.friends = [c]
        c.friends = [a, b]
        
        let list = PeopleList()
        list.people = [a, b, c, d, e]
        return list
    }
    
    
    
    func writeToFileAndReturnHandle(_ data : Data?) -> FileHandle {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.bundleURL.deletingLastPathComponent().deletingLastPathComponent()
            .appendingPathComponent("friends.dat")
        
        try?data?.write(to: url)
        return try!FileHandle(forReadingFrom: url)
    }
}
