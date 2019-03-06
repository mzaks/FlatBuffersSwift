import Foundation
import FlatBuffersSwift

public final class PeopleList {
    public var people: [Friend]
    public init(people: [Friend] = []) {
        self.people = people
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}
extension PeopleList.Direct {
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
    public static func ==<T>(t1 : PeopleList.Direct<T>, t2 : PeopleList.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var people: FlatBuffersTableVector<Friend.Direct<T>, T> {

        return FlatBuffersTableVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:0))
    }
}
extension PeopleList {
    public static func from(data: Data) -> PeopleList? {
        let reader = FlatBuffersMemoryReader(data: data, withoutCopy: false)
        return PeopleList.from(selfReader: Direct<FlatBuffersMemoryReader>(reader: reader))
    }
    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> PeopleList? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? PeopleList {
            return o
        }
        let o = PeopleList()
        selfReader._reader.cache?.objectPool[selfReader._myOffset] = o
        o.people = selfReader.people.compactMap{ Friend.from(selfReader:$0) }

        return o
    }
}
extension FlatBuffersBuilder {
    public func insertPeopleList(people: Offset? = nil) throws -> (Offset, [Int?]) {
        var valueCursors = [Int?](repeating: nil, count: 1)
        try self.startObject(withPropertyCount: 1)
        if let people = people {
            valueCursors[0] = try self.insert(offset: people, toStartedObjectAt: 0)
        }
        return try (self.endObject(), valueCursors)
    }
}
extension PeopleList {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }
        if builder.inProgress.contains(ObjectIdentifier(self)){
            return 0
        }
        builder.inProgress.insert(ObjectIdentifier(self))
        let people: Offset?
        if self.people.isEmpty {
            people = nil
        } else {
            let offsets = try self.people.reversed().map{ try $0.insert(builder) }
            try builder.startVector(count: self.people.count, elementSize: MemoryLayout<Offset>.stride)
            for (index, o) in offsets.enumerated() {
                let cursor = try builder.insert(offset: o)
                if o == 0 {
                    builder.deferedBindings.append((object: self.people.reversed()[index], cursor: cursor))
                }
            }
            people = builder.endVector()
        }
        let (myOffset, _) = try builder.insertPeopleList(
            people: people
        )

        if builder.options.uniqueTables {
            builder.cache[ObjectIdentifier(self)] = myOffset
        }
        builder.inProgress.remove(ObjectIdentifier(self))
        return myOffset
    }
    public func makeData(withOptions options : FlatBuffersBuilderOptions = FlatBuffersBuilderOptions()) throws -> Data {
        let builder = FlatBuffersBuilder(options: options)
        let offset = try insert(builder)
        try builder.finish(offset: offset, fileIdentifier: "TEST")
        try performLateBindings(builder)
        return builder.makeData
    }
}
extension PeopleList {
    public static func from(jsonObject: [String: Any]?) -> PeopleList? {
        guard let object = jsonObject else { return nil }
        let people = ((object["people"] as? [[String: Any]]) ?? []).compactMap { Friend.from(jsonObject: $0)}
        return PeopleList (
            people: people
        )
    }
}
public final class Friend {
    public var name: String?
    public var friends: [Friend]
    public var father: Friend?
    public var mother: Friend?
    public var lover: Human?
    public init(name: String? = nil, friends: [Friend] = [], father: Friend? = nil, mother: Friend? = nil, lover: Human? = nil) {
        self.name = name
        self.friends = friends
        self.father = father
        self.mother = mother
        self.lover = lover
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}
extension Friend.Direct {
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
    public static func ==<T>(t1 : Friend.Direct<T>, t2 : Friend.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var name: UnsafeBufferPointer<UInt8>? {
        guard let offset = _reader.offset(objectOffset: _myOffset, propertyIndex:0) else {return nil}
        return _reader.stringBuffer(stringOffset: offset)
    }
    public var friends: FlatBuffersTableVector<Friend.Direct<T>, T> {

        return FlatBuffersTableVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:1))
    }
    public var father: Friend.Direct<T>? {
        guard let offset = _reader.offset(objectOffset: _myOffset, propertyIndex:2) else {return nil}
        return Friend.Direct(reader: _reader, myOffset: offset)
    }
    public var mother: Friend.Direct<T>? {
        guard let offset = _reader.offset(objectOffset: _myOffset, propertyIndex:3) else {return nil}
        return Friend.Direct(reader: _reader, myOffset: offset)
    }
    public var lover: Human.Direct<T>? {

        return Human.Direct.from(reader: _reader, propertyIndex : 4, objectOffset : _myOffset)
    }
}
extension Friend {

    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> Friend? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? Friend {
            return o
        }
        let o = Friend()
        selfReader._reader.cache?.objectPool[selfReader._myOffset] = o
        o.name = selfReader.name§
        o.friends = selfReader.friends.compactMap{ Friend.from(selfReader:$0) }
        o.father = Friend.from(selfReader:selfReader.father)
        o.mother = Friend.from(selfReader:selfReader.mother)
        o.lover = Human.from(selfReader: selfReader.lover)

