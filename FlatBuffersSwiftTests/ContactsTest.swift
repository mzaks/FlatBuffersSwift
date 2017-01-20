//
//  ContactsTest.swift
//  FBSwift3
//
//  Created by Maxim Zaks on 05.11.16.
//  Copyright © 2016 Maxim Zaks. All rights reserved.
//

import XCTest
import FlatBuffersSwift

class ContactsTest: XCTestCase {
    
    func testToDataFromData() {
        let contactList = createContactList()
        
        let data = try?contactList.makeData()
        
        XCTAssertNotNil(data)
        
        let readContactList = ContactList.makeContactList(data: data!)!
        XCTAssertEqual(readContactList.lastModified, 2349873427654)
        XCTAssertEqual(readContactList.entries.count, 2)
        
        let i1 = readContactList.entries[0]!
        let i2 = readContactList.entries[1]!
        
        XCTAssertEqual(i1.name, "Maxim")
        XCTAssertEqual(i1.birthday!.day, 12)
        XCTAssertEqual(i1.birthday!.month, 6)
        XCTAssertEqual(i1.birthday!.year, 1981)
        
        XCTAssertEqual(i1.gender, .Male)
        let tags = i1.tags
        XCTAssertEqual(tags.count, 3)
        
        XCTAssertEqual(tags[0], "h1")
        XCTAssertEqual(tags[1], "h2")
        XCTAssertEqual(tags[2], "h3")
        
        let adresses = i1.addressEntries
        XCTAssertEqual(adresses.count, 4)
        
        XCTAssertEqual(adresses[0]?.order, 0)
        XCTAssertEqual((adresses[0]?.address as? EmailAddress)?.mailto, "bla@bla.io")
        
        XCTAssertEqual(adresses[1]?.order, 1)
        XCTAssertEqual((adresses[1]?.address as? PostalAddress)?.country, "DE")
        XCTAssertEqual((adresses[1]?.address as? PostalAddress)?.city, "Berlin")
        XCTAssertEqual((adresses[1]?.address as? PostalAddress)?.postalCode, 13000)
        XCTAssertEqual((adresses[1]?.address as? PostalAddress)?.streetAndNumber, "Balstr, 23")
        
        XCTAssertEqual(adresses[2]?.order, 2)
        XCTAssertEqual((adresses[2]?.address as? WebAddress)?.url, "http://slkf.com")
        
        XCTAssertEqual(adresses[3]?.order, 3)
        XCTAssertEqual((adresses[3]?.address as? TelephoneNumber)?.number, "+4923452425")
        
        XCTAssertEqual(i1.currentLoccation, GeoLocation(latitude: 23.7, longitude: 34.45, elevation: 45.98))
        
        let prevLocations = i1.previousLocations
        XCTAssertEqual(prevLocations.count, 2)
        
        XCTAssertEqual(prevLocations[0], GeoLocation(latitude: 12.1, longitude: 13.2, elevation: 14.3))
        XCTAssertEqual(prevLocations[1], GeoLocation(latitude: 22.1, longitude: 23.2, elevation: 24.3))
        
        let moods = i1.moods
        XCTAssertEqual(moods.count, 3)
        
        XCTAssertEqual(moods[0], Mood.Funny)
        XCTAssertEqual(moods[1], Mood.Humble)
        XCTAssertEqual(moods[2], Mood.Serious)
        
        
        XCTAssertEqual(i2.name, "Anonymous")
        XCTAssertNil(i2.birthday)
        XCTAssertEqual(i2.gender, .Male) // beacuse default
        XCTAssertEqual(i2.tags.count, 0)
        XCTAssertEqual(i2.addressEntries.count, 0)
        XCTAssertNil(i2.currentLoccation)
        XCTAssertEqual(i2.previousLocations.count, 0)
        XCTAssertEqual(i2.moods.count, 1)
        XCTAssertEqual(i2.moods[0], Mood.Angry)
    }
    
    
    func testToDataDirectRead() {
        let contactList = createContactList()
        
        let data = try?contactList.makeData()
        
        XCTAssertNotNil(data)
        
        let reader = FlatBuffersMemoryReader(data: data!)
        
        let readContactList = ContactList_Direct(reader)!
        XCTAssertEqual(readContactList.lastModified, 2349873427654)
        XCTAssertEqual(readContactList.entriesCount, 2)
        
        let i1 = readContactList.entriesElement(atIndex: 0)!
        let i2 = readContactList.entriesElement(atIndex: 1)!
        
        XCTAssertEqual(i1.name?§, "Maxim")
        XCTAssertEqual(i1.birthday!.day, 12)
        XCTAssertEqual(i1.birthday!.month, 6)
        XCTAssertEqual(i1.birthday!.year, 1981)
        
        XCTAssertEqual(i1.gender, .Male)
        
        XCTAssertEqual(i1.tagsCount, 3)
        XCTAssertEqual(i1.tagsElement(atIndex: 0)?§, "h1")
        XCTAssertEqual(i1.tagsElement(atIndex: 1)?§, "h2")
        XCTAssertEqual(i1.tagsElement(atIndex: 2)?§, "h3")
        
        XCTAssertEqual(i1.addressEntriesCount, 4)
        
        XCTAssertEqual(i1.addressEntriesElement(atIndex: 0)?.order, 0)
        let mailto = (i1.addressEntriesElement(atIndex: 0)?.address as? EmailAddress_Direct<FlatBuffersMemoryReader>)?.mailto?§
        XCTAssertEqual(mailto, "bla@bla.io")
        
        XCTAssertEqual(i1.addressEntriesElement(atIndex: 1)?.order, 1)
        XCTAssertEqual((i1.addressEntriesElement(atIndex: 1)?.address as? PostalAddress_Direct<FlatBuffersMemoryReader>)?.country?§, "DE")
        XCTAssertEqual((i1.addressEntriesElement(atIndex: 1)?.address as? PostalAddress_Direct<FlatBuffersMemoryReader>)?.city?§, "Berlin")
        XCTAssertEqual((i1.addressEntriesElement(atIndex: 1)?.address as? PostalAddress_Direct<FlatBuffersMemoryReader>)?.postalCode, 13000)
        XCTAssertEqual((i1.addressEntriesElement(atIndex: 1)?.address as? PostalAddress_Direct<FlatBuffersMemoryReader>)?.streetAndNumber?§, "Balstr, 23")
        
        XCTAssertEqual(i1.addressEntriesElement(atIndex: 2)?.order, 2)
        XCTAssertEqual((i1.addressEntriesElement(atIndex: 2)?.address as? WebAddress_Direct<FlatBuffersMemoryReader>)?.url?§, "http://slkf.com")
        
        XCTAssertEqual(i1.addressEntriesElement(atIndex: 3)?.order, 3)
        XCTAssertEqual((i1.addressEntriesElement(atIndex: 3)?.address as? TelephoneNumber_Direct<FlatBuffersMemoryReader>)?.number?§, "+4923452425")
        
        XCTAssertEqual(i1.currentLoccation, GeoLocation(latitude: 23.7, longitude: 34.45, elevation: 45.98))
        
        XCTAssertEqual(i1.previousLocationsCount, 2)
        
        XCTAssertEqual(i1.previousLocationsElement(atIndex: 0), GeoLocation(latitude: 12.1, longitude: 13.2, elevation: 14.3))
        XCTAssertEqual(i1.previousLocationsElement(atIndex: 1), GeoLocation(latitude: 22.1, longitude: 23.2, elevation: 24.3))
        
        XCTAssertEqual(i1.moodsCount, 3)
        
        XCTAssertEqual(i1.moodsElement(atIndex: 0), Mood.Funny)
        XCTAssertEqual(i1.moodsElement(atIndex: 1), Mood.Humble)
        XCTAssertEqual(i1.moodsElement(atIndex: 2), Mood.Serious)
        
        
        XCTAssertEqual(i2.name?§, "Anonymous")
        XCTAssertNil(i2.birthday)
        XCTAssertEqual(i2.gender, .Male) // beacuse default
        XCTAssertEqual(i2.tagsCount, 0)
        XCTAssertEqual(i2.addressEntriesCount, 0)
        XCTAssertNil(i2.currentLoccation)
        XCTAssertEqual(i2.previousLocationsCount, 0)
        XCTAssertEqual(i2.moodsCount, 1)
        XCTAssertEqual(i2.moodsElement(atIndex: 0), Mood.Angry)
    }
    
