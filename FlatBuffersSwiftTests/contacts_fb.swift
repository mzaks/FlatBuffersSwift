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
        let o = ContactList()
        selfReader._reader.cache?.objectPool[selfReader._myOffset] = o
        o.lastModified = selfReader.lastModified
        o.entries = selfReader.entries.compactMap{ Contact.from(selfReader:$0) }

        return o
    }
}
extension FlatBuffersBuilder {
    public func insertContactList(lastModified: Int64 = 0, entries: Offset? = nil) throws -> (Offset, [Int?]) {
        var valueCursors = [Int?](repeating: nil, count: 2)
        try self.startObject(withPropertyCount: 2)
        if let entries = entries {
            valueCursors[1] = try self.insert(offset: entries, toStartedObjectAt: 1)
        }
        valueCursors[0] = try self.insert(value: lastModified, defaultValue: 0, toStartedObjectAt: 0)
        return try (self.endObject(), valueCursors)
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
            let offsets = try self.entries.reversed().map{ try $0.insert(builder) }
            try builder.startVector(count: self.entries.count, elementSize: MemoryLayout<Offset>.stride)
            for (_, o) in offsets.enumerated() {
                try builder.insert(offset: o)
            }
            entries = builder.endVector()
        }
        let (myOffset, _) = try builder.insertContactList(
            lastModified: lastModified,
            entries: entries
        )

        if builder.options.uniqueTables {
            builder.cache[ObjectIdentifier(self)] = myOffset
        }

