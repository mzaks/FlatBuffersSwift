import Foundation
import FlatBuffersSwift

public final class ContactList {
    public var lastModified: Int64
    public var entries: [Contact]
    public init(lastModified: Int64 = 0, entries: [Contact] = []) {
        self.lastModified = lastModified
        self.entries = entries
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}
extension ContactList.Direct {
    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset? = nil) {
        guard let reader = reader as? T else {
            return nil
        }
        self._reader = reader
        if let myOffset = myOffset {
            self._myOffset = myOffset
        } else {
            if let rootOffset = reader.rootObjectOffset {
                self._myOffset = rootOffset
            } else {
                return nil
            }
        }
    }
    public var hashValue: Int { return Int(_myOffset) }
    public static func ==<T>(t1 : ContactList.Direct<T>, t2 : ContactList.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var lastModified: Int64 {
        
        return _reader.get(objectOffset: _myOffset, propertyIndex: 0, defaultValue: 0)
    }
    public var entries: FlatBuffersTableVector<Contact.Direct<T>, T> {
        
        return FlatBuffersTableVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:1))
    }
}
extension ContactList {
    public static func from(data: Data) -> ContactList? {
        let reader = FlatBuffersMemoryReader(data: data, withoutCopy: false)
        return ContactList.from(selfReader: Direct<FlatBuffersMemoryReader>(reader: reader))
    }
    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> ContactList? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? ContactList {
            return o
        }
        return ContactList(
            lastModified: selfReader.lastModified,
            entries: selfReader.entries.flatMap{ Contact.from(selfReader:$0) }
        )
    }
}
extension FlatBuffersBuilder {
    public func insertContactList(lastModified: Int64 = 0, entries: Offset? = nil) throws -> Offset {
        try self.startObject(withPropertyCount: 2)
        if let entries = entries {
            try self.insert(offset: entries, toStartedObjectAt: 1)
        }
        try self.insert(value: lastModified, defaultValue: 0, toStartedObjectAt: 0)
        return try self.endObject()
    }
}
extension ContactList {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }
        let entries: Offset?
        if self.entries.isEmpty {
            entries = nil
        } else {
            let offsets = try self.entries.map{ try $0.insert(builder) }
            try builder.startVector(count: self.entries.count, elementSize: MemoryLayout<Offset>.stride)
            for o in offsets.reversed() {
               try builder.insert(offset: o)
            }
            entries = builder.endVector()
        }
        return try builder.insertContactList(
            lastModified: lastModified,
            entries: entries
        )
    }
    public func makeData(withOptions options : FlatBuffersBuilderOptions = FlatBuffersBuilderOptions()) throws -> Data {
        let builder = FlatBuffersBuilder(options: options)
        let offset = try insert(builder)
        try builder.finish(offset: offset, fileIdentifier: nil)
        return builder.makeData
    }
}
public final class Contact {
    public var name: String?
    public var birthday: Date?
    public var gender: Gender?
    public var tags: [String]
    public var addressEntries: [AddressEntry]
    public var currentLoccation: GeoLocation?
    public var previousLocations: [GeoLocation]
    public var moods: [Mood]
    public var luckyNumbers: [Int32]
    public var alive: Bool
    public var successfulLogins: [Bool]
    public init(name: String? = nil, birthday: Date? = nil, gender: Gender? = Gender.Male, tags: [String] = [], addressEntries: [AddressEntry] = [], currentLoccation: GeoLocation? = nil, previousLocations: [GeoLocation] = [], moods: [Mood] = [], luckyNumbers: [Int32] = [], alive: Bool = false, successfulLogins: [Bool] = []) {
        self.name = name
        self.birthday = birthday
        self.gender = gender
        self.tags = tags
        self.addressEntries = addressEntries
        self.currentLoccation = currentLoccation
        self.previousLocations = previousLocations
        self.moods = moods
        self.luckyNumbers = luckyNumbers
        self.alive = alive
        self.successfulLogins = successfulLogins
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}
extension Contact.Direct {
    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset? = nil) {
        guard let reader = reader as? T else {
            return nil
        }
        self._reader = reader
        if let myOffset = myOffset {
            self._myOffset = myOffset
        } else {
            if let rootOffset = reader.rootObjectOffset {
                self._myOffset = rootOffset
            } else {
                return nil
            }
        }
    }
    public var hashValue: Int { return Int(_myOffset) }
    public static func ==<T>(t1 : Contact.Direct<T>, t2 : Contact.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var name: UnsafeBufferPointer<UInt8>? {
        guard let offset = _reader.offset(objectOffset: _myOffset, propertyIndex:0) else {return nil}
        return _reader.stringBuffer(stringOffset: offset)
    }
    public var birthday: Date.Direct<T>? {
        guard let offset = _reader.offset(objectOffset: _myOffset, propertyIndex:1) else {return nil}
        return Date.Direct(reader: _reader, myOffset: offset)
    }
    public var gender: Gender? {
        
        return Gender(rawValue:_reader.get(objectOffset: _myOffset, propertyIndex: 2, defaultValue: Gender.Male.rawValue))
    }
    public var tags: FlatBuffersStringVector<T> {
        
        return FlatBuffersStringVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:3))
    }
    public var addressEntries: FlatBuffersTableVector<AddressEntry.Direct<T>, T> {
        
        return FlatBuffersTableVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:4))
    }
    public var currentLoccation: GeoLocation? {
        
        return _reader.get(objectOffset: _myOffset, propertyIndex: 5)
    }
    public var previousLocations: FlatBuffersScalarVector<GeoLocation, T> {
        
        return FlatBuffersScalarVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:6))
    }
    public var moods: FlatBuffersEnumVector<Int8, T, Mood> {
        
        return FlatBuffersEnumVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:7))
    }
    public var luckyNumbers: FlatBuffersScalarVector<Int32, T> {
        
        return FlatBuffersScalarVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:8))
    }
    public var alive: Bool {
        
        return _reader.get(objectOffset: _myOffset, propertyIndex: 9, defaultValue: false)
    }
    public var successfulLogins: FlatBuffersScalarVector<Bool, T> {
        
        return FlatBuffersScalarVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:10))
    }
}
extension Contact {

    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> Contact? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? Contact {
            return o
        }
        return Contact(
            name: selfReader.name§,
            birthday: Date.from(selfReader:selfReader.birthday),
            gender: selfReader.gender,
            tags: selfReader.tags.flatMap{ $0§ },
            addressEntries: selfReader.addressEntries.flatMap{ AddressEntry.from(selfReader:$0) },
            currentLoccation: selfReader.currentLoccation,
            previousLocations: selfReader.previousLocations.flatMap{$0},
            moods: selfReader.moods.flatMap{$0},
            luckyNumbers: selfReader.luckyNumbers.flatMap{$0},
            alive: selfReader.alive,
            successfulLogins: selfReader.successfulLogins.flatMap{$0}
        )
    }
}
extension FlatBuffersBuilder {
    public func insertContact(name: Offset? = nil, birthday: Offset? = nil, gender: Gender = Gender.Male, tags: Offset? = nil, addressEntries: Offset? = nil, currentLoccation: GeoLocation? = nil, previousLocations: Offset? = nil, moods: Offset? = nil, luckyNumbers: Offset? = nil, alive: Bool = false, successfulLogins: Offset? = nil) throws -> Offset {
        try self.startObject(withPropertyCount: 11)
        try self.insert(value: gender.rawValue, defaultValue: Gender.Male.rawValue, toStartedObjectAt: 2)
        try self.insert(value: alive, defaultValue: false, toStartedObjectAt: 9)
        if let name = name {
            try self.insert(offset: name, toStartedObjectAt: 0)
        }
        if let birthday = birthday {
            try self.insert(offset: birthday, toStartedObjectAt: 1)
        }
        if let tags = tags {
            try self.insert(offset: tags, toStartedObjectAt: 3)
        }
        if let addressEntries = addressEntries {
            try self.insert(offset: addressEntries, toStartedObjectAt: 4)
        }
        if let previousLocations = previousLocations {
            try self.insert(offset: previousLocations, toStartedObjectAt: 6)
        }
        if let moods = moods {
            try self.insert(offset: moods, toStartedObjectAt: 7)
        }
        if let luckyNumbers = luckyNumbers {
            try self.insert(offset: luckyNumbers, toStartedObjectAt: 8)
        }
        if let successfulLogins = successfulLogins {
            try self.insert(offset: successfulLogins, toStartedObjectAt: 10)
        }
        if let currentLoccation = currentLoccation {
            self.insert(value: currentLoccation)
            try self.insertCurrentOffsetAsProperty(toStartedObjectAt: 5)
        }
        return try self.endObject()
    }
}
extension Contact {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }
        let name = self.name == nil ? nil : try builder.insert(value: self.name)
        let birthday = try self.birthday?.insert(builder)
        let tags: Offset?
        if self.tags.isEmpty {
            tags = nil
        } else {
            let offsets = try self.tags.map{ try builder.insert(value: $0) }
            try builder.startVector(count: self.tags.count, elementSize: MemoryLayout<Offset>.stride)
            for o in offsets.reversed() {
               try builder.insert(offset: o)
            }
            tags = builder.endVector()
        }
        let addressEntries: Offset?
        if self.addressEntries.isEmpty {
            addressEntries = nil
        } else {
            let offsets = try self.addressEntries.map{ try $0.insert(builder) }
            try builder.startVector(count: self.addressEntries.count, elementSize: MemoryLayout<Offset>.stride)
            for o in offsets.reversed() {
               try builder.insert(offset: o)
            }
            addressEntries = builder.endVector()
        }
        let previousLocations: Offset?
        if self.previousLocations.isEmpty {
            previousLocations = nil
        } else {
            try builder.startVector(count: self.previousLocations.count, elementSize: MemoryLayout<GeoLocation>.stride)
            for o in self.previousLocations.reversed() {
                builder.insert(value: o)
            }
            previousLocations = builder.endVector()
        }
        let moods: Offset?
        if self.moods.isEmpty {
            moods = nil
        } else {
            try builder.startVector(count: self.moods.count, elementSize: MemoryLayout<Mood>.stride)
            for o in self.moods.reversed() {
                builder.insert(value: o.rawValue)
            }
            moods = builder.endVector()
        }
        let luckyNumbers: Offset?
        if self.luckyNumbers.isEmpty {
            luckyNumbers = nil
        } else {
            try builder.startVector(count: self.luckyNumbers.count, elementSize: MemoryLayout<Int32>.stride)
            for o in self.luckyNumbers.reversed() {
                builder.insert(value: o)
            }
            luckyNumbers = builder.endVector()
        }
        let successfulLogins: Offset?
        if self.successfulLogins.isEmpty {
            successfulLogins = nil
        } else {
            try builder.startVector(count: self.successfulLogins.count, elementSize: MemoryLayout<Bool>.stride)
            for o in self.successfulLogins.reversed() {
                builder.insert(value: o)
            }
            successfulLogins = builder.endVector()
        }
        return try builder.insertContact(
            name: name,
            birthday: birthday,
            gender: gender ?? Gender.Male,
            tags: tags,
            addressEntries: addressEntries,
            currentLoccation: currentLoccation,
            previousLocations: previousLocations,
            moods: moods,
            luckyNumbers: luckyNumbers,
            alive: alive,
            successfulLogins: successfulLogins
        )
    }

}
public final class Date {
    public var day: Int8
    public var month: Int8
    public var year: Int16
    public init(day: Int8 = 0, month: Int8 = 0, year: Int16 = 0) {
        self.day = day
        self.month = month
        self.year = year
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}
extension Date.Direct {
    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset? = nil) {
        guard let reader = reader as? T else {
            return nil
        }
        self._reader = reader
        if let myOffset = myOffset {
            self._myOffset = myOffset
        } else {
            if let rootOffset = reader.rootObjectOffset {
                self._myOffset = rootOffset
            } else {
                return nil
            }
        }
    }
    public var hashValue: Int { return Int(_myOffset) }
    public static func ==<T>(t1 : Date.Direct<T>, t2 : Date.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var day: Int8 {
        
        return _reader.get(objectOffset: _myOffset, propertyIndex: 0, defaultValue: 0)
    }
    public var month: Int8 {
        
        return _reader.get(objectOffset: _myOffset, propertyIndex: 1, defaultValue: 0)
    }
    public var year: Int16 {
        
        return _reader.get(objectOffset: _myOffset, propertyIndex: 2, defaultValue: 0)
    }
}
extension Date {

    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> Date? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? Date {
            return o
        }
        return Date(
            day: selfReader.day,
            month: selfReader.month,
            year: selfReader.year
        )
    }
}
extension FlatBuffersBuilder {
    public func insertDate(day: Int8 = 0, month: Int8 = 0, year: Int16 = 0) throws -> Offset {
        try self.startObject(withPropertyCount: 3)
        try self.insert(value: day, defaultValue: 0, toStartedObjectAt: 0)
        try self.insert(value: month, defaultValue: 0, toStartedObjectAt: 1)
        try self.insert(value: year, defaultValue: 0, toStartedObjectAt: 2)
        return try self.endObject()
    }
}
extension Date {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }

        return try builder.insertDate(
            day: day,
            month: month,
            year: year
        )
    }

}
public enum Gender: Int8, FlatBuffersEnum {
    case Male, Female, Other
    public static func fromScalar<T>(_ scalar: T) -> Gender? where T : Scalar {
        guard let value = scalar as? RawValue else {
            return nil
        }
        return Gender(rawValue: value)
    }
}
public final class AddressEntry {
    public var order: Int32
    public var address: Address?
    public init(order: Int32 = 0, address: Address? = nil) {
        self.order = order
        self.address = address
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}
extension AddressEntry.Direct {
    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset? = nil) {
        guard let reader = reader as? T else {
            return nil
        }
        self._reader = reader
        if let myOffset = myOffset {
            self._myOffset = myOffset
        } else {
            if let rootOffset = reader.rootObjectOffset {
                self._myOffset = rootOffset
            } else {
                return nil
            }
        }
    }
    public var hashValue: Int { return Int(_myOffset) }
    public static func ==<T>(t1 : AddressEntry.Direct<T>, t2 : AddressEntry.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var order: Int32 {
        
        return _reader.get(objectOffset: _myOffset, propertyIndex: 0, defaultValue: 0)
    }
    public var address: Address.Direct<T>? {
        
        return Address.Direct.from(reader: _reader, propertyIndex : 1, objectOffset : _myOffset)
    }
}
extension AddressEntry {

    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> AddressEntry? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? AddressEntry {
            return o
        }
        return AddressEntry(
            order: selfReader.order,
            address: Address.from(selfReader: selfReader.address)
        )
    }
}
extension FlatBuffersBuilder {
    public func insertAddressEntry(order: Int32 = 0, address_type: Int8 = 0, address: Offset? = nil) throws -> Offset {
        try self.startObject(withPropertyCount: 3)
        try self.insert(value: address_type, defaultValue: 0, toStartedObjectAt: 1)
        try self.insert(value: order, defaultValue: 0, toStartedObjectAt: 0)
        if let address = address {
            try self.insert(offset: address, toStartedObjectAt: 2)
        }
        return try self.endObject()
    }
}
extension AddressEntry {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }
        let address = try self.address?.insert(builder)
        let address_type = self.address?.unionCase ?? 0
        return try builder.insertAddressEntry(
            order: order,
            address_type: address_type,
            address: address
        )
    }

}
public enum Address {
    case withPostalAddress(PostalAddress), withEmailAddress(EmailAddress), withWebAddress(WebAddress), withTelephoneNumber(TelephoneNumber)
    fileprivate static func from(selfReader: Address.Direct<FlatBuffersMemoryReader>?) -> Address? {
        guard let selfReader = selfReader else {
            return nil
        }
        switch selfReader {
        case .withPostalAddress(let o):
            guard let o1 = PostalAddress.from(selfReader: o) else {
                return nil
            }
            return .withPostalAddress(o1)
        case .withEmailAddress(let o):
            guard let o1 = EmailAddress.from(selfReader: o) else {
                return nil
            }
            return .withEmailAddress(o1)
        case .withWebAddress(let o):
            guard let o1 = WebAddress.from(selfReader: o) else {
                return nil
            }
            return .withWebAddress(o1)
        case .withTelephoneNumber(let o):
            guard let o1 = TelephoneNumber.from(selfReader: o) else {
                return nil
            }
            return .withTelephoneNumber(o1)
        }
    }
    public enum Direct<R : FlatBuffersReader> {
        case withPostalAddress(PostalAddress.Direct<R>), withEmailAddress(EmailAddress.Direct<R>), withWebAddress(WebAddress.Direct<R>), withTelephoneNumber(TelephoneNumber.Direct<R>)
        fileprivate static func from(reader: R, propertyIndex : Int, objectOffset : Offset?) -> Address.Direct<R>? {
            guard let objectOffset = objectOffset else {
                return nil
            }
            let unionCase : Int8 = reader.get(objectOffset: objectOffset, propertyIndex: propertyIndex, defaultValue: 0)
            guard let caseObjectOffset : Offset = reader.offset(objectOffset: objectOffset, propertyIndex:propertyIndex + 1) else {
                return nil
            }
            switch unionCase {
            case 1:
                guard let o = PostalAddress.Direct<R>(reader: reader, myOffset: caseObjectOffset) else {
                    return nil
            }
            return Address.Direct.withPostalAddress(o)
            case 2:
                guard let o = EmailAddress.Direct<R>(reader: reader, myOffset: caseObjectOffset) else {
                    return nil
            }
            return Address.Direct.withEmailAddress(o)
            case 3:
                guard let o = WebAddress.Direct<R>(reader: reader, myOffset: caseObjectOffset) else {
                    return nil
            }
            return Address.Direct.withWebAddress(o)
            case 4:
                guard let o = TelephoneNumber.Direct<R>(reader: reader, myOffset: caseObjectOffset) else {
                    return nil
            }
            return Address.Direct.withTelephoneNumber(o)
            default:
                break
            }
            return nil
        }
        var asPostalAddress: PostalAddress.Direct<R>? {
            switch self {
            case .withPostalAddress(let v):
                return v
            default:
                return nil
            }
        }
        var asEmailAddress: EmailAddress.Direct<R>? {
            switch self {
            case .withEmailAddress(let v):
                return v
            default:
                return nil
            }
        }
        var asWebAddress: WebAddress.Direct<R>? {
            switch self {
            case .withWebAddress(let v):
                return v
            default:
                return nil
            }
        }
        var asTelephoneNumber: TelephoneNumber.Direct<R>? {
            switch self {
            case .withTelephoneNumber(let v):
                return v
            default:
                return nil
            }
        }
    }
    var unionCase: Int8 {
        switch self {
          case .withPostalAddress(_): return 1
          case .withEmailAddress(_): return 2
          case .withWebAddress(_): return 3
          case .withTelephoneNumber(_): return 4
        }
    }
    func insert(_ builder: FlatBuffersBuilder) throws -> Offset {
        switch self {
          case .withPostalAddress(let o): return try o.insert(builder)
          case .withEmailAddress(let o): return try o.insert(builder)
          case .withWebAddress(let o): return try o.insert(builder)
          case .withTelephoneNumber(let o): return try o.insert(builder)
        }
    }
    var asPostalAddress: PostalAddress? {
        switch self {
        case .withPostalAddress(let v):
            return v
        default:
            return nil
        }
    }
    var asEmailAddress: EmailAddress? {
        switch self {
        case .withEmailAddress(let v):
            return v
        default:
            return nil
        }
    }
    var asWebAddress: WebAddress? {
        switch self {
        case .withWebAddress(let v):
            return v
        default:
            return nil
        }
    }
    var asTelephoneNumber: TelephoneNumber? {
        switch self {
        case .withTelephoneNumber(let v):
            return v
        default:
            return nil
        }
    }
}
public final class PostalAddress {
    public var country: String?
    public var city: String?
    public var postalCode: Int32
    public var streetAndNumber: String?
    public init(country: String? = nil, city: String? = nil, postalCode: Int32 = 0, streetAndNumber: String? = nil) {
        self.country = country
        self.city = city
        self.postalCode = postalCode
        self.streetAndNumber = streetAndNumber
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}
extension PostalAddress.Direct {
    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset? = nil) {
        guard let reader = reader as? T else {
            return nil
        }
        self._reader = reader
        if let myOffset = myOffset {
            self._myOffset = myOffset
        } else {
            if let rootOffset = reader.rootObjectOffset {
                self._myOffset = rootOffset
            } else {
                return nil
            }
        }
    }
    public var hashValue: Int { return Int(_myOffset) }
    public static func ==<T>(t1 : PostalAddress.Direct<T>, t2 : PostalAddress.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var country: UnsafeBufferPointer<UInt8>? {
        guard let offset = _reader.offset(objectOffset: _myOffset, propertyIndex:0) else {return nil}
        return _reader.stringBuffer(stringOffset: offset)
    }
    public var city: UnsafeBufferPointer<UInt8>? {
        guard let offset = _reader.offset(objectOffset: _myOffset, propertyIndex:1) else {return nil}
        return _reader.stringBuffer(stringOffset: offset)
    }
    public var postalCode: Int32 {
        
        return _reader.get(objectOffset: _myOffset, propertyIndex: 2, defaultValue: 0)
    }
    public var streetAndNumber: UnsafeBufferPointer<UInt8>? {
        guard let offset = _reader.offset(objectOffset: _myOffset, propertyIndex:3) else {return nil}
        return _reader.stringBuffer(stringOffset: offset)
    }
}
extension PostalAddress {

    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> PostalAddress? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? PostalAddress {
            return o
        }
        return PostalAddress(
            country: selfReader.country§,
            city: selfReader.city§,
            postalCode: selfReader.postalCode,
            streetAndNumber: selfReader.streetAndNumber§
        )
    }
}
extension FlatBuffersBuilder {
    public func insertPostalAddress(country: Offset? = nil, city: Offset? = nil, postalCode: Int32 = 0, streetAndNumber: Offset? = nil) throws -> Offset {
        try self.startObject(withPropertyCount: 4)
        if let country = country {
            try self.insert(offset: country, toStartedObjectAt: 0)
        }
        if let city = city {
            try self.insert(offset: city, toStartedObjectAt: 1)
        }
        try self.insert(value: postalCode, defaultValue: 0, toStartedObjectAt: 2)
        if let streetAndNumber = streetAndNumber {
            try self.insert(offset: streetAndNumber, toStartedObjectAt: 3)
        }
        return try self.endObject()
    }
}
extension PostalAddress {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }
        let country = self.country == nil ? nil : try builder.insert(value: self.country)
        let city = self.city == nil ? nil : try builder.insert(value: self.city)
        let streetAndNumber = self.streetAndNumber == nil ? nil : try builder.insert(value: self.streetAndNumber)
        return try builder.insertPostalAddress(
            country: country,
            city: city,
            postalCode: postalCode,
            streetAndNumber: streetAndNumber
        )
    }

}
public final class EmailAddress {
    public var mailto: String?
    public init(mailto: String? = nil) {
        self.mailto = mailto
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}
extension EmailAddress.Direct {
    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset? = nil) {
        guard let reader = reader as? T else {
            return nil
        }
        self._reader = reader
        if let myOffset = myOffset {
            self._myOffset = myOffset
        } else {
            if let rootOffset = reader.rootObjectOffset {
                self._myOffset = rootOffset
            } else {
                return nil
            }
        }
    }
    public var hashValue: Int { return Int(_myOffset) }
    public static func ==<T>(t1 : EmailAddress.Direct<T>, t2 : EmailAddress.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var mailto: UnsafeBufferPointer<UInt8>? {
        guard let offset = _reader.offset(objectOffset: _myOffset, propertyIndex:0) else {return nil}
        return _reader.stringBuffer(stringOffset: offset)
    }
}
extension EmailAddress {

    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> EmailAddress? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? EmailAddress {
            return o
        }
        return EmailAddress(
            mailto: selfReader.mailto§
        )
    }
}
extension FlatBuffersBuilder {
    public func insertEmailAddress(mailto: Offset? = nil) throws -> Offset {
        try self.startObject(withPropertyCount: 1)
        if let mailto = mailto {
            try self.insert(offset: mailto, toStartedObjectAt: 0)
        }
        return try self.endObject()
    }
}
extension EmailAddress {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }
        let mailto = self.mailto == nil ? nil : try builder.insert(value: self.mailto)
        return try builder.insertEmailAddress(
            mailto: mailto
        )
    }

}
public final class WebAddress {
    public var url: String?
    public init(url: String? = nil) {
        self.url = url
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}
extension WebAddress.Direct {
    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset? = nil) {
        guard let reader = reader as? T else {
            return nil
        }
        self._reader = reader
        if let myOffset = myOffset {
            self._myOffset = myOffset
        } else {
            if let rootOffset = reader.rootObjectOffset {
                self._myOffset = rootOffset
            } else {
                return nil
            }
        }
    }
    public var hashValue: Int { return Int(_myOffset) }
    public static func ==<T>(t1 : WebAddress.Direct<T>, t2 : WebAddress.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var url: UnsafeBufferPointer<UInt8>? {
        guard let offset = _reader.offset(objectOffset: _myOffset, propertyIndex:0) else {return nil}
        return _reader.stringBuffer(stringOffset: offset)
    }
}
extension WebAddress {

    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> WebAddress? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? WebAddress {
            return o
        }
        return WebAddress(
            url: selfReader.url§
        )
    }
}
extension FlatBuffersBuilder {
    public func insertWebAddress(url: Offset? = nil) throws -> Offset {
        try self.startObject(withPropertyCount: 1)
        if let url = url {
            try self.insert(offset: url, toStartedObjectAt: 0)
        }
        return try self.endObject()
    }
}
extension WebAddress {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }
        let url = self.url == nil ? nil : try builder.insert(value: self.url)
        return try builder.insertWebAddress(
            url: url
        )
    }

}
public final class TelephoneNumber {
    public var number: String?
    public init(number: String? = nil) {
        self.number = number
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}
extension TelephoneNumber.Direct {
    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset? = nil) {
        guard let reader = reader as? T else {
            return nil
        }
        self._reader = reader
        if let myOffset = myOffset {
            self._myOffset = myOffset
        } else {
            if let rootOffset = reader.rootObjectOffset {
                self._myOffset = rootOffset
            } else {
                return nil
            }
        }
    }
    public var hashValue: Int { return Int(_myOffset) }
    public static func ==<T>(t1 : TelephoneNumber.Direct<T>, t2 : TelephoneNumber.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var number: UnsafeBufferPointer<UInt8>? {
        guard let offset = _reader.offset(objectOffset: _myOffset, propertyIndex:0) else {return nil}
        return _reader.stringBuffer(stringOffset: offset)
    }
}
extension TelephoneNumber {

    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> TelephoneNumber? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? TelephoneNumber {
            return o
        }
        return TelephoneNumber(
            number: selfReader.number§
        )
    }
}
extension FlatBuffersBuilder {
    public func insertTelephoneNumber(number: Offset? = nil) throws -> Offset {
        try self.startObject(withPropertyCount: 1)
        if let number = number {
            try self.insert(offset: number, toStartedObjectAt: 0)
        }
        return try self.endObject()
    }
}
extension TelephoneNumber {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }
        let number = self.number == nil ? nil : try builder.insert(value: self.number)
        return try builder.insertTelephoneNumber(
            number: number
        )
    }

}
public struct GeoLocation: Scalar {
    public let latitude: Float64
    public let longitude: Float64
    public let elevation: Float32
    public static func ==(v1:GeoLocation, v2:GeoLocation) -> Bool {
        return v1.latitude==v2.latitude && v1.longitude==v2.longitude && v1.elevation==v2.elevation
    }
}
public enum Mood: Int8, FlatBuffersEnum {
    case Funny, Serious, Angry, Humble
    public static func fromScalar<T>(_ scalar: T) -> Mood? where T : Scalar {
        guard let value = scalar as? RawValue else {
            return nil
        }
        return Mood(rawValue: value)
    }
}
