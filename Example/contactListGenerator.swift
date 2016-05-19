//
//  contactListGenerator.swift
//  FlatBuffersSwift
//
//  Created by Maxim Zaks on 15.01.16.
//  Copyright © 2016 maxim.zaks. All rights reserved.
//

import Foundation

public func generateRandomContactList(count : Int = 10_000) -> ContactList {
    let contactList = ContactList()
    contactList.lastModified = Int64(rnd())
    var contacts = ContiguousArray<Contact?>()
    for _ in 0 ..< count {
        contacts.append(generateContact())
    }
    contactList.entries = contacts
    return contactList
}

private func generateContact() -> Contact {
    let contact = Contact()
    contact.addressEntries = generateAddress()
    contact.birthday = generateDate()
    contact.currentLoccation = generateLocation()
    contact.gender = Gender(rawValue: Int8(rnd(2)))
    contact.moods = generateMoods()
    contact.name = randomString()
    contact.previousLocations = generateLocations()
    contact.tags = randomNumberStrings()
    return contact
}

private func generateDate() -> Date {
    let date = Date()
    date.day = Int8(rnd(30) + 1)
    date.month = Int8(rnd(12) + 1)
    date.year = Int16(rnd(110) + 1900)
    return date
}

private func generateAddress() -> [AddressEntry?] {
    var address : [AddressEntry?] = []
    for i in 1...2{
        let entry = AddressEntry()
        entry.order = Int32(i)
        let unionCase = rnd(4) + 1
        switch unionCase {
        case 1 : entry.address = generatePostal()
        case 2 : entry.address = generateEmail()
        case 3 : entry.address = generateWeb()
        case 4 : entry.address = generateTel()
        default: break
        }
        address.append(entry)
    }
    return address
}

private let cities = ["Berlin", "Cologne", "Madrid", "Moscow", "New York", "Bagdad", "Tel Aviv", "Paris", "San Francisco", "Washington", "Munich", "Hamburg", "Warsaw", "Aarhus"]

private let countries = ["Germany", "USA", "Brazil", "Iran", "Egypt", "France", "Poland", "Denmark", "Israel", "Rusia"]

private func generatePostal() -> PostalAddress {
    let result = PostalAddress()
    result.city = oneOf(cities)
    result.country = oneOf(countries)
    result.postalCode = Int32(rnd(99999) + 1)
    result.streetAndNumber = randomString()
    return result
}

private func generateEmail() -> EmailAddress {
    let result = EmailAddress()
    result.mailto = "\(randomString())@\(randomString()).com"
    return result
}

private func generateWeb() -> WebAddress {
    let result = WebAddress()
    result.url = "http://www.\(randomString()).com"
    return result
}

private func generateTel() -> TelephoneNumber {
    let result = TelephoneNumber()
    result.number = randomNumberString()
    return result
}

private func generateLocation() -> GeoLocation {
    return GeoLocation(latitude: 2.5, longitude: 3.5, elevation: 7.5, s: S1(i:12))
}

private func generateLocations() -> [GeoLocation?] {
    let length = Int(rnd(5))
    var locations : [GeoLocation?] = []
    for _ in 0..<length {
        locations.append(generateLocation())
    }
    return locations
}


private func generateMoods() -> [Mood?] {
    let length = Int(rnd(5))
    var moods : [Mood?] = []
    for _ in 0..<length {
        moods.append(Mood(rawValue: Int8(rnd(4))))
    }
    return moods
}

private func randomNumberStrings() -> [String?] {
    let length = Int(rnd(5))
    var result : [String?] = []
    for _ in 0..<length {
        result.append(randomNumberString())
    }
    return result
}


private func oneOf<T>(array : [T]) -> T {
    return array[Int(rnd(UInt32(array.count)))]
}

private func rnd(mod : UInt32 = UINT32_MAX) -> UInt32 {
    return arc4random_uniform(UINT32_MAX) % mod
}

private func randomString() -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let length = rnd(30)
    var s = String()
    for _ in 0 ... length {
        let i = Int(rnd(UInt32(letters.characters.count)))
        let index = letters.startIndex.advancedBy(i)
        s.append(letters[index])
    }
    return s
}

private func randomNumberString() -> String {
    let letters = "0123456789"
    let length = rnd(10)
    var s = String()
    for _ in 0 ... length {
        let i = Int(rnd(UInt32(letters.characters.count)))
        let index = letters.startIndex.advancedBy(i)
        s.append(letters[index])
    }
    return s
}