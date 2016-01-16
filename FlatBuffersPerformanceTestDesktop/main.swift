//
//  main.swift
//  FlatBuffersPerformanceTestDesktop
//
//  Created by Maxim Zaks on 04.01.16.
//  Copyright © 2016 maxim.zaks. All rights reserved.
//

import Foundation

print("-----------------Starting Performance Test-------------")

func testRandomContactListToByteArrayAndBackAgain(){
    let contactList = generateRandomContactList()
    let time1 = NSDate()
    let data = contactList.toByteArray
    let after1 = NSDate()
    print("\((after1.timeIntervalSince1970 - time1.timeIntervalSince1970) * 1000.0) mseconds for creating byte array of size \(data.count)")
    let time2 = NSDate()
    _ = ContactList.fromByteArray(data)
    let after2 = NSDate()
    print("\((after2.timeIntervalSince1970 - time2.timeIntervalSince1970) * 1000.0) mseconds for creating the list from byte array")

    let time3 = NSDate()
    _ = ContactList.LazyAccess(data: data)
    let after3 = NSDate()
    print("\((after3.timeIntervalSince1970 - time3.timeIntervalSince1970) * 1000.0) mseconds for creating lazy accessor to the list from byte array")
    
//    NSData(bytes: UnsafePointer<UInt8>(data), length: data.count).writeToFile("/Users/mzaks/dev/FlatBuffersSwift/Example/contactList.bin", atomically: true)
}

testRandomContactListToByteArrayAndBackAgain()

print("------------")

func testReadingJSON(){
    let jsonData = NSData(contentsOfFile: "/Users/mzaks/dev/FlatBuffersSwift/Example/contactList_.json")!
    let time1 = NSDate()
    let o = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
    let after1 = NSDate()
    print("\((after1.timeIntervalSince1970 - time1.timeIntervalSince1970) * 1000.0) mseconds for parsing JSON and creating JSON objects")

    let time2 = NSDate()
    let newData2 : NSData = try!NSJSONSerialization.dataWithJSONObject(o, options: NSJSONWritingOptions(rawValue: 0))
    let after2 = NSDate()
    print("\((after2.timeIntervalSince1970 - time2.timeIntervalSince1970) * 1000.0) mseconds for creating JSON Data again, size \(newData2.length)")
//    newData2.writeToFile("/Users/mzaks/dev/FlatBuffersSwift/Example/contactList_.json", atomically: true)
    
}
testReadingJSON()
