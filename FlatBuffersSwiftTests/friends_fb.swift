
// generated with FlatBuffersSchemaEditor https://github.com/mzaks/FlatBuffersSchemaEditor

import Foundation

import FlatBuffersSwift
public final class PeopleList {
	public var people : ContiguousArray<Friend?> = []
	public init(){}
	public init(people: ContiguousArray<Friend?>){
		self.people = people
	}
}
public extension PeopleList {
	fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> PeopleList? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if  let cache = reader.cache,
			let o = cache.objectPool[objectOffset] {
			return o as? PeopleList
		}
		let _result = PeopleList()
		if let cache = reader.cache {
			cache.objectPool[objectOffset] = _result
		}
		let offset_people : Offset? = reader.offset(objectOffset: objectOffset, propertyIndex: 0)
		let length_people = reader.vectorElementCount(vectorOffset: offset_people)
		if(length_people > 0){
			var index = 0
			_result.people.reserveCapacity(length_people)
			while index < length_people {
				let element = Friend.create(reader, objectOffset: reader.vectorElementOffset(vectorOffset: offset_people, index: index))
				_result.people.append(element)
				index += 1
			}
		}
		return _result
	}
}
public extension PeopleList {
	public static func makePeopleList(data : Data,  cache : FlatBuffersReaderCache? = FlatBuffersReaderCache()) -> PeopleList? {
		let reader = FlatBuffersMemoryReader(data: data, cache: cache)
		return makePeopleList(reader: reader)
	}
	public static func makePeopleList(reader : FlatBuffersReader) -> PeopleList? {
		let objectOffset = reader.rootObjectOffset
		return create(reader, objectOffset : objectOffset)
	}
}

public extension PeopleList {
	public func encode(withBuilder builder : FlatBuffersBuilder) throws -> Void {
		let offset = try addToByteArray(builder)
		try performLateBindings(builder)
		try builder.finish(offset: offset, fileIdentifier: "TEST")
	}
	public func makeData(withConfig config : FlatBuffersBuildConfig = FlatBuffersBuildConfig()) throws -> Data {
		let builder = FlatBuffersBuilder(config: config)
		try encode(withBuilder: builder)
		return builder.makeData
	}
}

