
// generated with FlatBuffersSchemaEditor https://github.com/mzaks/FlatBuffersSchemaEditor

import Foundation

import FlatBuffersSwift
public final class ContactList {
	public var lastModified : Int64 = 0
	public var entries : ContiguousArray<Contact?> = []
	public init(){}
	public init(lastModified: Int64, entries: ContiguousArray<Contact?>){
		self.lastModified = lastModified
		self.entries = entries
	}
}
public extension ContactList {
	fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> ContactList? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if  let cache = reader.cache,
			let o = cache.objectPool[objectOffset] {
			return o as? ContactList
		}
		let _result = ContactList()
		if let cache = reader.cache {
			cache.objectPool[objectOffset] = _result
		}
		_result.lastModified = reader.get(objectOffset: objectOffset, propertyIndex: 0, defaultValue: 0)
		let offset_entries : Offset? = reader.offset(objectOffset: objectOffset, propertyIndex: 1)
		let length_entries = reader.vectorElementCount(vectorOffset: offset_entries)
		if(length_entries > 0){
			var index = 0
			_result.entries.reserveCapacity(length_entries)
			while index < length_entries {
				let element = Contact.create(reader, objectOffset: reader.vectorElementOffset(vectorOffset: offset_entries, index: index))
				_result.entries.append(element)
				index += 1
			}
		}
		return _result
	}
}
public extension ContactList {
	public static func from(data : Data,  cache : FlatBuffersReaderCache? = FlatBuffersReaderCache()) -> ContactList? {
		let reader = FlatBuffersMemoryReader(data: data, cache: cache)
		return from(reader: reader)
	}
	public static func from(reader : FlatBuffersReader) -> ContactList? {
		let objectOffset = reader.rootObjectOffset
		return create(reader, objectOffset : objectOffset)
	}
}

public extension ContactList {
	public func encode(withBuilder builder : FlatBuffersBuilder) throws -> Void {
		let offset = try addToByteArray(builder)
		try builder.finish(offset: offset, fileIdentifier: nil)
	}
	public func toData(withConfig config : FlatBuffersBuildConfig = FlatBuffersBuildConfig()) throws -> Data {
		let builder = FlatBuffersBuilder(config: config)
		try encode(withBuilder: builder)
		return builder.makeData
	}
}