    func testToFileFromFile() {
        let contactList = createContactList()
        
        let data = try?contactList.makeData()
        XCTAssertNotNil(data)
        
        let fileHandle = writeToFileAndReturnHandle(data)
        let fileReader = FlatBuffersFileReader(fileHandle: fileHandle)
        
        let readContactList = ContactList.makeContactList(reader: fileReader)!
        XCTAssertEqual(readContactList.lastModified, 2349873427654)
        XCTAssertEqual(readContactList.entries.count, 2)
        
        let i1 = readContactList.entries[0]!
        let i2 = readContactList.entries[1]!
        
        XCTAssertEqual(i1.name, "Maxim")
        XCTAssertEqual(i1.birthday!.day, 12)
        XCTAssertEqual(i1.birthday!.month, 6)
        XCTAssertEqual(i1.birthday!.year, 1981)
        
        XCTAssertEqual(i1.gender, .Male)
        let tags = i1.tags
        XCTAssertEqual(tags.count, 3)
        
        XCTAssertEqual(tags[0], "h1")
        XCTAssertEqual(tags[1], "h2")
        XCTAssertEqual(tags[2], "h3")
        
        let adresses = i1.addressEntries
        XCTAssertEqual(adresses.count, 4)
        
        XCTAssertEqual(adresses[0]?.order, 0)
        XCTAssertEqual((adresses[0]?.address as? EmailAddress)?.mailto, "bla@bla.io")
        
        XCTAssertEqual(adresses[1]?.order, 1)
        XCTAssertEqual((adresses[1]?.address as? PostalAddress)?.country, "DE")
        XCTAssertEqual((adresses[1]?.address as? PostalAddress)?.city, "Berlin")
        XCTAssertEqual((adresses[1]?.address as? PostalAddress)?.postalCode, 13000)
        XCTAssertEqual((adresses[1]?.address as? PostalAddress)?.streetAndNumber, "Balstr, 23")
        
        XCTAssertEqual(adresses[2]?.order, 2)
        XCTAssertEqual((adresses[2]?.address as? WebAddress)?.url, "http://slkf.com")
        
        XCTAssertEqual(adresses[3]?.order, 3)
        XCTAssertEqual((adresses[3]?.address as? TelephoneNumber)?.number, "+4923452425")
        
        XCTAssertEqual(i1.currentLoccation, GeoLocation(latitude: 23.7, longitude: 34.45, elevation: 45.98))
        
        let prevLocations = i1.previousLocations
        XCTAssertEqual(prevLocations.count, 2)
        
        XCTAssertEqual(prevLocations[0], GeoLocation(latitude: 12.1, longitude: 13.2, elevation: 14.3))
        XCTAssertEqual(prevLocations[1], GeoLocation(latitude: 22.1, longitude: 23.2, elevation: 24.3))
        
        let moods = i1.moods
        XCTAssertEqual(moods.count, 3)
        
        XCTAssertEqual(moods[0], Mood.Funny)
        XCTAssertEqual(moods[1], Mood.Humble)
        XCTAssertEqual(moods[2], Mood.Serious)
        
        
        XCTAssertEqual(i2.name, "Anonymous")
        XCTAssertNil(i2.birthday)
        XCTAssertEqual(i2.gender, .Male) // beacuse default
        XCTAssertEqual(i2.tags.count, 0)
        XCTAssertEqual(i2.addressEntries.count, 0)
        XCTAssertNil(i2.currentLoccation)
        XCTAssertEqual(i2.previousLocations.count, 0)
        XCTAssertEqual(i2.moods.count, 1)
        XCTAssertEqual(i2.moods[0], Mood.Angry)
    }
    
