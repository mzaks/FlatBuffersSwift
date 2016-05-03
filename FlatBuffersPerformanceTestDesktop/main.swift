//
//  main.swift
//  FlatBuffersPerformanceTestDesktop
//
//  Created by Maxim Zaks on 04.01.16.
//  Copyright © 2016 maxim.zaks. All rights reserved.
//

import Foundation

func testRandomContactListToByteArrayAndBackAgain(){
    let contactList = generateRandomContactList()
    let time1 = NSDate()
    let data = contactList.toByteArray(BinaryBuildConfig(initialCapacity: 1024*1024*3, uniqueStrings: false, uniqueTables: false, uniqueVTables: true))
    let after1 = NSDate()
    print("\((after1.timeIntervalSince1970 - time1.timeIntervalSince1970) * 1000.0) ms encoding to byte array of size \(data.count)")
    let time2 = NSDate()
    _ = ContactList.fromByteArray(data, config: BinaryReadConfig(uniqueStrings: false, uniqueTables: false))
    let after2 = NSDate()
    print("\((after2.timeIntervalSince1970 - time2.timeIntervalSince1970) * 1000.0) ms decoding")

    let time3 = NSDate()
    _ = ContactList.LazyAccess(data: data)
    let after3 = NSDate()
    print("\((after3.timeIntervalSince1970 - time3.timeIntervalSince1970) * 1000.0) ms lazy accessor")
    
//    NSData(bytes: UnsafePointer<UInt8>(data), length: data.count).writeToFile("/Users/mzaks/dev/FlatBuffersSwift/Example/contactList.bin", atomically: true)
}

func testReadingJSON(){
    let jsonData = NSData(contentsOfFile: "/Users/mzaks/dev/FlatBuffersSwift/Example/contactList_.json")!
    let time1 = NSDate()
    let o = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
    let after1 = NSDate()
    print("\((after1.timeIntervalSince1970 - time1.timeIntervalSince1970) * 1000.0) ms for parsing JSON")

    let time2 = NSDate()
    let newData2 : NSData = try!NSJSONSerialization.dataWithJSONObject(o, options: NSJSONWritingOptions(rawValue: 0))
    let after2 = NSDate()
    print("\((after2.timeIntervalSince1970 - time2.timeIntervalSince1970) * 1000.0) ms for creating JSON, size \(newData2.length)")
    newData2.writeToFile("/Users/mzaks/dev/FlatBuffersSwift/Example/contactList_.json", atomically: true)
    
}

print("-----------------Starting Performance Tests-------------")

flatbench()

print("------------")

testRandomContactListToByteArrayAndBackAgain()

print("------------")

// testReadingJSON() temporarily commented out as the hardcoded path does not work...

print("------------")