public struct PeopleList_Direct<T : FlatBuffersReader> : Hashable {
	fileprivate let reader : T
	fileprivate let myOffset : Offset
	fileprivate init(reader: T, myOffset: Offset){
		self.reader = reader
		self.myOffset = myOffset
	}
	public init?(_ reader: T) {
		self.reader = reader
		guard let offest = reader.rootObjectOffset else {
			return nil
		}
		self.myOffset = offest
	}
	public var peopleCount : Int {
		return reader.vectorElementCount(vectorOffset: reader.offset(objectOffset: myOffset, propertyIndex: 0))
	}
	public func getPeopleElement(atIndex index : Int) -> Friend_Direct<T>? {
		let offsetList = reader.offset(objectOffset: myOffset, propertyIndex: 0)
		if let ofs = reader.vectorElementOffset(vectorOffset: offsetList, index: index) {
			return Friend_Direct<T>(reader: reader, myOffset: ofs)
		}
		return nil
	}
	public var hashValue: Int { return Int(myOffset) }
}
public func ==<T>(t1 : PeopleList_Direct<T>, t2 : PeopleList_Direct<T>) -> Bool {
	return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
}
public extension PeopleList {
	fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		if builder.inProgress.contains(ObjectIdentifier(self)){
			return 0
		}
		builder.inProgress.insert(ObjectIdentifier(self))
		var offset0 = Offset(0)
		if people.count > 0{
			var offsets = [Offset?](repeating: nil, count: people.count)
			var index = people.count - 1
			var deferedBindingObjects : [Int : Friend] = [:]
			while(index >= 0){
				offsets[index] = try people[index]?.addToByteArray(builder)
				if offsets[index] == 0 {
					deferedBindingObjects[index] = people[index]!
				}
				index -= 1
			}
			try builder.startVector(count: people.count, elementSize: MemoryLayout<Offset>.stride)
			index = people.count - 1
			var deferedBindingCursors : [Int : Int] = [:]
			while(index >= 0){
				let cursor = try builder.insert(offset: offsets[index])
				if offsets[index] == 0 {
					deferedBindingCursors[index] = cursor
				}
				index -= 1
			}
			for key in deferedBindingObjects.keys {
				if let object = deferedBindingObjects[key],
				   let cursor = deferedBindingCursors[key] {
					builder.deferedBindings.append((object: object, cursor: cursor))
				}
			}
			offset0 = builder.endVector()
		}
		try builder.startObject(numOfProperties: 1)
		if people.count > 0 {
			try builder.insert(offset: offset0, toStartedObjectAt: 0)
		}
		let myOffset =  try builder.endObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		builder.inProgress.remove(ObjectIdentifier(self))
		return myOffset
	}
}
public final class Friend {
	public var name : String? = nil
	public var friends : ContiguousArray<Friend?> = []
	public var father : Friend? = nil
	public var mother : Friend? = nil
	public var lover : Human? = nil
	public init(){}
	public init(name: String?, friends: ContiguousArray<Friend?>, father: Friend?, mother: Friend?, lover: Human?){
		self.name = name
		self.friends = friends
		self.father = father
		self.mother = mother
		self.lover = lover
	}
}
public extension Friend {
	fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> Friend? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if  let cache = reader.cache,
			let o = cache.objectPool[objectOffset] {
			return o as? Friend
		}
		let _result = Friend()
		if let cache = reader.cache {
			cache.objectPool[objectOffset] = _result
		}
		_result.name = reader.stringBuffer(stringOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 0))?§
		let offset_friends : Offset? = reader.offset(objectOffset: objectOffset, propertyIndex: 1)
		let length_friends = reader.vectorElementCount(vectorOffset: offset_friends)
		if(length_friends > 0){
			var index = 0
			_result.friends.reserveCapacity(length_friends)
			while index < length_friends {
				let element = Friend.create(reader, objectOffset: reader.vectorElementOffset(vectorOffset: offset_friends, index: index))
				_result.friends.append(element)
				index += 1
			}
		}
		_result.father = Friend.create(reader, objectOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 2))
		_result.mother = Friend.create(reader, objectOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 3))
		_result.lover = create_Human(reader, propertyIndex: 4, objectOffset: objectOffset)
		return _result
	}
}
public struct Friend_Direct<T : FlatBuffersReader> : Hashable {
	fileprivate let reader : T
	fileprivate let myOffset : Offset
	fileprivate init(reader: T, myOffset: Offset){
		self.reader = reader
		self.myOffset = myOffset
	}
	public var name : UnsafeBufferPointer<UInt8>? { get { return reader.stringBuffer(stringOffset: reader.offset(objectOffset: myOffset, propertyIndex:0)) } }
	public var friendsCount : Int {
		return reader.vectorElementCount(vectorOffset: reader.offset(objectOffset: myOffset, propertyIndex: 1))
	}
	public func getFriendsElement(atIndex index : Int) -> Friend_Direct<T>? {
		let offsetList = reader.offset(objectOffset: myOffset, propertyIndex: 1)
		if let ofs = reader.vectorElementOffset(vectorOffset: offsetList, index: index) {
			return Friend_Direct<T>(reader: reader, myOffset: ofs)
		}
		return nil
	}
	public var father : Friend_Direct<T>? { get { 
		if let offset = reader.offset(objectOffset: myOffset, propertyIndex: 2) {
			return Friend_Direct(reader: reader, myOffset: offset)
		}
		return nil
	} }
	public var mother : Friend_Direct<T>? { get { 
		if let offset = reader.offset(objectOffset: myOffset, propertyIndex: 3) {
			return Friend_Direct(reader: reader, myOffset: offset)
		}
		return nil
	} }
	public var lover : Human_Direct? { get { 
		return create_Human_Direct(reader, propertyIndex: 4, objectOffset: self.myOffset)
	} }
	public var hashValue: Int { return Int(myOffset) }
}
public func ==<T>(t1 : Friend_Direct<T>, t2 : Friend_Direct<T>) -> Bool {
	return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
}
public extension Friend {
	fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		if builder.inProgress.contains(ObjectIdentifier(self)){
			return 0
		}
		builder.inProgress.insert(ObjectIdentifier(self))
		let offset4 = try addToByteArray_Human(builder, union: lover)
		let offset3 = try mother?.addToByteArray(builder) ?? 0
		let offset2 = try father?.addToByteArray(builder) ?? 0
		var offset1 = Offset(0)
		if friends.count > 0{
			var offsets = [Offset?](repeating: nil, count: friends.count)
			var index = friends.count - 1
			var deferedBindingObjects : [Int : Friend] = [:]
			while(index >= 0){
				offsets[index] = try friends[index]?.addToByteArray(builder)
				if offsets[index] == 0 {
					deferedBindingObjects[index] = friends[index]!
				}
				index -= 1
			}
			try builder.startVector(count: friends.count, elementSize: MemoryLayout<Offset>.stride)
			index = friends.count - 1
			var deferedBindingCursors : [Int : Int] = [:]
			while(index >= 0){
				let cursor = try builder.insert(offset: offsets[index])
				if offsets[index] == 0 {
					deferedBindingCursors[index] = cursor
				}
				index -= 1
			}
			for key in deferedBindingObjects.keys {
				if let object = deferedBindingObjects[key],
				   let cursor = deferedBindingCursors[key] {
					builder.deferedBindings.append((object: object, cursor: cursor))
				}
			}
			offset1 = builder.endVector()
		}
		let offset0 = try builder.insert(value: name)
		try builder.startObject(numOfProperties: 6)
		if let object = lover {
			let cursor4 = try builder.insert(offset: offset4, toStartedObjectAt: 5)
			if offset4 == 0 {
				builder.deferedBindings.append((object: object, cursor: cursor4))
			}
            try builder.insert(value : unionCase_Human(object), defaultValue : 0, toStartedObjectAt: 4)
		}
		if mother != nil {
			let cursor3 = try builder.insert(offset: offset3, toStartedObjectAt: 3)
			if offset3 == 0 {
				if let object = mother {
					builder.deferedBindings.append((object: object, cursor: cursor3))
				}
			}
		}
		if father != nil {
			let cursor2 = try builder.insert(offset: offset2, toStartedObjectAt: 2)
			if offset2 == 0 {
				if let object = father {
					builder.deferedBindings.append((object: object, cursor: cursor2))
				}
			}
		}
		if friends.count > 0 {
			try builder.insert(offset: offset1, toStartedObjectAt: 1)
		}
		try builder.insert(offset: offset0, toStartedObjectAt: 0)
		let myOffset =  try builder.endObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		builder.inProgress.remove(ObjectIdentifier(self))
		return myOffset
	}
}
public final class Male {
	public var ref : Friend? = nil
	public init(){}
	public init(ref: Friend?){
		self.ref = ref
	}
}
public extension Male {
	fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> Male? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if  let cache = reader.cache,
			let o = cache.objectPool[objectOffset] {
			return o as? Male
		}
		let _result = Male()
		if let cache = reader.cache {
			cache.objectPool[objectOffset] = _result
		}
		_result.ref = Friend.create(reader, objectOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 0))
		return _result
	}
}
public struct Male_Direct<T : FlatBuffersReader> : Hashable {
	fileprivate let reader : T
	fileprivate let myOffset : Offset
	fileprivate init(reader: T, myOffset: Offset){
		self.reader = reader
		self.myOffset = myOffset
	}
	public var ref : Friend_Direct<T>? { get { 
		if let offset = reader.offset(objectOffset: myOffset, propertyIndex: 0) {
			return Friend_Direct(reader: reader, myOffset: offset)
		}
		return nil
	} }
	public var hashValue: Int { return Int(myOffset) }
}
public func ==<T>(t1 : Male_Direct<T>, t2 : Male_Direct<T>) -> Bool {
	return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
}
public extension Male {
	fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		if builder.inProgress.contains(ObjectIdentifier(self)){
			return 0
		}
		builder.inProgress.insert(ObjectIdentifier(self))
		let offset0 = try ref?.addToByteArray(builder) ?? 0
		try builder.startObject(numOfProperties: 1)
		if ref != nil {
			let cursor0 = try builder.insert(offset: offset0, toStartedObjectAt: 0)
			if offset0 == 0 {
				if let object = ref {
					builder.deferedBindings.append((object: object, cursor: cursor0))
				}
			}
		}
		let myOffset =  try builder.endObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		builder.inProgress.remove(ObjectIdentifier(self))
		return myOffset
	}
}
public final class Female {
	public var ref : Friend? = nil
	public init(){}
	public init(ref: Friend?){
		self.ref = ref
	}
}
public extension Female {
	fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> Female? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if  let cache = reader.cache,
			let o = cache.objectPool[objectOffset] {
			return o as? Female
		}
		let _result = Female()
		if let cache = reader.cache {
			cache.objectPool[objectOffset] = _result
		}
		_result.ref = Friend.create(reader, objectOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 0))
		return _result
	}
}
public struct Female_Direct<T : FlatBuffersReader> : Hashable {
	fileprivate let reader : T
	fileprivate let myOffset : Offset
	fileprivate init(reader: T, myOffset: Offset){
		self.reader = reader
		self.myOffset = myOffset
	}
	public var ref : Friend_Direct<T>? { get { 
		if let offset = reader.offset(objectOffset: myOffset, propertyIndex: 0) {
			return Friend_Direct(reader: reader, myOffset: offset)
		}
		return nil
	} }
	public var hashValue: Int { return Int(myOffset) }
}
public func ==<T>(t1 : Female_Direct<T>, t2 : Female_Direct<T>) -> Bool {
	return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
}
public extension Female {
	fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		if builder.inProgress.contains(ObjectIdentifier(self)){
			return 0
		}
		builder.inProgress.insert(ObjectIdentifier(self))
		let offset0 = try ref?.addToByteArray(builder) ?? 0
		try builder.startObject(numOfProperties: 1)
		if ref != nil {
			let cursor0 = try builder.insert(offset: offset0, toStartedObjectAt: 0)
			if offset0 == 0 {
				if let object = ref {
					builder.deferedBindings.append((object: object, cursor: cursor0))
				}
			}
		}
		let myOffset =  try builder.endObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		builder.inProgress.remove(ObjectIdentifier(self))
		return myOffset
	}
}
public protocol Human{}
public protocol Human_Direct{}
extension Male : Human {}
extension Male_Direct : Human_Direct {}
extension Female : Human {}
extension Female_Direct : Human_Direct {}
fileprivate func create_Human(_ reader : FlatBuffersReader, propertyIndex : Int, objectOffset : Offset?) -> Human? {
	guard let objectOffset = objectOffset else {
		return nil
	}
	let unionCase : Int8 = reader.get(objectOffset: objectOffset, propertyIndex: propertyIndex, defaultValue: 0)
	guard let caseObjectOffset : Offset = reader.offset(objectOffset: objectOffset, propertyIndex:propertyIndex + 1) else {
		return nil
	}
	switch unionCase {
	case 1 : return Male.create(reader, objectOffset: caseObjectOffset)
	case 2 : return Female.create(reader, objectOffset: caseObjectOffset)
	default : return nil
	}
}