        return myOffset
    }
    public func makeData(withOptions options : FlatBuffersBuilderOptions = FlatBuffersBuilderOptions()) throws -> Data {
        let builder = FlatBuffersBuilder(options: options)
        let offset = try insert(builder)
        try builder.finish(offset: offset, fileIdentifier: nil)
        
        return builder.makeData
    }
}
extension ContactList {
    public static func from(jsonObject: [String: Any]?) -> ContactList? {
        guard let object = jsonObject else { return nil }
        let lastModified = (object["lastModified"] as? Int).flatMap { Int64(exactly: $0) } ?? 0
        let entries = ((object["entries"] as? [[String: Any]]) ?? []).compactMap { Contact.from(jsonObject: $0)}
        return ContactList (
            lastModified: lastModified,
            entries: entries
        )
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
    public init(name: String? = nil, birthday: Date? = nil, gender: Gender? = Gender.Male, tags: [String] = [], addressEntries: [AddressEntry] = [], currentLoccation: GeoLocation? = nil, previousLocations: [GeoLocation] = [], moods: [Mood] = [], luckyNumbers: [Int32] = []) {
        self.name = name
        self.birthday = birthday
        self.gender = gender
        self.tags = tags
        self.addressEntries = addressEntries
        self.currentLoccation = currentLoccation
        self.previousLocations = previousLocations
        self.moods = moods
        self.luckyNumbers = luckyNumbers
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
}
extension Contact {

    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> Contact? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? Contact {
            return o
        }
        let o = Contact()
        selfReader._reader.cache?.objectPool[selfReader._myOffset] = o
        o.name = selfReader.name§
        o.birthday = Date.from(selfReader:selfReader.birthday)
        o.gender = selfReader.gender
        o.tags = selfReader.tags.compactMap{ $0§ }
        o.addressEntries = selfReader.addressEntries.compactMap{ AddressEntry.from(selfReader:$0) }
        o.currentLoccation = selfReader.currentLoccation
        o.previousLocations = selfReader.previousLocations.compactMap{$0}
        o.moods = selfReader.moods.compactMap{$0}
        o.luckyNumbers = selfReader.luckyNumbers.compactMap{$0}

        return o
    }
}
extension FlatBuffersBuilder {
    public func insertContact(name: Offset? = nil, birthday: Offset? = nil, gender: Gender = Gender.Male, tags: Offset? = nil, addressEntries: Offset? = nil, currentLoccation: GeoLocation? = nil, previousLocations: Offset? = nil, moods: Offset? = nil, luckyNumbers: Offset? = nil) throws -> (Offset, [Int?]) {
        var valueCursors = [Int?](repeating: nil, count: 9)
        try self.startObject(withPropertyCount: 9)
        valueCursors[2] = try self.insert(value: gender.rawValue, defaultValue: Gender.Male.rawValue, toStartedObjectAt: 2)
        if let name = name {
            valueCursors[0] = try self.insert(offset: name, toStartedObjectAt: 0)
        }
        if let birthday = birthday {
            valueCursors[1] = try self.insert(offset: birthday, toStartedObjectAt: 1)
        }
        if let tags = tags {
            valueCursors[3] = try self.insert(offset: tags, toStartedObjectAt: 3)
        }
        if let addressEntries = addressEntries {
            valueCursors[4] = try self.insert(offset: addressEntries, toStartedObjectAt: 4)
        }
        if let previousLocations = previousLocations {
            valueCursors[6] = try self.insert(offset: previousLocations, toStartedObjectAt: 6)
        }
        if let moods = moods {
            valueCursors[7] = try self.insert(offset: moods, toStartedObjectAt: 7)
        }
        if let luckyNumbers = luckyNumbers {
            valueCursors[8] = try self.insert(offset: luckyNumbers, toStartedObjectAt: 8)
        }
        if let currentLoccation = currentLoccation {
            self.insert(value: currentLoccation)
            valueCursors[5] = try self.insertCurrentOffsetAsProperty(toStartedObjectAt: 5)
        }
        return try (self.endObject(), valueCursors)
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
            let offsets = try self.tags.reversed().map{ try builder.insert(value: $0) }
            try builder.startVector(count: self.tags.count, elementSize: MemoryLayout<Offset>.stride)
            for (_, o) in offsets.enumerated() {
                try builder.insert(offset: o)
            }
            tags = builder.endVector()
        }
        let addressEntries: Offset?
        if self.addressEntries.isEmpty {
            addressEntries = nil
        } else {
            let offsets = try self.addressEntries.reversed().map{ try $0.insert(builder) }
            try builder.startVector(count: self.addressEntries.count, elementSize: MemoryLayout<Offset>.stride)
            for (_, o) in offsets.enumerated() {
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
        let (myOffset, _) = try builder.insertContact(
            name: name,
            birthday: birthday,
            gender: gender ?? Gender.Male,
            tags: tags,
            addressEntries: addressEntries,
            currentLoccation: currentLoccation,
            previousLocations: previousLocations,
            moods: moods,
            luckyNumbers: luckyNumbers
        )

        if builder.options.uniqueTables {
            builder.cache[ObjectIdentifier(self)] = myOffset
        }

        return myOffset
    }

}
extension Contact {
    public static func from(jsonObject: [String: Any]?) -> Contact? {
        guard let object = jsonObject else { return nil }
        let name = object["name"] as? String
        let birthday = Date.from(jsonObject: object["birthday"] as? [String: Any])
        let gender = Gender.from(jsonValue: object["gender"])
        let tags = object["tags"] as? [String] ?? []
        let addressEntries = ((object["addressEntries"] as? [[String: Any]]) ?? []).compactMap { AddressEntry.from(jsonObject: $0)}
        let currentLoccation = GeoLocation.from(jsonObject: object["currentLoccation"] as? [String: Any])
        let previousLocations = ((object["previousLocations"] as? [[String: Any]]) ?? []).compactMap { GeoLocation.from(jsonObject: $0)}
        let moods = ((object["moods"] as? [Any]) ?? []).compactMap { Mood.from(jsonValue: $0)}
        let luckyNumbers = (object["luckyNumbers"] as? [Int] ?? []).compactMap { Int32(exactly: $0) }
        return Contact (
            name: name,
            birthday: birthday,
            gender: gender,
            tags: tags,
            addressEntries: addressEntries,
            currentLoccation: currentLoccation,
            previousLocations: previousLocations,
            moods: moods,
            luckyNumbers: luckyNumbers
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
        let o = Date()
        selfReader._reader.cache?.objectPool[selfReader._myOffset] = o
        o.day = selfReader.day
        o.month = selfReader.month
        o.year = selfReader.year

        return o
    }
}
extension FlatBuffersBuilder {
    public func insertDate(day: Int8 = 0, month: Int8 = 0, year: Int16 = 0) throws -> (Offset, [Int?]) {
        var valueCursors = [Int?](repeating: nil, count: 3)
        try self.startObject(withPropertyCount: 3)
        valueCursors[0] = try self.insert(value: day, defaultValue: 0, toStartedObjectAt: 0)
        valueCursors[1] = try self.insert(value: month, defaultValue: 0, toStartedObjectAt: 1)
        valueCursors[2] = try self.insert(value: year, defaultValue: 0, toStartedObjectAt: 2)
        return try (self.endObject(), valueCursors)
    }
}
extension Date {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }


