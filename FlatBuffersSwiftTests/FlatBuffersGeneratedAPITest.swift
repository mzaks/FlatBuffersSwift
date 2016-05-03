//
//  FlatBuffersAPITest.swift
//  FlatBuffersSwift
//
//  Created by Maxim Zaks on 16.01.16.
//  Copyright © 2016 maxim.zaks. All rights reserved.
//

import XCTest

class FlatBuffersGeneratedAPITest: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testExample() {
        let list = ContactList()
        let p1 = Contact()
        p1.name = "Max"
        p1.gender = .Male
        p1.birthday = Date()
        p1.birthday?.day = 12
        p1.birthday?.month = 6
        p1.birthday?.year = 1981
        
        p1.currentLoccation = GeoLocation(latitude: 2.5, longitude: 3.5, elevation: 4.5)
        p1.previousLocations = [GeoLocation(latitude: 1.5, longitude: 2.5, elevation: 3.5),GeoLocation(latitude: 5.5, longitude: 6.5, elevation: 7.5)]
        
        list.entries.append(p1)
        
        let p2 = Contact()
        p2.name = "Someone"
        
        list.entries.append(p2)
        
        XCTAssert(list.entries[0]?.birthday?.year == 1981)
        XCTAssert(list.entries[1]?.birthday?.year == nil)
        
        let data = list.toByteArray()
        
        let lazyList  = ContactList.LazyAccess(data: UnsafePointer<UInt8>(data))
        
        XCTAssert(lazyList.entries[0]?.name == "Max")
        XCTAssert(lazyList.entries[0]?.birthday?.year == 1981)
        XCTAssert(lazyList.entries[0]?.currentLoccation == GeoLocation(latitude: 2.5, longitude: 3.5, elevation: 4.5))
        XCTAssert(lazyList.entries[0]?.previousLocations[1] == GeoLocation(latitude: 5.5, longitude: 6.5, elevation: 7.5))
        XCTAssert(lazyList.entries[1]?.birthday?.year == nil)
        
        let eagerList  = ContactList.fromByteArray(UnsafePointer<UInt8>(data))
        
        XCTAssert(eagerList.entries[0]?.name == "Max")
        XCTAssert(eagerList.entries[0]?.birthday?.year == 1981)
        XCTAssert(eagerList.entries[0]?.currentLoccation == GeoLocation(latitude: 2.5, longitude: 3.5, elevation: 4.5))
        XCTAssert(eagerList.entries[0]?.previousLocations[1] == GeoLocation(latitude: 5.5, longitude: 6.5, elevation: 7.5))
        XCTAssert(eagerList.entries[1]?.birthday?.year == nil)
    }

}
