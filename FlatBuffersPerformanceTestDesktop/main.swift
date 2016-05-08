//
//  main.swift
//  FlatBuffersPerformanceTestDesktop
//
//  Created by Maxim Zaks on 04.01.16.
//  Copyright © 2016 maxim.zaks. All rights reserved.
//

import Foundation
import Quartz

func testRandomContactListToByteArrayAndBackAgain(){
    let contactList = generateRandomContactList()
    let time1 = CACurrentMediaTime()
    let data = contactList.toByteArray(BinaryBuildConfig(initialCapacity: 1024*1024*3, uniqueStrings: false, uniqueTables: false, uniqueVTables: true))
    let after1 = CACurrentMediaTime()
    print("\((after1 - time1) * 1000.0) ms encoding to byte array of size \(data.count)")
    let time2 = CACurrentMediaTime()
    _ = ContactList.fromByteArray(UnsafeBufferPointer<UInt8>(start: UnsafePointer(data), count: data.count), config: BinaryReadConfig(uniqueStrings: false, uniqueTables: false))
    let after2 = CACurrentMediaTime()
    print("\((after2 - time2) * 1000.0) ms decoding")

    let time3 = CACurrentMediaTime()
    _ = ContactList.LazyAccess(data: UnsafeBufferPointer<UInt8>(start: UnsafePointer(data), count: data.count))
    let after3 = CACurrentMediaTime()
    print("\((after3 - time3) * 1000.0) ms lazy accessor")
    
//    NSData(bytes: UnsafePointer<UInt8>(data), length: data.count).writeToFile("/Users/mzaks/dev/FlatBuffersSwift/Example/contactList.bin", atomically: true)
}

func testReadingJSON(){
    let jsonData = NSData(contentsOfFile: "/Users/mzaks/dev/FlatBuffersSwift/Example/contactList_.json")!
    let time1 = CACurrentMediaTime()
    let o = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
    let after1 = CACurrentMediaTime()
    print("\((after1 - time1) * 1000.0) ms for parsing JSON")

    let time2 = CACurrentMediaTime()
    let newData2 : NSData = try!NSJSONSerialization.dataWithJSONObject(o, options: NSJSONWritingOptions(rawValue: 0))
    let after2 = CACurrentMediaTime()
    print("\((after2 - time2) * 1000.0) ms for creating JSON, size \(newData2.length)")
    newData2.writeToFile("/Users/mzaks/dev/FlatBuffersSwift/Example/contactList_.json", atomically: true)
    
}

print("-----------------Starting Performance Tests-------------")

flatbench()

print("------------")

testRandomContactListToByteArrayAndBackAgain()

print("------------")

// testReadingJSON() temporarily commented out as the hardcoded path does not work...

print("------------")