        return o
    }
}
extension FlatBuffersBuilder {
    public func insertFriend(name: Offset? = nil, friends: Offset? = nil, father: Offset? = nil, mother: Offset? = nil, lover_type: Int8 = 0, lover: Offset? = nil) throws -> (Offset, [Int?]) {
        var valueCursors = [Int?](repeating: nil, count: 6)
        try self.startObject(withPropertyCount: 6)
        valueCursors[4] = try self.insert(value: lover_type, defaultValue: 0, toStartedObjectAt: 4)
        if let name = name {
            valueCursors[0] = try self.insert(offset: name, toStartedObjectAt: 0)
        }
        if let friends = friends {
            valueCursors[1] = try self.insert(offset: friends, toStartedObjectAt: 1)
        }
        if let father = father {
            valueCursors[2] = try self.insert(offset: father, toStartedObjectAt: 2)
        }
        if let mother = mother {
            valueCursors[3] = try self.insert(offset: mother, toStartedObjectAt: 3)
        }
        if let lover = lover {
            valueCursors[5] = try self.insert(offset: lover, toStartedObjectAt: 5)
        }
        return try (self.endObject(), valueCursors)
    }
}
extension Friend {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }
        if builder.inProgress.contains(ObjectIdentifier(self)){
            return 0
        }
        builder.inProgress.insert(ObjectIdentifier(self))
        let name = self.name == nil ? nil : try builder.insert(value: self.name)
        let friends: Offset?
        if self.friends.isEmpty {
            friends = nil
        } else {
            let offsets = try self.friends.reversed().map{ try $0.insert(builder) }
            try builder.startVector(count: self.friends.count, elementSize: MemoryLayout<Offset>.stride)
            for (index, o) in offsets.enumerated() {
                let cursor = try builder.insert(offset: o)
                if o == 0 {
                    builder.deferedBindings.append((object: self.friends.reversed()[index], cursor: cursor))
                }
            }
            friends = builder.endVector()
        }
        let father = try self.father?.insert(builder)
        let mother = try self.mother?.insert(builder)
        let lover = try self.lover?.insert(builder)
        let lover_type = self.lover?.unionCase ?? 0
        let (myOffset, valueCursors) = try builder.insertFriend(
            name: name,
            friends: friends,
            father: father,
            mother: mother,
            lover_type: lover_type,
            lover: lover
        )
        if father == 0,
           let o = self.father,
           let cursor = valueCursors[2] {
            builder.deferedBindings.append((o, cursor))
        }
        if mother == 0,
           let o = self.mother,
           let cursor = valueCursors[3] {
            builder.deferedBindings.append((o, cursor))
        }
        if lover == 0,
           let o = self.lover,
           let cursor = valueCursors[5] {
            builder.deferedBindings.append((o.value, cursor))
        }
        if builder.options.uniqueTables {
            builder.cache[ObjectIdentifier(self)] = myOffset
        }
        builder.inProgress.remove(ObjectIdentifier(self))
        return myOffset
    }

}
extension Friend {
    public static func from(jsonObject: [String: Any]?) -> Friend? {
        guard let object = jsonObject else { return nil }
        let name = object["name"] as? String
        let friends = ((object["friends"] as? [[String: Any]]) ?? []).compactMap { Friend.from(jsonObject: $0)}
        let father = Friend.from(jsonObject: object["father"] as? [String: Any])
        let mother = Friend.from(jsonObject: object["mother"] as? [String: Any])
        let lover = Human.from(type:object["lover_type"] as? String, jsonObject: object["lover"] as? [String: Any])
        return Friend (
            name: name,
            friends: friends,
            father: father,
            mother: mother,
            lover: lover
        )
    }
}
public enum Human {
    case withMale(Male), withFemale(Female)
    fileprivate static func from(selfReader: Human.Direct<FlatBuffersMemoryReader>?) -> Human? {
        guard let selfReader = selfReader else {
            return nil
        }
        switch selfReader {
        case .withMale(let o):
            guard let o1 = Male.from(selfReader: o) else {
                return nil
            }
            return .withMale(o1)
        case .withFemale(let o):
            guard let o1 = Female.from(selfReader: o) else {
                return nil
            }
            return .withFemale(o1)
        }
    }
    public enum Direct<R : FlatBuffersReader> {
        case withMale(Male.Direct<R>), withFemale(Female.Direct<R>)
        fileprivate static func from(reader: R, propertyIndex : Int, objectOffset : Offset?) -> Human.Direct<R>? {
            guard let objectOffset = objectOffset else {
                return nil
            }
            let unionCase : Int8 = reader.get(objectOffset: objectOffset, propertyIndex: propertyIndex, defaultValue: 0)
            guard let caseObjectOffset : Offset = reader.offset(objectOffset: objectOffset, propertyIndex:propertyIndex + 1) else {
                return nil
            }
            switch unionCase {
            case 1:
                guard let o = Male.Direct<R>(reader: reader, myOffset: caseObjectOffset) else {
                    return nil
            }
            return Human.Direct.withMale(o)
            case 2:
                guard let o = Female.Direct<R>(reader: reader, myOffset: caseObjectOffset) else {
                    return nil
            }
            return Human.Direct.withFemale(o)
            default:
                break
            }
            return nil
        }
        public var asMale: Male.Direct<R>? {
            switch self {
            case .withMale(let v):
                return v
            default:
                return nil
            }
        }
        public var asFemale: Female.Direct<R>? {
            switch self {
            case .withFemale(let v):
                return v
            default:
                return nil
            }
        }
    }
    var unionCase: Int8 {
        switch self {
          case .withMale(_): return 1
          case .withFemale(_): return 2
        }
    }
    func insert(_ builder: FlatBuffersBuilder) throws -> Offset {
        switch self {
          case .withMale(let o): return try o.insert(builder)
          case .withFemale(let o): return try o.insert(builder)
        }
    }
    public var asMale: Male? {
        switch self {
        case .withMale(let v):
            return v
        default:
            return nil
        }
    }
    public var asFemale: Female? {
        switch self {
        case .withFemale(let v):
            return v
        default:
            return nil
        }
    }
    public var value: AnyObject {
        switch self {
        case .withMale(let v): return v
        case .withFemale(let v): return v
        }
    }
}
extension Human {
    static func from(type: String?, jsonObject: [String: Any]?) -> Human? {
        guard let type = type, let object = jsonObject else { return nil }
        switch type {
        case "Male":
            guard let o = Male.from(jsonObject: object) else { return nil }
            return Human.withMale(o)
        case "Female":
            guard let o = Female.from(jsonObject: object) else { return nil }
            return Human.withFemale(o)
        default:
            return nil
        }
    }
}
public final class Male {
    public var ref: Friend?
    public init(ref: Friend? = nil) {
        self.ref = ref
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}
extension Male.Direct {
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
    public static func ==<T>(t1 : Male.Direct<T>, t2 : Male.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var ref: Friend.Direct<T>? {
        guard let offset = _reader.offset(objectOffset: _myOffset, propertyIndex:0) else {return nil}
        return Friend.Direct(reader: _reader, myOffset: offset)
    }
}
extension Male {

    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> Male? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? Male {
            return o
        }
        let o = Male()
        selfReader._reader.cache?.objectPool[selfReader._myOffset] = o
        o.ref = Friend.from(selfReader:selfReader.ref)