fileprivate func create_Human_Direct<T : FlatBuffersReader>(_ reader : T, propertyIndex : Int, objectOffset : Offset?) -> Human_Direct? {
	guard let objectOffset = objectOffset else {
		return nil
	}
	let unionCase : Int8 = reader.get(objectOffset: objectOffset, propertyIndex: propertyIndex, defaultValue: 0)
	guard let caseObjectOffset : Offset = reader.offset(objectOffset: objectOffset, propertyIndex:propertyIndex + 1) else {
		return nil
	}
	switch unionCase {
	case 1 : return Male_Direct(reader: reader, myOffset: caseObjectOffset)
	case 2 : return Female_Direct(reader: reader, myOffset: caseObjectOffset)
	default : return nil
	}
}
private func unionCase_Human(_ union : Human?) -> Int8 {
	switch union {
	case is Male : return 1
	case is Female : return 2
	default : return 0
	}
}
fileprivate func addToByteArray_Human(_ builder : FlatBuffersBuilder, union : Human?) throws -> Offset {
	switch union {
	case let u as Male : return try u.addToByteArray(builder)
	case let u as Female : return try u.addToByteArray(builder)
	default : return 0
	}
}
private func performLateBindings(_ builder : FlatBuffersBuilder) throws {
	for binding in builder.deferedBindings {
		switch binding.object {
		case let object as PeopleList: try builder.update(offset: object.addToByteArray(builder), atCursor: binding.cursor)
		case let object as Friend: try builder.update(offset: object.addToByteArray(builder), atCursor: binding.cursor)
		case let object as Male: try builder.update(offset: object.addToByteArray(builder), atCursor: binding.cursor)
		case let object as Female: try builder.update(offset: object.addToByteArray(builder), atCursor: binding.cursor)
		default: continue
		}
	}
}
