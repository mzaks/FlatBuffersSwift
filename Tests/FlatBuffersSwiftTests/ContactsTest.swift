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
        
        let readContactList = ContactList.from(data: data!)!
        XCTAssertEqual(readContactList.lastModified, 2349873427654)
        XCTAssertEqual(readContactList.entries.count, 2)
        
        let i1 = readContactList.entries[0]
        let i2 = readContactList.entries[1]
        
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
        
        XCTAssertEqual(adresses[0].order, 0)
        XCTAssertEqual((adresses[0].address?.asEmailAddress)?.mailto, "bla@bla.io")
        
        XCTAssertEqual(adresses[1].order, 1)
        XCTAssertEqual((adresses[1].address?.asPostalAddress)?.country, "DE")
        XCTAssertEqual((adresses[1].address?.asPostalAddress)?.city, "Berlin")
        XCTAssertEqual((adresses[1].address?.asPostalAddress)?.postalCode, 13000)
        XCTAssertEqual((adresses[1].address?.asPostalAddress)?.streetAndNumber, "Balstr, 23")
        
        XCTAssertEqual(adresses[2].order, 2)
        XCTAssertEqual((adresses[2].address?.asWebAddress)?.url, "http://slkf.com")
        
        XCTAssertEqual(adresses[3].order, 3)
        XCTAssertEqual((adresses[3].address?.asTelephoneNumber)?.number, "+4923452425")
        
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
        
        let numbers = i1.luckyNumbers
        XCTAssertEqual(numbers.count, 3)
        
        XCTAssertEqual(numbers[0], 1)
        XCTAssertEqual(numbers[1], 23)
        XCTAssertEqual(numbers[2], 45)
        
        
        XCTAssertEqual(i2.name, "Anonymous")
        XCTAssertNil(i2.birthday)
        XCTAssertEqual(i2.gender, .Male) // beacuse default
        XCTAssertEqual(i2.tags.count, 0)
        XCTAssertEqual(i2.addressEntries.count, 0)
        XCTAssertNil(i2.currentLoccation)
        XCTAssertEqual(i2.previousLocations.count, 0)
        XCTAssertEqual(i2.moods.count, 1)
        XCTAssertEqual(i2.moods[0], Mood.Angry)
        XCTAssertEqual(i2.luckyNumbers.count, 0)
    }
    
    
    func testToDataDirectRead() {
        let contactList = createContactList()
        
        let data = try?contactList.makeData()
        
        XCTAssertNotNil(data)
        
        let reader = FlatBuffersMemoryReader(data: data!)
        
        let readContactList = ContactList.Direct<FlatBuffersMemoryReader>(reader: reader)!
        XCTAssertEqual(readContactList.lastModified, 2349873427654)
        
        let entries = readContactList.entries
        XCTAssertEqual(entries.count, 2)
        
        let i1 = entries[0]!
        let i2 = entries[1]!
        
        XCTAssertEqual(i1.name?§, "Maxim")
        XCTAssertEqual(i1.birthday!.day, 12)
        XCTAssertEqual(i1.birthday!.month, 6)
        XCTAssertEqual(i1.birthday!.year, 1981)
        
        XCTAssertEqual(i1.gender, .Male)
        
        XCTAssertEqual(i1.tags.count, 3)
        XCTAssertEqual(i1.tags[0]?§, "h1")
        XCTAssertEqual(i1.tags[1]?§, "h2")
        XCTAssertEqual(i1.tags[2]?§, "h3")
        
        XCTAssertEqual(i1.addressEntries.count, 4)
        
        XCTAssertEqual(i1.addressEntries[0]?.order, 0)
        let mailto = (i1.addressEntries[0]?.address?.asEmailAddress)?.mailto?§
        XCTAssertEqual(mailto, "bla@bla.io")
        
        XCTAssertEqual(i1.addressEntries[1]?.order, 1)
        XCTAssertEqual((i1.addressEntries[1]?.address?.asPostalAddress)?.country?§, "DE")
        XCTAssertEqual((i1.addressEntries[1]?.address?.asPostalAddress)?.city?§, "Berlin")
        XCTAssertEqual((i1.addressEntries[1]?.address?.asPostalAddress)?.postalCode, 13000)
        XCTAssertEqual((i1.addressEntries[1]?.address?.asPostalAddress)?.streetAndNumber?§, "Balstr, 23")
        
        XCTAssertEqual(i1.addressEntries[2]?.order, 2)
        XCTAssertEqual((i1.addressEntries[2]?.address?.asWebAddress)?.url?§, "http://slkf.com")
        
        XCTAssertEqual(i1.addressEntries[3]?.order, 3)
        XCTAssertEqual((i1.addressEntries[3]?.address?.asTelephoneNumber)?.number?§, "+4923452425")
        
        XCTAssertEqual(i1.currentLoccation, GeoLocation(latitude: 23.7, longitude: 34.45, elevation: 45.98))
        
        XCTAssertEqual(i1.previousLocations.count, 2)
        
        XCTAssertEqual(i1.previousLocations[0], GeoLocation(latitude: 12.1, longitude: 13.2, elevation: 14.3))
        XCTAssertEqual(i1.previousLocations[1], GeoLocation(latitude: 22.1, longitude: 23.2, elevation: 24.3))
        
        XCTAssertEqual(i1.moods.count, 3)
        
        XCTAssertEqual(i1.moods[0], Mood.Funny)
        XCTAssertEqual(i1.moods[1], Mood.Humble)
        XCTAssertEqual(i1.moods[2], Mood.Serious)
        
        
        let numbers = i1.luckyNumbers
        XCTAssertEqual(numbers.count, 3)
        
        
        XCTAssertEqual(numbers[0], 1)
        XCTAssertEqual(numbers[1], 23)
        XCTAssertEqual(numbers[2], 45)
        
        
        XCTAssertEqual(i2.name?§, "Anonymous")
        XCTAssertNil(i2.birthday)
        XCTAssertEqual(i2.gender, .Male) // beacuse default
        XCTAssertEqual(i2.tags.count, 0)
        XCTAssertEqual(i2.addressEntries.count, 0)
        XCTAssertNil(i2.currentLoccation)
        XCTAssertEqual(i2.previousLocations.count, 0)
        XCTAssertEqual(i2.moods.count, 1)
        XCTAssertEqual(i2.moods[0], Mood.Angry)
        XCTAssertEqual(i2.luckyNumbers.count, 0)
    }
    
    func testToFileDirectRead() {
        let contactList = createContactList()
        
        let data = try?contactList.makeData()
        
        XCTAssertNotNil(data)
        
        let fileHandle = writeToFileAndReturnHandle(data)
        let fileReader = FlatBuffersFileReader(fileHandle: fileHandle)
        
        let readContactList = ContactList.Direct<FlatBuffersFileReader>(reader: fileReader)!
        XCTAssertEqual(readContactList.lastModified, 2349873427654)
        XCTAssertEqual(readContactList.entries.count, 2)
        
        let i1 = readContactList.entries[0]!
        let i2 = readContactList.entries[1]!
        
        XCTAssertEqual(i1.name?§, "Maxim")
        XCTAssertEqual(i1.birthday!.day, 12)
        XCTAssertEqual(i1.birthday!.month, 6)
        XCTAssertEqual(i1.birthday!.year, 1981)
        
        XCTAssertEqual(i1.gender, .Male)
        
        XCTAssertEqual(i1.tags.count, 3)
        XCTAssertEqual(i1.tags[0]?§, "h1")
        XCTAssertEqual(i1.tags[1]?§, "h2")
        XCTAssertEqual(i1.tags[2]?§, "h3")
        
        XCTAssertEqual(i1.addressEntries.count, 4)
        
        XCTAssertEqual(i1.addressEntries[0]?.order, 0)
        let mailto = (i1.addressEntries[0]?.address?.asEmailAddress)?.mailto?§
        XCTAssertEqual(mailto, "bla@bla.io")
        
        XCTAssertEqual(i1.addressEntries[1]?.order, 1)
        XCTAssertEqual((i1.addressEntries[1]?.address?.asPostalAddress)?.country?§, "DE")
        XCTAssertEqual((i1.addressEntries[1]?.address?.asPostalAddress)?.city?§, "Berlin")
        XCTAssertEqual((i1.addressEntries[1]?.address?.asPostalAddress)?.postalCode, 13000)
        XCTAssertEqual((i1.addressEntries[1]?.address?.asPostalAddress)?.streetAndNumber?§, "Balstr, 23")
        
        XCTAssertEqual(i1.addressEntries[2]?.order, 2)
        XCTAssertEqual((i1.addressEntries[2]?.address?.asWebAddress)?.url?§, "http://slkf.com")
        
        XCTAssertEqual(i1.addressEntries[3]?.order, 3)
        XCTAssertEqual((i1.addressEntries[3]?.address?.asTelephoneNumber)?.number?§, "+4923452425")
        
        XCTAssertEqual(i1.currentLoccation, GeoLocation(latitude: 23.7, longitude: 34.45, elevation: 45.98))
        
        XCTAssertEqual(i1.previousLocations.count, 2)
        
        XCTAssertEqual(i1.previousLocations[0], GeoLocation(latitude: 12.1, longitude: 13.2, elevation: 14.3))
        XCTAssertEqual(i1.previousLocations[1], GeoLocation(latitude: 22.1, longitude: 23.2, elevation: 24.3))
        
        XCTAssertEqual(i1.moods.count, 3)
        
        XCTAssertEqual(i1.moods[0], Mood.Funny)
        XCTAssertEqual(i1.moods[1], Mood.Humble)
        XCTAssertEqual(i1.moods[2], Mood.Serious)
        
        let numbers = i1.luckyNumbers
        
        XCTAssertEqual(numbers.count, 3)
        
        XCTAssertEqual(numbers[0], 1)
        XCTAssertEqual(numbers[1], 23)
        XCTAssertEqual(numbers[2], 45)
        
        
        XCTAssertEqual(i2.name?§, "Anonymous")
        XCTAssertNil(i2.birthday)
        XCTAssertEqual(i2.gender, .Male) // beacuse default
        XCTAssertEqual(i2.tags.count, 0)
        XCTAssertEqual(i2.addressEntries.count, 0)
        XCTAssertNil(i2.currentLoccation)
        XCTAssertEqual(i2.previousLocations.count, 0)
        XCTAssertEqual(i2.moods.count, 1)
        XCTAssertEqual(i2.moods[0], Mood.Angry)
        XCTAssertEqual(i2.luckyNumbers.count, 0)
    }
    
    func createContactList() -> ContactList {
        let contactList = ContactList()
        contactList.lastModified = 2349873427654
        let item1 = Contact(name: "Maxim",
                            birthday: Date(day: 12, month: 6, year: 1981),
                            gender: .Male,
                            tags: ["h1", "h2", "h3"],
                            addressEntries: [
                                AddressEntry(order: 0, address: .withEmailAddress(EmailAddress(mailto: "bla@bla.io"))),
                                AddressEntry(order: 1, address: .withPostalAddress(PostalAddress(country: "DE", city: "Berlin", postalCode: 13000, streetAndNumber: "Balstr, 23"))),
                                AddressEntry(order: 2, address: .withWebAddress(WebAddress(url: "http://slkf.com"))),
                                AddressEntry(order: 3, address: .withTelephoneNumber(TelephoneNumber(number: "+4923452425")))
            ],
                            currentLoccation: GeoLocation(latitude: 23.7, longitude: 34.45, elevation: 45.98),
                            previousLocations: [
                                GeoLocation(latitude: 12.1, longitude: 13.2, elevation: 14.3),
                                GeoLocation(latitude: 22.1, longitude: 23.2, elevation: 24.3),
                                ],
                            moods: [Mood.Funny, Mood.Humble, Mood.Serious],
                            luckyNumbers: [1, 23, 45])
        
        let item2 = Contact(name: "Anonymous",
                            birthday: nil,
                            gender: nil,
                            tags: [],
                            addressEntries: [],
                            currentLoccation: nil,
                            previousLocations: [],
                            moods: [Mood.Angry],
                            luckyNumbers: [])
        
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