        return o
    }
}
extension FlatBuffersBuilder {
    public func insertMale(ref: Offset? = nil) throws -> (Offset, [Int?]) {
        var valueCursors = [Int?](repeating: nil, count: 1)
        try self.startObject(withPropertyCount: 1)
        if let ref = ref {
            valueCursors[0] = try self.insert(offset: ref, toStartedObjectAt: 0)
        }
        return try (self.endObject(), valueCursors)
    }
}
extension Male {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }
        if builder.inProgress.contains(ObjectIdentifier(self)){
            return 0
        }
        builder.inProgress.insert(ObjectIdentifier(self))
        let ref = try self.ref?.insert(builder)
        let (myOffset, valueCursors) = try builder.insertMale(
            ref: ref
        )
        if ref == 0,
           let o = self.ref,
           let cursor = valueCursors[0] {
            builder.deferedBindings.append((o, cursor))
        }
        if builder.options.uniqueTables {
            builder.cache[ObjectIdentifier(self)] = myOffset
        }
        builder.inProgress.remove(ObjectIdentifier(self))
        return myOffset
    }

}
extension Male {
    public static func from(jsonObject: [String: Any]?) -> Male? {
        guard let object = jsonObject else { return nil }
        let ref = Friend.from(jsonObject: object["ref"] as? [String: Any])
        return Male (
            ref: ref
        )
    }
}
public final class Female {
    public var ref: Friend?
    public init(ref: Friend? = nil) {
        self.ref = ref
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}
extension Female.Direct {
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
    public static func ==<T>(t1 : Female.Direct<T>, t2 : Female.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var ref: Friend.Direct<T>? {
        guard let offset = _reader.offset(objectOffset: _myOffset, propertyIndex:0) else {return nil}
        return Friend.Direct(reader: _reader, myOffset: offset)
    }
}
extension Female {

    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> Female? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? Female {
            return o
        }
        let o = Female()
        selfReader._reader.cache?.objectPool[selfReader._myOffset] = o
        o.ref = Friend.from(selfReader:selfReader.ref)