public struct ContactList_Direct<T : FlatBuffersReader> : Hashable {
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
	public var lastModified : Int64 { 
		get { return reader.get(objectOffset: myOffset, propertyIndex: 0, defaultValue: 0) }
	}
	public var entriesCount : Int {
		return reader.vectorElementCount(vectorOffset: reader.offset(objectOffset: myOffset, propertyIndex: 1))
	}
	public func getEntriesElement(atIndex index : Int) -> Contact_Direct<T>? {
		let offsetList = reader.offset(objectOffset: myOffset, propertyIndex: 1)
		if let ofs = reader.vectorElementOffset(vectorOffset: offsetList, index: index) {
			return Contact_Direct<T>(reader: reader, myOffset: ofs)
		}
		return nil
	}
	public var hashValue: Int { return Int(myOffset) }
}
public func ==<T>(t1 : ContactList_Direct<T>, t2 : ContactList_Direct<T>) -> Bool {
	return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
}
public extension ContactList {
	fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		var offset1 = Offset(0)
		if entries.count > 0{
			var offsets = [Offset?](repeating: nil, count: entries.count)
			var index = entries.count - 1
			while(index >= 0){
				offsets[index] = try entries[index]?.addToByteArray(builder)
				index -= 1
			}
			try builder.startVector(count: entries.count, elementSize: MemoryLayout<Offset>.stride)
			index = entries.count - 1
			while(index >= 0){
				try builder.insert(offset: offsets[index])
				index -= 1
			}
			offset1 = builder.endVector()
		}
		try builder.startObject(numOfProperties: 2)
		if entries.count > 0 {
            try builder.insert(offset: offset1, toStartedObjectAt:1)
		}
		try builder.insert(value : lastModified, defaultValue : 0, toStartedObjectAt: 0)
		let myOffset =  try builder.endObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
public enum Gender : Int8 {
	case Male, Female
}
public enum Mood : Int8 {
	case Funny, Serious, Angry, Humble
}
public final class Contact {
	public var name : String? = nil
	public var birthday : Date? = nil
	public var gender : Gender? = Gender.Male
	public var tags : ContiguousArray<String?> = []
	public var addressEntries : ContiguousArray<AddressEntry?> = []
	public var currentLoccation : GeoLocation? = nil
	public var previousLocations : ContiguousArray<GeoLocation?> = []
	public var moods : ContiguousArray<Mood?> = []
	public init(){}
	public init(name: String?, birthday: Date?, gender: Gender?, tags: ContiguousArray<String?>, addressEntries: ContiguousArray<AddressEntry?>, currentLoccation: GeoLocation?, previousLocations: ContiguousArray<GeoLocation?>, moods: ContiguousArray<Mood?>){
		self.name = name
		self.birthday = birthday
		self.gender = gender
		self.tags = tags
		self.addressEntries = addressEntries
		self.currentLoccation = currentLoccation
		self.previousLocations = previousLocations
		self.moods = moods
	}
}
public extension Contact {
	fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> Contact? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if  let cache = reader.cache,
			let o = cache.objectPool[objectOffset] {
			return o as? Contact
		}
		let _result = Contact()
		if let cache = reader.cache {
			cache.objectPool[objectOffset] = _result
		}
		_result.name = reader.stringBuffer(stringOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 0))?§
		_result.birthday = Date.create(reader, objectOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 1))
		_result.gender = Gender(rawValue: reader.get(objectOffset: objectOffset, propertyIndex: 2, defaultValue: Gender.Male.rawValue))
		let offset_tags : Offset? = reader.offset(objectOffset: objectOffset, propertyIndex: 3)
		let length_tags = reader.vectorElementCount(vectorOffset: offset_tags)
		if(length_tags > 0){
			var index = 0
			_result.tags.reserveCapacity(length_tags)
			while index < length_tags {
				let element = reader.stringBuffer(stringOffset: reader.vectorElementOffset(vectorOffset: offset_tags, index: index))?§
				_result.tags.append(element)
				index += 1
			}
		}
		let offset_addressEntries : Offset? = reader.offset(objectOffset: objectOffset, propertyIndex: 4)
		let length_addressEntries = reader.vectorElementCount(vectorOffset: offset_addressEntries)
		if(length_addressEntries > 0){
			var index = 0
			_result.addressEntries.reserveCapacity(length_addressEntries)
			while index < length_addressEntries {
				let element = AddressEntry.create(reader, objectOffset: reader.vectorElementOffset(vectorOffset: offset_addressEntries, index: index))
				_result.addressEntries.append(element)
				index += 1
			}
		}
		_result.currentLoccation = reader.get(objectOffset: objectOffset, propertyIndex: 5)
		let offset_previousLocations : Offset? = reader.offset(objectOffset: objectOffset, propertyIndex: 6)
		let length_previousLocations = reader.vectorElementCount(vectorOffset: offset_previousLocations)
		if(length_previousLocations > 0){
			var index = 0
			_result.previousLocations.reserveCapacity(length_previousLocations)
			while index < length_previousLocations {
				let element : GeoLocation? = reader.vectorElementScalar(vectorOffset: offset_previousLocations, index: index)
				_result.previousLocations.append(element)
				index += 1
			}
		}
		let offset_moods : Offset? = reader.offset(objectOffset: objectOffset, propertyIndex: 7)
		let length_moods = reader.vectorElementCount(vectorOffset: offset_moods)
		if(length_moods > 0){
			var index = 0
			_result.moods.reserveCapacity(length_moods)
			while index < length_moods {
				if let raw : Int8 = reader.vectorElementScalar(vectorOffset: offset_moods, index: index){
					let element : Mood? = Mood(rawValue: raw)
					_result.moods.append(element)
				} else {
					_result.moods.append(nil)
				}
				index += 1
			}
		}
		return _result
	}
}
public struct Contact_Direct<T : FlatBuffersReader> : Hashable {
	fileprivate let reader : T
	fileprivate let myOffset : Offset
	fileprivate init(reader: T, myOffset: Offset){
		self.reader = reader
		self.myOffset = myOffset
	}
	public var name : UnsafeBufferPointer<UInt8>? { get { return reader.stringBuffer(stringOffset: reader.offset(objectOffset: myOffset, propertyIndex:0)) } }
	public var birthday : Date_Direct<T>? { get { 
		if let offset = reader.offset(objectOffset: myOffset, propertyIndex: 1) {
			return Date_Direct(reader: reader, myOffset: offset)
		}
		return nil
	} }
	public var gender : Gender? { 
		get { return Gender(rawValue: reader.get(objectOffset: myOffset, propertyIndex: 2, defaultValue: Gender.Male.rawValue)) }
	}
	public var tagsCount : Int {
		return reader.vectorElementCount(vectorOffset: reader.offset(objectOffset: myOffset, propertyIndex: 3))
	}
	public func getTagsElement(atIndex index : Int) -> UnsafeBufferPointer<UInt8>? {
		let offsetList = reader.offset(objectOffset: myOffset, propertyIndex: 3)
		if let ofs = reader.vectorElementOffset(vectorOffset: offsetList, index: index) {
			return reader.stringBuffer(stringOffset: ofs)
		}
		return nil
	}
	public var addressEntriesCount : Int {
		return reader.vectorElementCount(vectorOffset: reader.offset(objectOffset: myOffset, propertyIndex: 4))
	}
	public func getAddressEntriesElement(atIndex index : Int) -> AddressEntry_Direct<T>? {
		let offsetList = reader.offset(objectOffset: myOffset, propertyIndex: 4)
		if let ofs = reader.vectorElementOffset(vectorOffset: offsetList, index: index) {
			return AddressEntry_Direct<T>(reader: reader, myOffset: ofs)
		}
		return nil
	}
	public var currentLoccation : GeoLocation? { 
		get { return reader.get(objectOffset: myOffset, propertyIndex: 5)}
	}
	public var previousLocationsCount : Int {
		return reader.vectorElementCount(vectorOffset: reader.offset(objectOffset: myOffset, propertyIndex: 6))
	}
	public func getPreviousLocationsElement(atIndex index : Int) -> GeoLocation? {
		let offsetList = reader.offset(objectOffset: myOffset, propertyIndex: 6)
		let result : GeoLocation? = reader.vectorElementScalar(vectorOffset: offsetList, index: index)
		return result
	}
	public var moodsCount : Int {
		return reader.vectorElementCount(vectorOffset: reader.offset(objectOffset: myOffset, propertyIndex: 7))
	}
	public func getMoodsElement(atIndex index : Int) -> Mood? {
		let offsetList = reader.offset(objectOffset: myOffset, propertyIndex: 7)
		guard let rawValue : Int8 = reader.vectorElementScalar(vectorOffset: offsetList, index: index) else {
			return nil
		}
		return Mood(rawValue: rawValue)
	}
	public var hashValue: Int { return Int(myOffset) }
}
public func ==<T>(t1 : Contact_Direct<T>, t2 : Contact_Direct<T>) -> Bool {
	return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
}
public extension Contact {
	fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		var offset7 = Offset(0)
		if moods.count > 0 {
			try builder.startVector(count: moods.count, elementSize: MemoryLayout<Mood>.stride)
			var index = moods.count - 1
			while(index >= 0){
				if let value = moods[index]?.rawValue {
					builder.insert(value: value)
				}
				index -= 1
			}
			offset7 = builder.endVector()
		}
		var offset6 = Offset(0)
		if previousLocations.count > 0 {
			try builder.startVector(count: previousLocations.count, elementSize: MemoryLayout<GeoLocation>.stride)
			var index = previousLocations.count - 1
			while(index >= 0){
				if let value = previousLocations[index] {
					builder.insert(value: value)
				}
				index -= 1
			}
			offset6 = builder.endVector()
		}
		var offset4 = Offset(0)
		if addressEntries.count > 0{
			var offsets = [Offset?](repeating: nil, count: addressEntries.count)
			var index = addressEntries.count - 1
			while(index >= 0){
				offsets[index] = try addressEntries[index]?.addToByteArray(builder)
				index -= 1
			}
			try builder.startVector(count: addressEntries.count, elementSize: MemoryLayout<Offset>.stride)
			index = addressEntries.count - 1
			while(index >= 0){
				try builder.insert(offset: offsets[index])
				index -= 1
			}
			offset4 = builder.endVector()
		}
		var offset3 = Offset(0)
		if tags.count > 0{
			var offsets = [Offset?](repeating: nil, count: tags.count)
			var index = tags.count - 1
			while(index >= 0){
				offsets[index] = try builder.insert(value: tags[index])
				index -= 1
			}
			try builder.startVector(count: tags.count, elementSize: MemoryLayout<Offset>.stride)
			index = tags.count - 1
			while(index >= 0){
				try builder.insert(offset: offsets[index])
				index -= 1
			}
			offset3 = builder.endVector()
		}
		let offset1 = try birthday?.addToByteArray(builder) ?? 0
		let offset0 = try builder.insert(value: name)
		try builder.startObject(numOfProperties: 8)
		if moods.count > 0 {
			try builder.insert(offset: offset7, toStartedObjectAt: 7)
		}
		if previousLocations.count > 0 {
			try builder.insert(offset: offset6, toStartedObjectAt: 6)
		}
		if let currentLoccation = currentLoccation {
			builder.insert(value: currentLoccation)
			try builder.insertCurrentOffsetAsProperty(toStartedObjectAt: 5)
		}
		if addressEntries.count > 0 {
			try builder.insert(offset: offset4, toStartedObjectAt: 4)
		}
		if tags.count > 0 {
			try builder.insert(offset: offset3, toStartedObjectAt: 3)
		}
        try builder.insert(value : gender?.rawValue ?? 0, defaultValue : 0, toStartedObjectAt: 2)
		if birthday != nil {
			try builder.insert(offset: offset1, toStartedObjectAt: 1)
		}
		try builder.insert(offset: offset0, toStartedObjectAt: 0)
		let myOffset =  try builder.endObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
public final class Date {
	public var day : Int8 = 0
	public var month : Int8 = 0
	public var year : Int16 = 0
	public init(){}
	public init(day: Int8, month: Int8, year: Int16){
		self.day = day
		self.month = month
		self.year = year
	}
}
public extension Date {
	fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> Date? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if  let cache = reader.cache,
			let o = cache.objectPool[objectOffset] {
			return o as? Date
		}
		let _result = Date()
		if let cache = reader.cache {
			cache.objectPool[objectOffset] = _result
		}
		_result.day = reader.get(objectOffset: objectOffset, propertyIndex: 0, defaultValue: 0)
		_result.month = reader.get(objectOffset: objectOffset, propertyIndex: 1, defaultValue: 0)
		_result.year = reader.get(objectOffset: objectOffset, propertyIndex: 2, defaultValue: 0)
		return _result
	}
}
public struct Date_Direct<T : FlatBuffersReader> : Hashable {
	fileprivate let reader : T
	fileprivate let myOffset : Offset
	fileprivate init(reader: T, myOffset: Offset){
		self.reader = reader
		self.myOffset = myOffset
	}
	public var day : Int8 { 
		get { return reader.get(objectOffset: myOffset, propertyIndex: 0, defaultValue: 0) }
	}
	public var month : Int8 { 
		get { return reader.get(objectOffset: myOffset, propertyIndex: 1, defaultValue: 0) }
	}
	public var year : Int16 { 
		get { return reader.get(objectOffset: myOffset, propertyIndex: 2, defaultValue: 0) }
	}
	public var hashValue: Int { return Int(myOffset) }
}
public func ==<T>(t1 : Date_Direct<T>, t2 : Date_Direct<T>) -> Bool {
	return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
}
public extension Date {
	fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		try builder.startObject(numOfProperties: 3)
        try builder.insert(value : year, defaultValue : 0, toStartedObjectAt: 2)
        try builder.insert(value : month, defaultValue : 0, toStartedObjectAt: 1)
        try builder.insert(value : day, defaultValue : 0, toStartedObjectAt: 0)
		let myOffset =  try builder.endObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
public struct GeoLocation : Scalar {
	public let latitude : Float64
	public let longitude : Float64
	public let elevation : Float32
}
public func ==(v1:GeoLocation, v2:GeoLocation) -> Bool {
	return  v1.latitude==v2.latitude &&  v1.longitude==v2.longitude &&  v1.elevation==v2.elevation
}
public final class AddressEntry {
	public var order : Int32 = 0
	public var address : Address? = nil
	public init(){}
	public init(order: Int32, address: Address?){
		self.order = order
		self.address = address
	}
}
public extension AddressEntry {
	fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> AddressEntry? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if  let cache = reader.cache,
			let o = cache.objectPool[objectOffset] {
			return o as? AddressEntry
		}
		let _result = AddressEntry()
		if let cache = reader.cache {
			cache.objectPool[objectOffset] = _result
		}
		_result.order = reader.get(objectOffset: objectOffset, propertyIndex: 0, defaultValue: 0)
		_result.address = create_Address(reader, propertyIndex: 1, objectOffset: objectOffset)
		return _result
	}
}
public struct AddressEntry_Direct<T : FlatBuffersReader> : Hashable {
	fileprivate let reader : T
	fileprivate let myOffset : Offset
	fileprivate init(reader: T, myOffset: Offset){
		self.reader = reader
		self.myOffset = myOffset
	}
	public var order : Int32 { 
		get { return reader.get(objectOffset: myOffset, propertyIndex: 0, defaultValue: 0) }
	}
	public var address : Address_Direct? { get { 
		return create_Address_Direct(reader, propertyIndex: 1, objectOffset: self.myOffset)
	} }
	public var hashValue: Int { return Int(myOffset) }
}
public func ==<T>(t1 : AddressEntry_Direct<T>, t2 : AddressEntry_Direct<T>) -> Bool {
	return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
}
public extension AddressEntry {
	fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		let offset1 = try addToByteArray_Address(builder, union: address)
		try builder.startObject(numOfProperties: 3)
		if let object = address {
			try builder.insert(offset: offset1, toStartedObjectAt: 2)
            try builder.insert(value : unionCase_Address(object), defaultValue : 0, toStartedObjectAt: 1)
		}
        try builder.insert(value : order, defaultValue : 0, toStartedObjectAt: 0)
		let myOffset =  try builder.endObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
public final class PostalAddress {
	public var country : String? = nil
	public var city : String? = nil
	public var postalCode : Int32 = 0
	public var streetAndNumber : String? = nil
	public init(){}
	public init(country: String?, city: String?, postalCode: Int32, streetAndNumber: String?){
		self.country = country
		self.city = city
		self.postalCode = postalCode
		self.streetAndNumber = streetAndNumber
	}
}
public extension PostalAddress {
	fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> PostalAddress? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if  let cache = reader.cache,
			let o = cache.objectPool[objectOffset] {
			return o as? PostalAddress
		}
		let _result = PostalAddress()
		if let cache = reader.cache {
			cache.objectPool[objectOffset] = _result
		}
		_result.country = reader.stringBuffer(stringOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 0))?§
		_result.city = reader.stringBuffer(stringOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 1))?§
		_result.postalCode = reader.get(objectOffset: objectOffset, propertyIndex: 2, defaultValue: 0)
		_result.streetAndNumber = reader.stringBuffer(stringOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 3))?§
		return _result
	}
}
public struct PostalAddress_Direct<T : FlatBuffersReader> : Hashable {
	fileprivate let reader : T
	fileprivate let myOffset : Offset
	fileprivate init(reader: T, myOffset: Offset){
		self.reader = reader
		self.myOffset = myOffset
	}
	public var country : UnsafeBufferPointer<UInt8>? { get { return reader.stringBuffer(stringOffset: reader.offset(objectOffset: myOffset, propertyIndex:0)) } }
	public var city : UnsafeBufferPointer<UInt8>? { get { return reader.stringBuffer(stringOffset: reader.offset(objectOffset: myOffset, propertyIndex:1)) } }
	public var postalCode : Int32 { 
		get { return reader.get(objectOffset: myOffset, propertyIndex: 2, defaultValue: 0) }
	}
	public var streetAndNumber : UnsafeBufferPointer<UInt8>? { get { return reader.stringBuffer(stringOffset: reader.offset(objectOffset: myOffset, propertyIndex:3)) } }
	public var hashValue: Int { return Int(myOffset) }
}
public func ==<T>(t1 : PostalAddress_Direct<T>, t2 : PostalAddress_Direct<T>) -> Bool {
	return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
}
public extension PostalAddress {
	fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		let offset3 = try builder.insert(value: streetAndNumber)
		let offset1 = try builder.insert(value: city)
		let offset0 = try builder.insert(value: country)
		try builder.startObject(numOfProperties: 4)
		try builder.insert(offset: offset3, toStartedObjectAt: 3)
        try builder.insert(value : postalCode, defaultValue : 0, toStartedObjectAt: 2)
		try builder.insert(offset: offset1, toStartedObjectAt: 1)
		try builder.insert(offset: offset0, toStartedObjectAt: 0)
		let myOffset =  try builder.endObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
public final class EmailAddress {
	public var mailto : String? = nil
	public init(){}
	public init(mailto: String?){
		self.mailto = mailto
	}
}
public extension EmailAddress {
	fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> EmailAddress? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if  let cache = reader.cache,
			let o = cache.objectPool[objectOffset] {
			return o as? EmailAddress
		}
		let _result = EmailAddress()
		if let cache = reader.cache {
			cache.objectPool[objectOffset] = _result
		}
		_result.mailto = reader.stringBuffer(stringOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 0))?§
		return _result
	}
}
public struct EmailAddress_Direct<T : FlatBuffersReader> : Hashable {
	fileprivate let reader : T
	fileprivate let myOffset : Offset
	fileprivate init(reader: T, myOffset: Offset){
		self.reader = reader
		self.myOffset = myOffset
	}
	public var mailto : UnsafeBufferPointer<UInt8>? { get { return reader.stringBuffer(stringOffset: reader.offset(objectOffset: myOffset, propertyIndex:0)) } }
	public var hashValue: Int { return Int(myOffset) }
}
public func ==<T>(t1 : EmailAddress_Direct<T>, t2 : EmailAddress_Direct<T>) -> Bool {
	return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
}
public extension EmailAddress {
	fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		let offset0 = try builder.insert(value: mailto)
		try builder.startObject(numOfProperties: 1)
		try builder.insert(offset: offset0, toStartedObjectAt: 0)
		let myOffset =  try builder.endObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
public final class WebAddress {
	public var url : String? = nil
	public init(){}
	public init(url: String?){
		self.url = url
	}
}
public extension WebAddress {
	fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> WebAddress? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if  let cache = reader.cache,
			let o = cache.objectPool[objectOffset] {
			return o as? WebAddress
		}
		let _result = WebAddress()
		if let cache = reader.cache {
			cache.objectPool[objectOffset] = _result
		}
		_result.url = reader.stringBuffer(stringOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 0))?§
		return _result
	}
}
public struct WebAddress_Direct<T : FlatBuffersReader> : Hashable {
	fileprivate let reader : T
	fileprivate let myOffset : Offset
	fileprivate init(reader: T, myOffset: Offset){
		self.reader = reader
		self.myOffset = myOffset
	}
	public var url : UnsafeBufferPointer<UInt8>? { get { return reader.stringBuffer(stringOffset: reader.offset(objectOffset: myOffset, propertyIndex:0)) } }
	public var hashValue: Int { return Int(myOffset) }
}
public func ==<T>(t1 : WebAddress_Direct<T>, t2 : WebAddress_Direct<T>) -> Bool {
	return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
}
public extension WebAddress {
	fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		let offset0 = try builder.insert(value: url)
		try builder.startObject(numOfProperties: 1)
		try builder.insert(offset: offset0, toStartedObjectAt: 0)
		let myOffset =  try builder.endObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
public final class TelephoneNumber {
	public var number : String? = nil
	public init(){}
	public init(number: String?){
		self.number = number
	}
}
public extension TelephoneNumber {
	fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> TelephoneNumber? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if  let cache = reader.cache,
			let o = cache.objectPool[objectOffset] {
			return o as? TelephoneNumber
		}
		let _result = TelephoneNumber()
		if let cache = reader.cache {
			cache.objectPool[objectOffset] = _result
		}
		_result.number = reader.stringBuffer(stringOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 0))?§
		return _result
	}
}
public struct TelephoneNumber_Direct<T : FlatBuffersReader> : Hashable {
	fileprivate let reader : T
	fileprivate let myOffset : Offset
	fileprivate init(reader: T, myOffset: Offset){
		self.reader = reader
		self.myOffset = myOffset
	}
	public var number : UnsafeBufferPointer<UInt8>? { get { return reader.stringBuffer(stringOffset: reader.offset(objectOffset: myOffset, propertyIndex:0)) } }
	public var hashValue: Int { return Int(myOffset) }
}
public func ==<T>(t1 : TelephoneNumber_Direct<T>, t2 : TelephoneNumber_Direct<T>) -> Bool {
	return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
}
public extension TelephoneNumber {
	fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		let offset0 = try builder.insert(value: number)
		try builder.startObject(numOfProperties: 1)
		try builder.insert(offset: offset0, toStartedObjectAt: 0)
		let myOffset =  try builder.endObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
public protocol Address{}
public protocol Address_Direct{}
extension PostalAddress : Address {}
extension PostalAddress_Direct : Address_Direct {}
extension EmailAddress : Address {}
extension EmailAddress_Direct : Address_Direct {}
extension WebAddress : Address {}
extension WebAddress_Direct : Address_Direct {}
extension TelephoneNumber : Address {}
extension TelephoneNumber_Direct : Address_Direct {}
fileprivate func create_Address(_ reader : FlatBuffersReader, propertyIndex : Int, objectOffset : Offset?) -> Address? {
	guard let objectOffset = objectOffset else {
		return nil
	}
	let unionCase : Int8 = reader.get(objectOffset: objectOffset, propertyIndex: propertyIndex, defaultValue: 0)
	guard let caseObjectOffset : Offset = reader.offset(objectOffset: objectOffset, propertyIndex:propertyIndex + 1) else {
		return nil
	}
	switch unionCase {
	case 1 : return PostalAddress.create(reader, objectOffset: caseObjectOffset)
	case 2 : return EmailAddress.create(reader, objectOffset: caseObjectOffset)
	case 3 : return WebAddress.create(reader, objectOffset: caseObjectOffset)
	case 4 : return TelephoneNumber.create(reader, objectOffset: caseObjectOffset)
	default : return nil
	}
}

fileprivate func create_Address_Direct<T : FlatBuffersReader>(_ reader : T, propertyIndex : Int, objectOffset : Offset?) -> Address_Direct? {
	guard let objectOffset = objectOffset else {
		return nil
	}
	let unionCase : Int8 = reader.get(objectOffset: objectOffset, propertyIndex: propertyIndex, defaultValue: 0)
	guard let caseObjectOffset : Offset = reader.offset(objectOffset: objectOffset, propertyIndex:propertyIndex + 1) else {
		return nil
	}
	switch unionCase {
	case 1 : return PostalAddress_Direct(reader: reader, myOffset: caseObjectOffset)
	case 2 : return EmailAddress_Direct(reader: reader, myOffset: caseObjectOffset)
	case 3 : return WebAddress_Direct(reader: reader, myOffset: caseObjectOffset)
	case 4 : return TelephoneNumber_Direct(reader: reader, myOffset: caseObjectOffset)
	default : return nil
	}
}
private func unionCase_Address(_ union : Address?) -> Int8 {
	switch union {
	case is PostalAddress : return 1
	case is EmailAddress : return 2
	case is WebAddress : return 3
	case is TelephoneNumber : return 4
	default : return 0
	}
}
fileprivate func addToByteArray_Address(_ builder : FlatBuffersBuilder, union : Address?) throws -> Offset {
	switch union {
	case let u as PostalAddress : return try u.addToByteArray(builder)
	case let u as EmailAddress : return try u.addToByteArray(builder)
	case let u as WebAddress : return try u.addToByteArray(builder)
	case let u as TelephoneNumber : return try u.addToByteArray(builder)
	default : return 0
	}
}