    func testToFileDirectRead() {
        let contactList = createContactList()
        
        let data = try?contactList.makeData()
        
        XCTAssertNotNil(data)
        
        let fileHandle = writeToFileAndReturnHandle(data)
        let fileReader = FlatBuffersFileReader(fileHandle: fileHandle)
        
        let readContactList = ContactList_Direct(fileReader)!
        XCTAssertEqual(readContactList.lastModified, 2349873427654)
        XCTAssertEqual(readContactList.entriesCount, 2)
        
        let i1 = readContactList.entriesElement(atIndex: 0)!
        let i2 = readContactList.entriesElement(atIndex: 1)!
        
        XCTAssertEqual(i1.name?§, "Maxim")
        XCTAssertEqual(i1.birthday!.day, 12)
        XCTAssertEqual(i1.birthday!.month, 6)
        XCTAssertEqual(i1.birthday!.year, 1981)
        
        XCTAssertEqual(i1.gender, .Male)
        
        XCTAssertEqual(i1.tagsCount, 3)
        XCTAssertEqual(i1.tagsElement(atIndex: 0)?§, "h1")
        XCTAssertEqual(i1.tagsElement(atIndex: 1)?§, "h2")
        XCTAssertEqual(i1.tagsElement(atIndex: 2)?§, "h3")
        
        XCTAssertEqual(i1.addressEntriesCount, 4)
        
        XCTAssertEqual(i1.addressEntriesElement(atIndex: 0)?.order, 0)
        let mailto = (i1.addressEntriesElement(atIndex: 0)?.address as? EmailAddress_Direct<FlatBuffersFileReader>)?.mailto?§
        XCTAssertEqual(mailto, "bla@bla.io")
        
        XCTAssertEqual(i1.addressEntriesElement(atIndex: 1)?.order, 1)
        XCTAssertEqual((i1.addressEntriesElement(atIndex: 1)?.address as? PostalAddress_Direct<FlatBuffersFileReader>)?.country?§, "DE")
        XCTAssertEqual((i1.addressEntriesElement(atIndex: 1)?.address as? PostalAddress_Direct<FlatBuffersFileReader>)?.city?§, "Berlin")
        XCTAssertEqual((i1.addressEntriesElement(atIndex: 1)?.address as? PostalAddress_Direct<FlatBuffersFileReader>)?.postalCode, 13000)
        XCTAssertEqual((i1.addressEntriesElement(atIndex: 1)?.address as? PostalAddress_Direct<FlatBuffersFileReader>)?.streetAndNumber?§, "Balstr, 23")
        
        XCTAssertEqual(i1.addressEntriesElement(atIndex: 2)?.order, 2)
        XCTAssertEqual((i1.addressEntriesElement(atIndex: 2)?.address as? WebAddress_Direct<FlatBuffersFileReader>)?.url?§, "http://slkf.com")
        
        XCTAssertEqual(i1.addressEntriesElement(atIndex: 3)?.order, 3)
        XCTAssertEqual((i1.addressEntriesElement(atIndex: 3)?.address as? TelephoneNumber_Direct<FlatBuffersFileReader>)?.number?§, "+4923452425")
        
        XCTAssertEqual(i1.currentLoccation, GeoLocation(latitude: 23.7, longitude: 34.45, elevation: 45.98))
        
        XCTAssertEqual(i1.previousLocationsCount, 2)
        
        XCTAssertEqual(i1.previousLocationsElement(atIndex: 0), GeoLocation(latitude: 12.1, longitude: 13.2, elevation: 14.3))
        XCTAssertEqual(i1.previousLocationsElement(atIndex: 1), GeoLocation(latitude: 22.1, longitude: 23.2, elevation: 24.3))
        
        XCTAssertEqual(i1.moodsCount, 3)
        
        XCTAssertEqual(i1.moodsElement(atIndex: 0), Mood.Funny)
        XCTAssertEqual(i1.moodsElement(atIndex: 1), Mood.Humble)
        XCTAssertEqual(i1.moodsElement(atIndex: 2), Mood.Serious)
        
        
        XCTAssertEqual(i2.name?§, "Anonymous")
        XCTAssertNil(i2.birthday)
        XCTAssertEqual(i2.gender, .Male) // beacuse default
        XCTAssertEqual(i2.tagsCount, 0)
        XCTAssertEqual(i2.addressEntriesCount, 0)
        XCTAssertNil(i2.currentLoccation)
        XCTAssertEqual(i2.previousLocationsCount, 0)
        XCTAssertEqual(i2.moodsCount, 1)
        XCTAssertEqual(i2.moodsElement(atIndex: 0), Mood.Angry)
    }
    