        return o
    }
}
extension FlatBuffersBuilder {
    public func insertFemale(ref: Offset? = nil) throws -> (Offset, [Int?]) {
        var valueCursors = [Int?](repeating: nil, count: 1)
        try self.startObject(withPropertyCount: 1)
        if let ref = ref {
            valueCursors[0] = try self.insert(offset: ref, toStartedObjectAt: 0)
        }
        return try (self.endObject(), valueCursors)
    }
}
extension Female {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }
        if builder.inProgress.contains(ObjectIdentifier(self)){
            return 0
        }
        builder.inProgress.insert(ObjectIdentifier(self))
        let ref = try self.ref?.insert(builder)
        let (myOffset, valueCursors) = try builder.insertFemale(
            ref: ref
        )
        if ref == 0,
           let o = self.ref,
           let cursor = valueCursors[0] {
            builder.deferedBindings.append((o, cursor))
        }
        if builder.options.uniqueTables {
            builder.cache[ObjectIdentifier(self)] = myOffset
        }
        builder.inProgress.remove(ObjectIdentifier(self))
        return myOffset
    }

}
extension Female {
    public static func from(jsonObject: [String: Any]?) -> Female? {
        guard let object = jsonObject else { return nil }
        let ref = Friend.from(jsonObject: object["ref"] as? [String: Any])
        return Female (
            ref: ref
        )
    }
}
fileprivate func performLateBindings(_ builder : FlatBuffersBuilder) throws {
    for binding in builder.deferedBindings {
        if let offset = builder.cache[ObjectIdentifier(binding.object)] {
            try builder.update(offset: offset, atCursor: binding.cursor)
        } else {
            throw FlatBuffersBuildError.couldNotPerformLateBinding
        }
    }
    builder.deferedBindings.removeAll()
}