        let (myOffset, _) = try builder.insertDate(
            day: day,
            month: month,
            year: year
        )

        if builder.options.uniqueTables {
            builder.cache[ObjectIdentifier(self)] = myOffset
        }

        return myOffset
    }

}
extension Date {
    public static func from(jsonObject: [String: Any]?) -> Date? {
        guard let object = jsonObject else { return nil }
        let day = (object["day"] as? Int).flatMap { Int8(exactly: $0) } ?? 0
        let month = (object["month"] as? Int).flatMap { Int8(exactly: $0) } ?? 0
        let year = (object["year"] as? Int).flatMap { Int16(exactly: $0) } ?? 0
        return Date (
            day: day,
            month: month,
            year: year
        )
    }
}
public enum Gender: Int8, FlatBuffersEnum {
    case Male, Female
    public static func fromScalar<T>(_ scalar: T) -> Gender? where T : Scalar {
        guard let value = scalar as? RawValue else {
            return nil
        }
        return Gender(rawValue: value)
    }
}
extension Gender {
    static func from(jsonValue: Any?) -> Gender? {
        if let string = jsonValue as? String {
            if string == "Male" {
                return .Male
            }
            if string == "Female" {
                return .Female
            }
        }
        if let int = jsonValue as? Int,
            let rawValue = Int8(exactly: int) {
            return Gender.init(rawValue: rawValue)
        }
        return nil
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
        let o = AddressEntry()
        selfReader._reader.cache?.objectPool[selfReader._myOffset] = o
        o.order = selfReader.order
        o.address = Address.from(selfReader: selfReader.address)

        return o
    }
}
extension FlatBuffersBuilder {
    public func insertAddressEntry(order: Int32 = 0, address_type: Int8 = 0, address: Offset? = nil) throws -> (Offset, [Int?]) {
        var valueCursors = [Int?](repeating: nil, count: 3)
        try self.startObject(withPropertyCount: 3)
        valueCursors[1] = try self.insert(value: address_type, defaultValue: 0, toStartedObjectAt: 1)
        valueCursors[0] = try self.insert(value: order, defaultValue: 0, toStartedObjectAt: 0)
        if let address = address {
            valueCursors[2] = try self.insert(offset: address, toStartedObjectAt: 2)
        }
        return try (self.endObject(), valueCursors)
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
        let (myOffset, _) = try builder.insertAddressEntry(
            order: order,
            address_type: address_type,
            address: address
        )

        if builder.options.uniqueTables {
            builder.cache[ObjectIdentifier(self)] = myOffset
        }

        return myOffset
    }

}
extension AddressEntry {
    public static func from(jsonObject: [String: Any]?) -> AddressEntry? {
        guard let object = jsonObject else { return nil }
        let order = (object["order"] as? Int).flatMap { Int32(exactly: $0) } ?? 0
        let address = Address.from(type:object["address_type"] as? String, jsonObject: object["address"] as? [String: Any])
        return AddressEntry (
            order: order,
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
        public var asPostalAddress: PostalAddress.Direct<R>? {
            switch self {
            case .withPostalAddress(let v):
                return v
            default:
                return nil
            }
        }
        public var asEmailAddress: EmailAddress.Direct<R>? {
            switch self {
            case .withEmailAddress(let v):
                return v
            default:
                return nil
            }
        }
        public var asWebAddress: WebAddress.Direct<R>? {
            switch self {
            case .withWebAddress(let v):
                return v
            default:
                return nil
            }
        }
        public var asTelephoneNumber: TelephoneNumber.Direct<R>? {
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
    public var asPostalAddress: PostalAddress? {
        switch self {
        case .withPostalAddress(let v):
            return v
        default:
            return nil
        }
    }
    public var asEmailAddress: EmailAddress? {
        switch self {
        case .withEmailAddress(let v):
            return v
        default:
            return nil
        }
    }
    public var asWebAddress: WebAddress? {
        switch self {
        case .withWebAddress(let v):
            return v
        default:
            return nil
        }
    }
    public var asTelephoneNumber: TelephoneNumber? {
        switch self {
        case .withTelephoneNumber(let v):
            return v
        default:
            return nil
        }
    }
    public var value: AnyObject {
        switch self {
        case .withPostalAddress(let v): return v
        case .withEmailAddress(let v): return v
        case .withWebAddress(let v): return v
        case .withTelephoneNumber(let v): return v
        }
    }
}
extension Address {
    static func from(type: String?, jsonObject: [String: Any]?) -> Address? {
        guard let type = type, let object = jsonObject else { return nil }
        switch type {
        case "PostalAddress":
            guard let o = PostalAddress.from(jsonObject: object) else { return nil }
            return Address.withPostalAddress(o)
        case "EmailAddress":
            guard let o = EmailAddress.from(jsonObject: object) else { return nil }
            return Address.withEmailAddress(o)
        case "WebAddress":
            guard let o = WebAddress.from(jsonObject: object) else { return nil }
            return Address.withWebAddress(o)
        case "TelephoneNumber":
            guard let o = TelephoneNumber.from(jsonObject: object) else { return nil }
            return Address.withTelephoneNumber(o)
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
        let o = PostalAddress()
        selfReader._reader.cache?.objectPool[selfReader._myOffset] = o
        o.country = selfReader.country§
        o.city = selfReader.city§
        o.postalCode = selfReader.postalCode
        o.streetAndNumber = selfReader.streetAndNumber§

        return o
    }
}
extension FlatBuffersBuilder {
    public func insertPostalAddress(country: Offset? = nil, city: Offset? = nil, postalCode: Int32 = 0, streetAndNumber: Offset? = nil) throws -> (Offset, [Int?]) {
        var valueCursors = [Int?](repeating: nil, count: 4)
        try self.startObject(withPropertyCount: 4)
        if let country = country {
            valueCursors[0] = try self.insert(offset: country, toStartedObjectAt: 0)
        }
        if let city = city {
            valueCursors[1] = try self.insert(offset: city, toStartedObjectAt: 1)
        }
        valueCursors[2] = try self.insert(value: postalCode, defaultValue: 0, toStartedObjectAt: 2)
        if let streetAndNumber = streetAndNumber {
            valueCursors[3] = try self.insert(offset: streetAndNumber, toStartedObjectAt: 3)
        }
        return try (self.endObject(), valueCursors)
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
        let (myOffset, _) = try builder.insertPostalAddress(
            country: country,
            city: city,
            postalCode: postalCode,
            streetAndNumber: streetAndNumber
        )

        if builder.options.uniqueTables {
            builder.cache[ObjectIdentifier(self)] = myOffset
        }

        return myOffset
    }

}
extension PostalAddress {
    public static func from(jsonObject: [String: Any]?) -> PostalAddress? {
        guard let object = jsonObject else { return nil }
        let country = object["country"] as? String
        let city = object["city"] as? String
        let postalCode = (object["postalCode"] as? Int).flatMap { Int32(exactly: $0) } ?? 0
        let streetAndNumber = object["streetAndNumber"] as? String
        return PostalAddress (
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
        let o = EmailAddress()
        selfReader._reader.cache?.objectPool[selfReader._myOffset] = o
        o.mailto = selfReader.mailto§

        return o
    }
}
extension FlatBuffersBuilder {
    public func insertEmailAddress(mailto: Offset? = nil) throws -> (Offset, [Int?]) {
        var valueCursors = [Int?](repeating: nil, count: 1)
        try self.startObject(withPropertyCount: 1)
        if let mailto = mailto {
            valueCursors[0] = try self.insert(offset: mailto, toStartedObjectAt: 0)
        }
        return try (self.endObject(), valueCursors)
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
        let (myOffset, _) = try builder.insertEmailAddress(
            mailto: mailto
        )

        if builder.options.uniqueTables {
            builder.cache[ObjectIdentifier(self)] = myOffset
        }

        return myOffset
    }

}
extension EmailAddress {
    public static func from(jsonObject: [String: Any]?) -> EmailAddress? {
        guard let object = jsonObject else { return nil }
        let mailto = object["mailto"] as? String
        return EmailAddress (
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
        let o = WebAddress()
        selfReader._reader.cache?.objectPool[selfReader._myOffset] = o
        o.url = selfReader.url§

        return o
    }
}
extension FlatBuffersBuilder {
    public func insertWebAddress(url: Offset? = nil) throws -> (Offset, [Int?]) {
        var valueCursors = [Int?](repeating: nil, count: 1)
        try self.startObject(withPropertyCount: 1)
        if let url = url {
            valueCursors[0] = try self.insert(offset: url, toStartedObjectAt: 0)
        }
        return try (self.endObject(), valueCursors)
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
        let (myOffset, _) = try builder.insertWebAddress(
            url: url
        )

        if builder.options.uniqueTables {
            builder.cache[ObjectIdentifier(self)] = myOffset
        }

        return myOffset
    }

}
extension WebAddress {
    public static func from(jsonObject: [String: Any]?) -> WebAddress? {
        guard let object = jsonObject else { return nil }
        let url = object["url"] as? String
        return WebAddress (
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
        let o = TelephoneNumber()
        selfReader._reader.cache?.objectPool[selfReader._myOffset] = o
        o.number = selfReader.number§

        return o
    }
}
extension FlatBuffersBuilder {
    public func insertTelephoneNumber(number: Offset? = nil) throws -> (Offset, [Int?]) {
        var valueCursors = [Int?](repeating: nil, count: 1)
        try self.startObject(withPropertyCount: 1)
        if let number = number {
            valueCursors[0] = try self.insert(offset: number, toStartedObjectAt: 0)
        }
        return try (self.endObject(), valueCursors)
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
        let (myOffset, _) = try builder.insertTelephoneNumber(
            number: number
        )

        if builder.options.uniqueTables {
            builder.cache[ObjectIdentifier(self)] = myOffset
        }

        return myOffset
    }

}
extension TelephoneNumber {
    public static func from(jsonObject: [String: Any]?) -> TelephoneNumber? {
        guard let object = jsonObject else { return nil }
        let number = object["number"] as? String
        return TelephoneNumber (
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
extension GeoLocation {
    static func from(jsonObject: [String: Any]?) -> GeoLocation? {
        guard let object = jsonObject else { return nil }
       guard let latitude = object["latitude"] as? Double else { return nil }
       guard let longitude = object["longitude"] as? Double else { return nil }
       guard let elevationDouble = object["elevation"] as? Double, let elevation = Optional.some(Float32(elevationDouble)) else { return nil }
        return GeoLocation(
            latitude: latitude,
            longitude: longitude,
            elevation: elevation
        )
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
extension Mood {
    static func from(jsonValue: Any?) -> Mood? {
        if let string = jsonValue as? String {
            if string == "Funny" {
                return .Funny
            }
            if string == "Serious" {
                return .Serious
            }
            if string == "Angry" {
                return .Angry
            }
            if string == "Humble" {
                return .Humble
            }
        }
        if let int = jsonValue as? Int,
            let rawValue = Int8(exactly: int) {
            return Mood.init(rawValue: rawValue)
        }
        return nil
    }
}