    func createContactList() -> ContactList {
        let contactList = ContactList()
        contactList.lastModified = 2349873427654
        let item1 = Contact(name: "Maxim",
                            birthday: Date(day: 12, month: 6, year: 1981),
                            gender: .Male,
                            tags: ["h1", "h2", "h3"],
                            addressEntries: [
                                AddressEntry(order: 0, address: EmailAddress(mailto: "bla@bla.io")),
                                AddressEntry(order: 1, address: PostalAddress(country: "DE", city: "Berlin", postalCode: 13000, streetAndNumber: "Balstr, 23")),
                                AddressEntry(order: 2, address: WebAddress(url: "http://slkf.com")),
                                AddressEntry(order: 3, address: TelephoneNumber(number: "+4923452425"))
            ],
                            currentLoccation: GeoLocation(latitude: 23.7, longitude: 34.45, elevation: 45.98),
                            previousLocations: [
                                GeoLocation(latitude: 12.1, longitude: 13.2, elevation: 14.3),
                                GeoLocation(latitude: 22.1, longitude: 23.2, elevation: 24.3),
                                ],
                            moods: [Mood.Funny, Mood.Humble, Mood.Serious])
        
        let item2 = Contact(name: "Anonymous",
                            birthday: nil,
                            gender: nil,
                            tags: [],
                            addressEntries: [],
                            currentLoccation: nil,
                            previousLocations: [],
                            moods: [Mood.Angry])
        
        contactList.entries = [item1, item2]
        return contactList
    }
    
    func writeToFileAndReturnHandle(_ data : Data?) -> FileHandle {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.bundleURL.deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent("contacts.dat")
        
        try?data?.write(to: url)
        return try!FileHandle(forReadingFrom: url)
    }
}
