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
    let time1 = CFAbsoluteTimeGetCurrent()
    let data = contactList.toByteArray(BinaryBuildConfig(initialCapacity: 1024*1024*3, uniqueStrings: false, uniqueTables: false, uniqueVTables: true))
    let after1 = CFAbsoluteTimeGetCurrent()
    print("\((after1 - time1) * 1000.0) ms encoding to byte array of size \(data.count)")
    let time2 = CFAbsoluteTimeGetCurrent()
    _ = ContactList.fromByteArray(UnsafeBufferPointer<UInt8>(start: UnsafePointer(data), count: data.count), config: BinaryReadConfig(uniqueStrings: false, uniqueTables: false))
    let after2 = CFAbsoluteTimeGetCurrent()
    print("\((after2 - time2) * 1000.0) ms decoding")

    let time3 = CFAbsoluteTimeGetCurrent()
    _ = ContactList.LazyAccess(data: UnsafeBufferPointer<UInt8>(start: UnsafePointer(data), count: data.count))
    let after3 = CFAbsoluteTimeGetCurrent()
    print("\((after3 - time3) * 1000.0) ms lazy accessor")
    
//    NSData(bytes: UnsafePointer<UInt8>(data), length: data.count).writeToFile("/Users/mzaks/dev/FlatBuffersSwift/Example/contactList.bin", atomically: true)
}

func testReadingJSON(){
    let jsonData = NSData(contentsOfFile: "/Users/mzaks/dev/FlatBuffersSwift/Example/contactList_.json")!
    let time1 = CFAbsoluteTimeGetCurrent()
    let o = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
    let after1 = CFAbsoluteTimeGetCurrent()
    print("\((after1 - time1) * 1000.0) ms for parsing JSON")

    let time2 = CFAbsoluteTimeGetCurrent()
    let newData2 : NSData = try!NSJSONSerialization.dataWithJSONObject(o, options: NSJSONWritingOptions(rawValue: 0))
    let after2 = CFAbsoluteTimeGetCurrent()
    print("\((after2 - time2) * 1000.0) ms for creating JSON, size \(newData2.length)")
    newData2.writeToFile("/Users/mzaks/dev/FlatBuffersSwift/Example/contactList_.json", atomically: true)
    
}

// optional eager preload of instance cache, otherwise lazy
func precache()
{
    ContactList.maxInstanceCacheSize = 1
    Contact.maxInstanceCacheSize = 10000
    Date.maxInstanceCacheSize = 30000
    AddressEntry.maxInstanceCacheSize = 20000
    PostalAddress.maxInstanceCacheSize = 20000
    EmailAddress.maxInstanceCacheSize = 20000
    WebAddress.maxInstanceCacheSize = 20000
    TelephoneNumber.maxInstanceCacheSize = 20000

    ContactList.fillInstancePool(ContactList.maxInstanceCacheSize)
    Contact.fillInstancePool(Contact.maxInstanceCacheSize)
    Date.fillInstancePool(Date.maxInstanceCacheSize)
    AddressEntry.fillInstancePool(AddressEntry.maxInstanceCacheSize)
    PostalAddress.fillInstancePool(PostalAddress.maxInstanceCacheSize)
    EmailAddress.fillInstancePool(EmailAddress.maxInstanceCacheSize)
    WebAddress.fillInstancePool(WebAddress.maxInstanceCacheSize)
    TelephoneNumber.fillInstancePool(TelephoneNumber.maxInstanceCacheSize)
}

print("-----------------Starting Performance Tests-------------")

flatbench()

print("------------")

// precache()
testRandomContactListToByteArrayAndBackAgain()

print("------------")

// testReadingJSON() temporarily commented out as the hardcoded path does not work...

print("------------")
