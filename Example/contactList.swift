
// generated with FlatBuffersSchemaEditor https://github.com/mzaks/FlatBuffersSchemaEditor

import Foundation

public final class ContactList {
	public static var instancePoolMutex : pthread_mutex_t = ContactList.setupInstancePoolMutex()
	public static var maxInstanceCacheSize : UInt = 0
	public static var instancePool : ContiguousArray<ContactList> = []
	public var lastModified : Int64 = 0
	public var entries : ContiguousArray<Contact?> = []
	public init(){}
	public init(lastModified: Int64, entries: ContiguousArray<Contact?>){
		self.lastModified = lastModified
		self.entries = entries
	}
}

extension ContactList : PoolableInstances {
	public func reset() { 
		lastModified = 0
		while (entries.count > 0) {
			var x = entries.removeLast()!
			Contact.reuseInstance(&x)
		}
	}
}
public extension ContactList {
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> ContactList? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if reader.config.uniqueTables {
			if let o = reader.objectPool[objectOffset]{
				return o as? ContactList
			}
		}
		let _result = ContactList.createInstance()
		if reader.config.uniqueTables {
			reader.objectPool[objectOffset] = _result
		}
		_result.lastModified = reader.get(objectOffset, propertyIndex: 0, defaultValue: 0)
		let offset_entries : Offset? = reader.getOffset(objectOffset, propertyIndex: 1)
		let length_entries = reader.getVectorLength(offset_entries)
		if(length_entries > 0){
			var index = 0
			_result.entries.reserveCapacity(length_entries)
			while index < length_entries {
				_result.entries.append(Contact.create(reader, objectOffset: reader.getVectorOffsetElement(offset_entries!, index: index)))
				index += 1
			}
		}
		return _result
	}
}
public extension ContactList {
	public static func fromByteArray(data : UnsafeBufferPointer<UInt8>, config : BinaryReadConfig = BinaryReadConfig()) -> ContactList {
		let reader = FlatBufferReader.create(data, config: config)
		let objectOffset = reader.rootObjectOffset
		let result = create(reader, objectOffset : objectOffset)!
		FlatBufferReader.reuse(reader)
		return result
	}
	public static func fromRawMemory(data : UnsafeMutablePointer<UInt8>, count : Int, config : BinaryReadConfig = BinaryReadConfig()) -> ContactList {
		let reader = FlatBufferReader.create(data, count: count, config: config)
		let objectOffset = reader.rootObjectOffset
		let result = create(reader, objectOffset : objectOffset)!
		FlatBufferReader.reuse(reader)
		return result
	}
	public static func fromFlatBufferReader(flatBufferReader : FlatBufferReader) -> ContactList {
		return create(flatBufferReader, objectOffset : flatBufferReader.rootObjectOffset)!
	}
}
public extension ContactList {
	public func toByteArray (config : BinaryBuildConfig = BinaryBuildConfig()) -> [UInt8] {
		let builder = FlatBufferBuilder.create(config)
		let offset = addToByteArray(builder)
		performLateBindings(builder)
		try! builder.finish(offset, fileIdentifier: nil)
		let result = builder.data
		FlatBufferBuilder.reuse(builder)
		return result
	}
}

public extension ContactList {
	public func toFlatBufferBuilder (builder : FlatBufferBuilder) -> Void {
		let offset = addToByteArray(builder)
		performLateBindings(builder)
		try! builder.finish(offset, fileIdentifier: nil)
	}
}

public extension ContactList {
	public final class LazyAccess : Hashable {
		private let _reader : FlatBufferReader!
		private let _objectOffset : Offset!
		public init(data : UnsafeBufferPointer<UInt8>, config : BinaryReadConfig = BinaryReadConfig()){
			_reader = FlatBufferReader.create(data, config: config)
			_objectOffset = _reader.rootObjectOffset
		}
		deinit{
			FlatBufferReader.reuse(_reader)
		}
		public var data : [UInt8] {
			return _reader.data
		}
		private init?(reader : FlatBufferReader, objectOffset : Offset?){
			guard let objectOffset = objectOffset else {
				_reader = nil
				_objectOffset = nil
				return nil
			}
			_reader = reader
			_objectOffset = objectOffset
		}

		public var lastModified : Int64 { 
			get { return _reader.get(_objectOffset, propertyIndex: 0, defaultValue:0)}
			set { try!_reader.set(_objectOffset, propertyIndex: 0, value: newValue)}
		}
		public lazy var entries : LazyVector<Contact.LazyAccess> = { [self]
			let vectorOffset : Offset? = self._reader.getOffset(self._objectOffset, propertyIndex: 1)
			let vectorLength = self._reader.getVectorLength(vectorOffset)
			let reader = self._reader
			return LazyVector(count: vectorLength){ [reader] in
				Contact.LazyAccess(reader: reader, objectOffset : reader.getVectorOffsetElement(vectorOffset!, index: $0))
			}
		}()

		public var createEagerVersion : ContactList? { return ContactList.create(_reader, objectOffset: _objectOffset) }
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : ContactList.LazyAccess, t2 : ContactList.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset && t1._reader === t2._reader
}

extension ContactList {
public struct Fast : Hashable {
	private var buffer : UnsafePointer<UInt8> = nil
	private var myOffset : Offset = 0
	public init(buffer: UnsafePointer<UInt8>, myOffset: Offset){
		self.buffer = buffer
		self.myOffset = myOffset
	}
	public init(_ data : UnsafePointer<UInt8>) {
		self.buffer = data
		self.myOffset = UnsafePointer<Offset>(buffer.advancedBy(0)).memory
	}
	public func getData() -> UnsafePointer<UInt8> {
		return buffer
	}
	public var lastModified : Int64 { 
		get { return FlatBufferReaderFast.get(buffer, myOffset, propertyIndex: 0, defaultValue: 0) }
		set { try!FlatBufferReaderFast.set(UnsafeMutablePointer<UInt8>(buffer), myOffset, propertyIndex: 0, value: newValue) }
	}
	public struct EntriesVector {
		private var buffer : UnsafePointer<UInt8> = nil
		private var myOffset : Offset = 0
		private let offsetList : Offset?
		private init(buffer b: UnsafePointer<UInt8>, myOffset o: Offset ) {
			buffer = b
			myOffset = o
			offsetList = FlatBufferReaderFast.getOffset(buffer, myOffset, propertyIndex: 1)
		}
		public var count : Int { get { return FlatBufferReaderFast.getVectorLength(buffer, offsetList) } }
		public subscript (index : Int) -> Contact.Fast? {
			get {
				if let ofs = FlatBufferReaderFast.getVectorOffsetElement(buffer, offsetList!, index: index) {
					return Contact.Fast(buffer: buffer, myOffset: ofs)
				}
				return nil
			}
		}
	}
	public lazy var entries : EntriesVector = EntriesVector(buffer: self.buffer, myOffset: self.myOffset)
	public var hashValue: Int { return Int(myOffset) }
}
}
public func ==(t1 : ContactList.Fast, t2 : ContactList.Fast) -> Bool {
	return t1.buffer == t2.buffer && t1.myOffset == t2.myOffset
}
public extension ContactList {
	private func addToByteArray(builder : FlatBufferBuilder) -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		var offset1 = Offset(0)
		if entries.count > 0{
			var offsets = [Offset?](count: entries.count, repeatedValue: nil)
			var index = entries.count - 1
			while(index >= 0){
				offsets[index] = entries[index]?.addToByteArray(builder)
				index -= 1
			}
			try! builder.startVector(entries.count, elementSize: strideof(Offset))
			index = entries.count - 1
			while(index >= 0){
				try! builder.putOffset(offsets[index])
				index -= 1
			}
			offset1 = builder.endVector()
		}
		try! builder.openObject(2)
		if entries.count > 0 {
			try! builder.addPropertyOffsetToOpenObject(1, offset: offset1)
		}
		try! builder.addPropertyToOpenObject(0, value : lastModified, defaultValue : 0)
		let myOffset =  try! builder.closeObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
extension ContactList {
	public func toJSON() -> String{
		var properties : [String] = []
		properties.append("\"lastModified\":\(lastModified)")
		properties.append("\"entries\":[\(entries.map({$0 == nil ? "null" : $0!.toJSON()}).joinWithSeparator(","))]")
		
		return "{\(properties.joinWithSeparator(","))}"
	}

	public static func fromJSON(dict : NSDictionary) -> ContactList {
		let result = ContactList()
		if let lastModified = dict["lastModified"] as? NSNumber {
			result.lastModified = lastModified.longLongValue
		}
		if let entries = dict["entries"] as? NSArray {
			result.entries = ContiguousArray(entries.map({
				if let entry = $0 as? NSDictionary {
					return Contact.fromJSON(entry)
				}
				return nil
			}))
		}
		return result
	}
	
	public func jsonTypeName() -> String {
		return "\"ContactList\""
	}
}
		public enum Gender : Int8 {
			case None, Male, Female
		}
		
		extension Gender {
			func toJSON() -> String {
				switch self {
				case None:
					return "\"None\""
				case Male:
					return "\"Male\""
				case Female:
					return "\"Female\""
				}
			}
			static func fromJSON(value : String) -> Gender? {
			switch value {
			case "None":
				return None
			case "Male":
				return Male
			case "Female":
				return Female
			default:
				return nil
			}
		}
}
		
		public enum Mood : Int8 {
			case Funny, Serious, Angry, Humble
		}
		
		extension Mood {
			func toJSON() -> String {
				switch self {
				case Funny:
					return "\"Funny\""
				case Serious:
					return "\"Serious\""
				case Angry:
					return "\"Angry\""
				case Humble:
					return "\"Humble\""
				}
			}
			static func fromJSON(value : String) -> Mood? {
			switch value {
			case "Funny":
				return Funny
			case "Serious":
				return Serious
			case "Angry":
				return Angry
			case "Humble":
				return Humble
			default:
				return nil
			}
		}
}
		
public final class Contact {
	public static var instancePoolMutex : pthread_mutex_t = Contact.setupInstancePoolMutex()
	public static var maxInstanceCacheSize : UInt = 0
	public static var instancePool : ContiguousArray<Contact> = []
	public var name : String? {
		get {
			if let s = name_s {
				return s
			}
			if let s = name_ss {
				name_s = s.stringValue
			}
			if let s = name_b {
				name_s = String.init(bytesNoCopy: UnsafeMutablePointer<UInt8>(s.baseAddress), length: s.count, encoding: NSUTF8StringEncoding, freeWhenDone: false)
			}
			return name_s
		}
		set {
			name_s = newValue
			name_ss = nil
			name_b = nil
		}
	}
	public func nameStaticString(newValue : StaticString) {
		name_ss = newValue
		name_s = nil
		name_b = nil
	}
	private var name_b : UnsafeBufferPointer<UInt8>? = nil
	public var nameBuffer : UnsafeBufferPointer<UInt8>? {return name_b}
	private var name_s : String? = nil
	private var name_ss : StaticString? = nil
	
	public var birthday : Date? = nil
	public var gender : Gender? = Gender.None
	public var tags : ContiguousArray<String?> = []
	public var addressEntries : ContiguousArray<AddressEntry?> = []
	public var currentLoccation : GeoLocation? = nil
	public var previousLocations : ContiguousArray<GeoLocation?> = []
	public var moods : ContiguousArray<Mood?> = []
	public init(){}
	public init(name: String?, birthday: Date?, gender: Gender?, tags: ContiguousArray<String?>, addressEntries: ContiguousArray<AddressEntry?>, currentLoccation: GeoLocation?, previousLocations: ContiguousArray<GeoLocation?>, moods: ContiguousArray<Mood?>){
		self.name_s = name
		self.birthday = birthday
		self.gender = gender
		self.tags = tags
		self.addressEntries = addressEntries
		self.currentLoccation = currentLoccation
		self.previousLocations = previousLocations
		self.moods = moods
	}
	public init(name: StaticString?, birthday: Date?, gender: Gender?, tags: ContiguousArray<String?>, addressEntries: ContiguousArray<AddressEntry?>, currentLoccation: GeoLocation?, previousLocations: ContiguousArray<GeoLocation?>, moods: ContiguousArray<Mood?>){
		self.name_ss = name
		self.birthday = birthday
		self.gender = gender
		self.tags = tags
		self.addressEntries = addressEntries
		self.currentLoccation = currentLoccation
		self.previousLocations = previousLocations
		self.moods = moods
	}
}

extension Contact : PoolableInstances {
	public func reset() { 
		name = nil
		if birthday != nil {
			var x = birthday!
			birthday = nil
			Date.reuseInstance(&x)
		}
		gender = Gender.None
		tags = []
		while (addressEntries.count > 0) {
			var x = addressEntries.removeLast()!
			AddressEntry.reuseInstance(&x)
		}
		currentLoccation = nil
		previousLocations = []
		moods = []
	}
}
public extension Contact {
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> Contact? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if reader.config.uniqueTables {
			if let o = reader.objectPool[objectOffset]{
				return o as? Contact
			}
		}
		let _result = Contact.createInstance()
		if reader.config.uniqueTables {
			reader.objectPool[objectOffset] = _result
		}
		_result.name_b = reader.getStringBuffer(reader.getOffset(objectOffset, propertyIndex: 0))
		_result.birthday = Date.create(reader, objectOffset: reader.getOffset(objectOffset, propertyIndex: 1))
		_result.gender = Gender(rawValue: reader.get(objectOffset, propertyIndex: 2, defaultValue: Gender.None.rawValue))
		let offset_tags : Offset? = reader.getOffset(objectOffset, propertyIndex: 3)
		let length_tags = reader.getVectorLength(offset_tags)
		if(length_tags > 0){
			var index = 0
			_result.tags.reserveCapacity(length_tags)
			while index < length_tags {
				_result.tags.append(reader.getString(reader.getVectorOffsetElement(offset_tags!, index: index)))
				index += 1
			}
		}
		let offset_addressEntries : Offset? = reader.getOffset(objectOffset, propertyIndex: 4)
		let length_addressEntries = reader.getVectorLength(offset_addressEntries)
		if(length_addressEntries > 0){
			var index = 0
			_result.addressEntries.reserveCapacity(length_addressEntries)
			while index < length_addressEntries {
				_result.addressEntries.append(AddressEntry.create(reader, objectOffset: reader.getVectorOffsetElement(offset_addressEntries!, index: index)))
				index += 1
			}
		}
		_result.currentLoccation = reader.get(objectOffset, propertyIndex: 5)
		let offset_previousLocations : Offset? = reader.getOffset(objectOffset, propertyIndex: 6)
		let length_previousLocations = reader.getVectorLength(offset_previousLocations)
		if(length_previousLocations > 0){
			var index = 0
			_result.previousLocations.reserveCapacity(length_previousLocations)
			while index < length_previousLocations {
				_result.previousLocations.append(reader.getVectorScalarElement(offset_previousLocations!, index: index) as GeoLocation
				)
				index += 1
			}
		}
		let offset_moods : Offset? = reader.getOffset(objectOffset, propertyIndex: 7)
		let length_moods = reader.getVectorLength(offset_moods)
		if(length_moods > 0){
			var index = 0
			_result.moods.reserveCapacity(length_moods)
			while index < length_moods {
				_result.moods.append(Mood(rawValue: reader.getVectorScalarElement(offset_moods!, index: index)))
				index += 1
			}
		}
		return _result
	}
}
public extension Contact {
	public final class LazyAccess : Hashable {
		private let _reader : FlatBufferReader!
		private let _objectOffset : Offset!
		private init?(reader : FlatBufferReader, objectOffset : Offset?){
			guard let objectOffset = objectOffset else {
				_reader = nil
				_objectOffset = nil
				return nil
			}
			_reader = reader
			_objectOffset = objectOffset
		}

		public lazy var name : String? = self._reader.getString(self._reader.getOffset(self._objectOffset, propertyIndex: 0))
		public lazy var birthday : Date.LazyAccess? = Date.LazyAccess(reader: self._reader, objectOffset : self._reader.getOffset(self._objectOffset, propertyIndex: 1))
		public var gender : Gender? { 
			get { return Gender(rawValue: _reader.get(self._objectOffset, propertyIndex: 2, defaultValue:Gender.None.rawValue))}
			set { 
				if let value = newValue{
					try!_reader.set(_objectOffset, propertyIndex: 2, value: value.rawValue)
				}
			}
		}
		public lazy var tags : LazyVector<String> = { [self]
			let vectorOffset : Offset? = self._reader.getOffset(self._objectOffset, propertyIndex: 3)
			let vectorLength = self._reader.getVectorLength(vectorOffset)
			let reader = self._reader
			return LazyVector(count: vectorLength){ [reader] in
				reader.getString(reader.getVectorOffsetElement(vectorOffset!, index: $0))
			}
		}()
		public lazy var addressEntries : LazyVector<AddressEntry.LazyAccess> = { [self]
			let vectorOffset : Offset? = self._reader.getOffset(self._objectOffset, propertyIndex: 4)
			let vectorLength = self._reader.getVectorLength(vectorOffset)
			let reader = self._reader
			return LazyVector(count: vectorLength){ [reader] in
				AddressEntry.LazyAccess(reader: reader, objectOffset : reader.getVectorOffsetElement(vectorOffset!, index: $0))
			}
		}()
		public var currentLoccation : GeoLocation? { 
			get { return self._reader.get(_objectOffset, propertyIndex: 5)}
			set {
				if let value = newValue{
					try!_reader.set(_objectOffset, propertyIndex: 5, value: value)
				}
			}
		}
		public lazy var previousLocations : LazyVector<GeoLocation> = { [self]
			let vectorOffset : Offset? = self._reader.getOffset(self._objectOffset, propertyIndex: 6)
			let vectorLength = self._reader.getVectorLength(vectorOffset)
			let reader = self._reader
			return LazyVector(count: vectorLength, { [reader] in
				reader.getVectorScalarElement(vectorOffset!, index: $0) as GeoLocation
			}) { [reader] in
				reader.setVectorScalarElement(vectorOffset!, index: $0, value: $1)
			}
		}()
		public lazy var moods : LazyVector<Mood> = { [self]
			let vectorOffset : Offset? = self._reader.getOffset(self._objectOffset, propertyIndex: 7)
			let vectorLength = self._reader.getVectorLength(vectorOffset)
			let reader = self._reader
			return LazyVector(count: vectorLength, { [reader] in
				Mood(rawValue: reader.getVectorScalarElement(vectorOffset!, index: $0))
			}) { [reader] in
				reader.setVectorScalarElement(vectorOffset!, index: $0, value: $1.rawValue)
			}
		}()

		public var createEagerVersion : Contact? { return Contact.create(_reader, objectOffset: _objectOffset) }
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : Contact.LazyAccess, t2 : Contact.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset && t1._reader === t2._reader
}

extension Contact {
public struct Fast : Hashable {
	private var buffer : UnsafePointer<UInt8> = nil
	private var myOffset : Offset = 0
	public init(buffer: UnsafePointer<UInt8>, myOffset: Offset){
		self.buffer = buffer
		self.myOffset = myOffset
	}
	public var name : UnsafeBufferPointer<UInt8>? { get { return FlatBufferReaderFast.getStringBuffer(buffer, FlatBufferReaderFast.getOffset(buffer, myOffset, propertyIndex:0)) } }
	public var birthday : Date.Fast? { get { 
		if let offset = FlatBufferReaderFast.getOffset(buffer, myOffset, propertyIndex: 1) {
			return Date.Fast(buffer: buffer, myOffset: offset)
		}
		return nil
	} }
	public var gender : Gender? { 
		get { return Gender(rawValue: FlatBufferReaderFast.get(buffer, myOffset, propertyIndex: 2, defaultValue: Gender.None.rawValue)) }
		set {
			if let newValue = newValue {
				try!FlatBufferReaderFast.set(UnsafeMutablePointer<UInt8>(buffer), myOffset, propertyIndex: 2, value: newValue.rawValue)
			}
		}
	}
	public struct TagsVector {
		private var buffer : UnsafePointer<UInt8> = nil
		private var myOffset : Offset = 0
		private let offsetList : Offset?
		private init(buffer b: UnsafePointer<UInt8>, myOffset o: Offset ) {
			buffer = b
			myOffset = o
			offsetList = FlatBufferReaderFast.getOffset(buffer, myOffset, propertyIndex: 3)
		}
		public var count : Int { get { return FlatBufferReaderFast.getVectorLength(buffer, offsetList) } }
		public subscript (index : Int) -> UnsafeBufferPointer<UInt8>? {
			get {
				if let ofs = FlatBufferReaderFast.getVectorOffsetElement(buffer, offsetList!, index: index) {
					return FlatBufferReaderFast.getStringBuffer(buffer, ofs)
				}
				return nil
			}
		}
	}
	public lazy var tags : TagsVector = TagsVector(buffer: self.buffer, myOffset: self.myOffset)
	public struct AddressEntriesVector {
		private var buffer : UnsafePointer<UInt8> = nil
		private var myOffset : Offset = 0
		private let offsetList : Offset?
		private init(buffer b: UnsafePointer<UInt8>, myOffset o: Offset ) {
			buffer = b
			myOffset = o
			offsetList = FlatBufferReaderFast.getOffset(buffer, myOffset, propertyIndex: 4)
		}
		public var count : Int { get { return FlatBufferReaderFast.getVectorLength(buffer, offsetList) } }
		public subscript (index : Int) -> AddressEntry.Fast? {
			get {
				if let ofs = FlatBufferReaderFast.getVectorOffsetElement(buffer, offsetList!, index: index) {
					return AddressEntry.Fast(buffer: buffer, myOffset: ofs)
				}
				return nil
			}
		}
	}
	public lazy var addressEntries : AddressEntriesVector = AddressEntriesVector(buffer: self.buffer, myOffset: self.myOffset)
	public var currentLoccation : GeoLocation? { 
		get { return FlatBufferReaderFast.get(buffer, myOffset, propertyIndex: 5)}
		set { 
			if let newValue = newValue {
				try!FlatBufferReaderFast.set(UnsafeMutablePointer<UInt8>(buffer), myOffset, propertyIndex: 5, value: newValue)
			}
		}
	}
	public struct PreviousLocationsVector {
		private var buffer : UnsafePointer<UInt8> = nil
		private var myOffset : Offset = 0
		private let offsetList : Offset?
		private init(buffer b: UnsafePointer<UInt8>, myOffset o: Offset ) {
			buffer = b
			myOffset = o
			offsetList = FlatBufferReaderFast.getOffset(buffer, myOffset, propertyIndex: 6)
		}
		public var count : Int { get { return FlatBufferReaderFast.getVectorLength(buffer, offsetList) } }
		public subscript (index : Int) -> GeoLocation? {
			get {
				return FlatBufferReaderFast.getVectorScalarElement(buffer, offsetList!, index: index) as GeoLocation
			}
			set {
				if let newValue = newValue {
					FlatBufferReaderFast.setVectorScalarElement(UnsafeMutablePointer<UInt8>(buffer), offsetList!, index: index, value: newValue)
				}
			}
		}
	}
	public lazy var previousLocations : PreviousLocationsVector = PreviousLocationsVector(buffer: self.buffer, myOffset: self.myOffset)
	public struct MoodsVector {
		private var buffer : UnsafePointer<UInt8> = nil
		private var myOffset : Offset = 0
		private let offsetList : Offset?
		private init(buffer b: UnsafePointer<UInt8>, myOffset o: Offset ) {
			buffer = b
			myOffset = o
			offsetList = FlatBufferReaderFast.getOffset(buffer, myOffset, propertyIndex: 7)
		}
		public var count : Int { get { return FlatBufferReaderFast.getVectorLength(buffer, offsetList) } }
		public subscript (index : Int) -> Mood? {
			get {
				return Mood(rawValue: FlatBufferReaderFast.getVectorScalarElement(buffer, offsetList!, index: index))
			}
			set {
				if let newValue = newValue {
					FlatBufferReaderFast.setVectorScalarElement(UnsafeMutablePointer<UInt8>(buffer), offsetList!, index: index, value: newValue.rawValue)
				}
			}
		}
	}
	public lazy var moods : MoodsVector = MoodsVector(buffer: self.buffer, myOffset: self.myOffset)
	public var hashValue: Int { return Int(myOffset) }
}
}
public func ==(t1 : Contact.Fast, t2 : Contact.Fast) -> Bool {
	return t1.buffer == t2.buffer && t1.myOffset == t2.myOffset
}
public extension Contact {
	private func addToByteArray(builder : FlatBufferBuilder) -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		var offset7 = Offset(0)
		if moods.count > 0{
			try! builder.startVector(moods.count, elementSize: strideof(Mood))
			var index = moods.count - 1
			while(index >= 0){
				builder.put(moods[index]!.rawValue)
				index -= 1
			}
			offset7 = builder.endVector()
		}
		var offset6 = Offset(0)
		if previousLocations.count > 0{
			try! builder.startVector(previousLocations.count, elementSize: strideof(GeoLocation))
			var index = previousLocations.count - 1
			while(index >= 0){
				builder.put(previousLocations[index]!)
				index -= 1
			}
			offset6 = builder.endVector()
		}
		var offset4 = Offset(0)
		if addressEntries.count > 0{
			var offsets = [Offset?](count: addressEntries.count, repeatedValue: nil)
			var index = addressEntries.count - 1
			while(index >= 0){
				offsets[index] = addressEntries[index]?.addToByteArray(builder)
				index -= 1
			}
			try! builder.startVector(addressEntries.count, elementSize: strideof(Offset))
			index = addressEntries.count - 1
			while(index >= 0){
				try! builder.putOffset(offsets[index])
				index -= 1
			}
			offset4 = builder.endVector()
		}
		var offset3 = Offset(0)
		if tags.count > 0{
			var offsets = [Offset?](count: tags.count, repeatedValue: nil)
			var index = tags.count - 1
			while(index >= 0){
				offsets[index] = try!builder.createString(tags[index])
				index -= 1
			}
			try! builder.startVector(tags.count, elementSize: strideof(Offset))
			index = tags.count - 1
			while(index >= 0){
				try! builder.putOffset(offsets[index])
				index -= 1
			}
			offset3 = builder.endVector()
		}
		let offset1 = birthday?.addToByteArray(builder) ?? 0
		// let offset0 = try! builder.createString(name)
		var offset0 : Offset
		if let s = name_b {
			offset0 = try! builder.createString(s)
		} else if let s = name_ss {
			offset0 = try! builder.createStaticString(s)
		} else {
			offset0 = try! builder.createString(name)
		}
		try! builder.openObject(8)
		if moods.count > 0 {
			try! builder.addPropertyOffsetToOpenObject(7, offset: offset7)
		}
		if previousLocations.count > 0 {
			try! builder.addPropertyOffsetToOpenObject(6, offset: offset6)
		}
		if let currentLoccation = currentLoccation {
			builder.put(currentLoccation)
			try! builder.addCurrentOffsetAsPropertyToOpenObject(5)
		}
		if addressEntries.count > 0 {
			try! builder.addPropertyOffsetToOpenObject(4, offset: offset4)
		}
		if tags.count > 0 {
			try! builder.addPropertyOffsetToOpenObject(3, offset: offset3)
		}
		try! builder.addPropertyToOpenObject(2, value : gender!.rawValue, defaultValue : 0)
		if birthday != nil {
			try! builder.addPropertyOffsetToOpenObject(1, offset: offset1)
		}
		try! builder.addPropertyOffsetToOpenObject(0, offset: offset0)
		let myOffset =  try! builder.closeObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
extension Contact {
	public func toJSON() -> String{
		var properties : [String] = []
		if let name = name{
			properties.append("\"name\":\"\(name)\"")
		}
		if let birthday = birthday{
			properties.append("\"birthday\":\(birthday.toJSON())")
		}
		if let gender = gender{
			properties.append("\"gender\":\(gender.toJSON())")
		}
		let tags_List = tags.map({$0 == nil ? "null" : "\"\($0!)\""}).joinWithSeparator(",")
		properties.append("\"tags\":[\(tags_List)]")
		properties.append("\"addressEntries\":[\(addressEntries.map({$0 == nil ? "null" : $0!.toJSON()}).joinWithSeparator(","))]")
		if let currentLoccation = currentLoccation{
			properties.append("\"currentLoccation\":\(currentLoccation.toJSON())")
		}
		properties.append("\"previousLocations\":[\(previousLocations.map({$0 == nil ? "null" : $0!.toJSON()}).joinWithSeparator(","))]")
		properties.append("\"moods\":[\(moods.map({$0 == nil ? "null" : $0!.toJSON()}).joinWithSeparator(","))]")
		
		return "{\(properties.joinWithSeparator(","))}"
	}

	public static func fromJSON(dict : NSDictionary) -> Contact {
		let result = Contact()
		if let name = dict["name"] as? NSString {
			result.name = name as String
		}
		if let birthday = dict["birthday"] as? NSDictionary {
			result.birthday = Date.fromJSON(birthday)
		}
		if let gender = dict["gender"] as? NSString {
			result.gender = Gender.fromJSON(gender as String)
		}
		if let tags = dict["tags"] as? NSArray {
			result.tags = ContiguousArray(tags.map({
				if let entry = $0 as? NSString {
					return entry as String
				}
				return nil
			}))
		}
		if let addressEntries = dict["addressEntries"] as? NSArray {
			result.addressEntries = ContiguousArray(addressEntries.map({
				if let entry = $0 as? NSDictionary {
					return AddressEntry.fromJSON(entry)
				}
				return nil
			}))
		}
		if let currentLoccation = dict["currentLoccation"] as? NSDictionary {
			result.currentLoccation = GeoLocation.fromJSON(currentLoccation)
		}
		if let previousLocations = dict["previousLocations"] as? NSArray {
			result.previousLocations = ContiguousArray(previousLocations.map({
				if let entry = $0 as? NSDictionary {
					return GeoLocation.fromJSON(entry)
				}
				return nil
			}))
		}
		if let moods = dict["moods"] as? NSArray {
			result.moods = ContiguousArray(moods.map({
				if let entry = $0 as? NSString {
					return Mood.fromJSON(entry as String)
				}
				return nil
			}))
		}
		return result
	}
	
	public func jsonTypeName() -> String {
		return "\"Contact\""
	}
}
public final class Date {
	public static var instancePoolMutex : pthread_mutex_t = Date.setupInstancePoolMutex()
	public static var maxInstanceCacheSize : UInt = 0
	public static var instancePool : ContiguousArray<Date> = []
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

extension Date : PoolableInstances {
	public func reset() { 
		day = 0
		month = 0
		year = 0
	}
}
public extension Date {
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> Date? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if reader.config.uniqueTables {
			if let o = reader.objectPool[objectOffset]{
				return o as? Date
			}
		}
		let _result = Date.createInstance()
		if reader.config.uniqueTables {
			reader.objectPool[objectOffset] = _result
		}
		_result.day = reader.get(objectOffset, propertyIndex: 0, defaultValue: 0)
		_result.month = reader.get(objectOffset, propertyIndex: 1, defaultValue: 0)
		_result.year = reader.get(objectOffset, propertyIndex: 2, defaultValue: 0)
		return _result
	}
}
public extension Date {
	public final class LazyAccess : Hashable {
		private let _reader : FlatBufferReader!
		private let _objectOffset : Offset!
		private init?(reader : FlatBufferReader, objectOffset : Offset?){
			guard let objectOffset = objectOffset else {
				_reader = nil
				_objectOffset = nil
				return nil
			}
			_reader = reader
			_objectOffset = objectOffset
		}

		public var day : Int8 { 
			get { return _reader.get(_objectOffset, propertyIndex: 0, defaultValue:0)}
			set { try!_reader.set(_objectOffset, propertyIndex: 0, value: newValue)}
		}
		public var month : Int8 { 
			get { return _reader.get(_objectOffset, propertyIndex: 1, defaultValue:0)}
			set { try!_reader.set(_objectOffset, propertyIndex: 1, value: newValue)}
		}
		public var year : Int16 { 
			get { return _reader.get(_objectOffset, propertyIndex: 2, defaultValue:0)}
			set { try!_reader.set(_objectOffset, propertyIndex: 2, value: newValue)}
		}

		public var createEagerVersion : Date? { return Date.create(_reader, objectOffset: _objectOffset) }
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : Date.LazyAccess, t2 : Date.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset && t1._reader === t2._reader
}

extension Date {
public struct Fast : Hashable {
	private var buffer : UnsafePointer<UInt8> = nil
	private var myOffset : Offset = 0
	public init(buffer: UnsafePointer<UInt8>, myOffset: Offset){
		self.buffer = buffer
		self.myOffset = myOffset
	}
	public var day : Int8 { 
		get { return FlatBufferReaderFast.get(buffer, myOffset, propertyIndex: 0, defaultValue: 0) }
		set { try!FlatBufferReaderFast.set(UnsafeMutablePointer<UInt8>(buffer), myOffset, propertyIndex: 0, value: newValue) }
	}
	public var month : Int8 { 
		get { return FlatBufferReaderFast.get(buffer, myOffset, propertyIndex: 1, defaultValue: 0) }
		set { try!FlatBufferReaderFast.set(UnsafeMutablePointer<UInt8>(buffer), myOffset, propertyIndex: 1, value: newValue) }
	}
	public var year : Int16 { 
		get { return FlatBufferReaderFast.get(buffer, myOffset, propertyIndex: 2, defaultValue: 0) }
		set { try!FlatBufferReaderFast.set(UnsafeMutablePointer<UInt8>(buffer), myOffset, propertyIndex: 2, value: newValue) }
	}
	public var hashValue: Int { return Int(myOffset) }
}
}
public func ==(t1 : Date.Fast, t2 : Date.Fast) -> Bool {
	return t1.buffer == t2.buffer && t1.myOffset == t2.myOffset
}
public extension Date {
	private func addToByteArray(builder : FlatBufferBuilder) -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		try! builder.openObject(3)
		try! builder.addPropertyToOpenObject(2, value : year, defaultValue : 0)
		try! builder.addPropertyToOpenObject(1, value : month, defaultValue : 0)
		try! builder.addPropertyToOpenObject(0, value : day, defaultValue : 0)
		let myOffset =  try! builder.closeObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
extension Date {
	public func toJSON() -> String{
		var properties : [String] = []
		properties.append("\"day\":\(day)")
		properties.append("\"month\":\(month)")
		properties.append("\"year\":\(year)")
		
		return "{\(properties.joinWithSeparator(","))}"
	}

	public static func fromJSON(dict : NSDictionary) -> Date {
		let result = Date()
		if let day = dict["day"] as? NSNumber {
			result.day = day.charValue
		}
		if let month = dict["month"] as? NSNumber {
			result.month = month.charValue
		}
		if let year = dict["year"] as? NSNumber {
			result.year = year.shortValue
		}
		return result
	}
	
	public func jsonTypeName() -> String {
		return "\"Date\""
	}
}
public struct S1 : Scalar {
	public let i : Int32
}
public func ==(v1:S1, v2:S1) -> Bool {
	return  v1.i==v2.i
}

extension S1 {
	public func toJSON() -> String{
		let iProperty = "\"i\":\(i)"
		return "{\(iProperty)}"
	}
	
	public static func fromJSON(dict : NSDictionary) -> S1 {
		return S1(
		i: (dict["i"] as! NSNumber).intValue
		)
	}
}
public struct GeoLocation : Scalar {
	public let latitude : Float64
	public let longitude : Float64
	public let elevation : Float32
	public let s : S1
}
public func ==(v1:GeoLocation, v2:GeoLocation) -> Bool {
	return  v1.latitude==v2.latitude &&  v1.longitude==v2.longitude &&  v1.elevation==v2.elevation &&  v1.s==v2.s
}

extension GeoLocation {
	public func toJSON() -> String{
		let latitudeProperty = "\"latitude\":\(latitude)"
		let longitudeProperty = "\"longitude\":\(longitude)"
		let elevationProperty = "\"elevation\":\(elevation)"
		let sProperty = "\"s\":\(s.toJSON())"
		return "{\(latitudeProperty),\(longitudeProperty),\(elevationProperty),\(sProperty)}"
	}
	
	public static func fromJSON(dict : NSDictionary) -> GeoLocation {
		return GeoLocation(
		latitude: (dict["latitude"] as! NSNumber).doubleValue,
		longitude: (dict["longitude"] as! NSNumber).doubleValue,
		elevation: (dict["elevation"] as! NSNumber).floatValue,
		s: S1.fromJSON(dict["s"] as! NSDictionary)
		)
	}
}
public final class AddressEntry {
	public static var instancePoolMutex : pthread_mutex_t = AddressEntry.setupInstancePoolMutex()
	public static var maxInstanceCacheSize : UInt = 0
	public static var instancePool : ContiguousArray<AddressEntry> = []
	public var order : Int32 = 0
	public var address : Address? = nil
	public init(){}
	public init(order: Int32, address: Address?){
		self.order = order
		self.address = address
	}
}

extension AddressEntry : PoolableInstances {
	public func reset() { 
		order = 0
		address = nil
	}
}
public extension AddressEntry {
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> AddressEntry? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if reader.config.uniqueTables {
			if let o = reader.objectPool[objectOffset]{
				return o as? AddressEntry
			}
		}
		let _result = AddressEntry.createInstance()
		if reader.config.uniqueTables {
			reader.objectPool[objectOffset] = _result
		}
		_result.order = reader.get(objectOffset, propertyIndex: 0, defaultValue: 0)
		_result.address = create_Address(reader, propertyIndex: 1, objectOffset: objectOffset)
		return _result
	}
}
public extension AddressEntry {
	public final class LazyAccess : Hashable {
		private let _reader : FlatBufferReader!
		private let _objectOffset : Offset!
		private init?(reader : FlatBufferReader, objectOffset : Offset?){
			guard let objectOffset = objectOffset else {
				_reader = nil
				_objectOffset = nil
				return nil
			}
			_reader = reader
			_objectOffset = objectOffset
		}

		public var order : Int32 { 
			get { return _reader.get(_objectOffset, propertyIndex: 0, defaultValue:0)}
			set { try!_reader.set(_objectOffset, propertyIndex: 0, value: newValue)}
		}
		public lazy var address : Address_LazyAccess? = create_Address_LazyAccess(self._reader, propertyIndex: 1, objectOffset: self._objectOffset)

		public var createEagerVersion : AddressEntry? { return AddressEntry.create(_reader, objectOffset: _objectOffset) }
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : AddressEntry.LazyAccess, t2 : AddressEntry.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset && t1._reader === t2._reader
}

extension AddressEntry {
public struct Fast : Hashable {
	private var buffer : UnsafePointer<UInt8> = nil
	private var myOffset : Offset = 0
	public init(buffer: UnsafePointer<UInt8>, myOffset: Offset){
		self.buffer = buffer
		self.myOffset = myOffset
	}
	public var order : Int32 { 
		get { return FlatBufferReaderFast.get(buffer, myOffset, propertyIndex: 0, defaultValue: 0) }
		set { try!FlatBufferReaderFast.set(UnsafeMutablePointer<UInt8>(buffer), myOffset, propertyIndex: 0, value: newValue) }
	}
	public var address : Address_Fast? { get { 
		return create_Address_Fast(buffer, propertyIndex: 1, objectOffset: self.myOffset)
	} }
	public var hashValue: Int { return Int(myOffset) }
}
}
public func ==(t1 : AddressEntry.Fast, t2 : AddressEntry.Fast) -> Bool {
	return t1.buffer == t2.buffer && t1.myOffset == t2.myOffset
}
public extension AddressEntry {
	private func addToByteArray(builder : FlatBufferBuilder) -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		let offset1 = addToByteArray_Address(builder, union: address)
		try! builder.openObject(3)
		if address != nil {
			try! builder.addPropertyOffsetToOpenObject(2, offset: offset1)
			try! builder.addPropertyToOpenObject(1, value : unionCase_Address(address), defaultValue : 0)
		}
		try! builder.addPropertyToOpenObject(0, value : order, defaultValue : 0)
		let myOffset =  try! builder.closeObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
extension AddressEntry {
	public func toJSON() -> String{
		var properties : [String] = []
		properties.append("\"order\":\(order)")
		if let address = address{
			properties.append("\"address\":\(address.toJSON()),\"address_type\":\(address.jsonTypeName())")
		}
		
		return "{\(properties.joinWithSeparator(","))}"
	}

	public static func fromJSON(dict : NSDictionary) -> AddressEntry {
		let result = AddressEntry()
		if let order = dict["order"] as? NSNumber {
			result.order = order.intValue
		}
		if let address = dict["address"] as? NSDictionary, let address_type = dict["address_type"] as? NSString {
			result.address = fromJSON_Address(address, typeName: address_type as String)
		}
		return result
	}
	
	public func jsonTypeName() -> String {
		return "\"AddressEntry\""
	}
}
public final class PostalAddress {
	public static var instancePoolMutex : pthread_mutex_t = PostalAddress.setupInstancePoolMutex()
	public static var maxInstanceCacheSize : UInt = 0
	public static var instancePool : ContiguousArray<PostalAddress> = []
	public var country : String? {
		get {
			if let s = country_s {
				return s
			}
			if let s = country_ss {
				country_s = s.stringValue
			}
			if let s = country_b {
				country_s = String.init(bytesNoCopy: UnsafeMutablePointer<UInt8>(s.baseAddress), length: s.count, encoding: NSUTF8StringEncoding, freeWhenDone: false)
			}
			return country_s
		}
		set {
			country_s = newValue
			country_ss = nil
			country_b = nil
		}
	}
	public func countryStaticString(newValue : StaticString) {
		country_ss = newValue
		country_s = nil
		country_b = nil
	}
	private var country_b : UnsafeBufferPointer<UInt8>? = nil
	public var countryBuffer : UnsafeBufferPointer<UInt8>? {return country_b}
	private var country_s : String? = nil
	private var country_ss : StaticString? = nil
	
	public var city : String? {
		get {
			if let s = city_s {
				return s
			}
			if let s = city_ss {
				city_s = s.stringValue
			}
			if let s = city_b {
				city_s = String.init(bytesNoCopy: UnsafeMutablePointer<UInt8>(s.baseAddress), length: s.count, encoding: NSUTF8StringEncoding, freeWhenDone: false)
			}
			return city_s
		}
		set {
			city_s = newValue
			city_ss = nil
			city_b = nil
		}
	}
	public func cityStaticString(newValue : StaticString) {
		city_ss = newValue
		city_s = nil
		city_b = nil
	}
	private var city_b : UnsafeBufferPointer<UInt8>? = nil
	public var cityBuffer : UnsafeBufferPointer<UInt8>? {return city_b}
	private var city_s : String? = nil
	private var city_ss : StaticString? = nil
	
	public var postalCode : Int32 = 0
	public var streetAndNumber : String? {
		get {
			if let s = streetAndNumber_s {
				return s
			}
			if let s = streetAndNumber_ss {
				streetAndNumber_s = s.stringValue
			}
			if let s = streetAndNumber_b {
				streetAndNumber_s = String.init(bytesNoCopy: UnsafeMutablePointer<UInt8>(s.baseAddress), length: s.count, encoding: NSUTF8StringEncoding, freeWhenDone: false)
			}
			return streetAndNumber_s
		}
		set {
			streetAndNumber_s = newValue
			streetAndNumber_ss = nil
			streetAndNumber_b = nil
		}
	}
	public func streetAndNumberStaticString(newValue : StaticString) {
		streetAndNumber_ss = newValue
		streetAndNumber_s = nil
		streetAndNumber_b = nil
	}
	private var streetAndNumber_b : UnsafeBufferPointer<UInt8>? = nil
	public var streetAndNumberBuffer : UnsafeBufferPointer<UInt8>? {return streetAndNumber_b}
	private var streetAndNumber_s : String? = nil
	private var streetAndNumber_ss : StaticString? = nil
	
	public init(){}
	public init(country: String?, city: String?, postalCode: Int32, streetAndNumber: String?){
		self.country_s = country
		self.city_s = city
		self.postalCode = postalCode
		self.streetAndNumber_s = streetAndNumber
	}
	public init(country: StaticString?, city: StaticString?, postalCode: Int32, streetAndNumber: StaticString?){
		self.country_ss = country
		self.city_ss = city
		self.postalCode = postalCode
		self.streetAndNumber_ss = streetAndNumber
	}
}

extension PostalAddress : PoolableInstances {
	public func reset() { 
		country = nil
		city = nil
		postalCode = 0
		streetAndNumber = nil
	}
}
public extension PostalAddress {
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> PostalAddress? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if reader.config.uniqueTables {
			if let o = reader.objectPool[objectOffset]{
				return o as? PostalAddress
			}
		}
		let _result = PostalAddress.createInstance()
		if reader.config.uniqueTables {
			reader.objectPool[objectOffset] = _result
		}
		_result.country_b = reader.getStringBuffer(reader.getOffset(objectOffset, propertyIndex: 0))
		_result.city_b = reader.getStringBuffer(reader.getOffset(objectOffset, propertyIndex: 1))
		_result.postalCode = reader.get(objectOffset, propertyIndex: 2, defaultValue: 0)
		_result.streetAndNumber_b = reader.getStringBuffer(reader.getOffset(objectOffset, propertyIndex: 3))
		return _result
	}
}
public extension PostalAddress {
	public final class LazyAccess : Hashable {
		private let _reader : FlatBufferReader!
		private let _objectOffset : Offset!
		private init?(reader : FlatBufferReader, objectOffset : Offset?){
			guard let objectOffset = objectOffset else {
				_reader = nil
				_objectOffset = nil
				return nil
			}
			_reader = reader
			_objectOffset = objectOffset
		}

		public lazy var country : String? = self._reader.getString(self._reader.getOffset(self._objectOffset, propertyIndex: 0))
		public lazy var city : String? = self._reader.getString(self._reader.getOffset(self._objectOffset, propertyIndex: 1))
		public var postalCode : Int32 { 
			get { return _reader.get(_objectOffset, propertyIndex: 2, defaultValue:0)}
			set { try!_reader.set(_objectOffset, propertyIndex: 2, value: newValue)}
		}
		public lazy var streetAndNumber : String? = self._reader.getString(self._reader.getOffset(self._objectOffset, propertyIndex: 3))

		public var createEagerVersion : PostalAddress? { return PostalAddress.create(_reader, objectOffset: _objectOffset) }
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : PostalAddress.LazyAccess, t2 : PostalAddress.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset && t1._reader === t2._reader
}

extension PostalAddress {
public struct Fast : Hashable {
	private var buffer : UnsafePointer<UInt8> = nil
	private var myOffset : Offset = 0
	public init(buffer: UnsafePointer<UInt8>, myOffset: Offset){
		self.buffer = buffer
		self.myOffset = myOffset
	}
	public var country : UnsafeBufferPointer<UInt8>? { get { return FlatBufferReaderFast.getStringBuffer(buffer, FlatBufferReaderFast.getOffset(buffer, myOffset, propertyIndex:0)) } }
	public var city : UnsafeBufferPointer<UInt8>? { get { return FlatBufferReaderFast.getStringBuffer(buffer, FlatBufferReaderFast.getOffset(buffer, myOffset, propertyIndex:1)) } }
	public var postalCode : Int32 { 
		get { return FlatBufferReaderFast.get(buffer, myOffset, propertyIndex: 2, defaultValue: 0) }
		set { try!FlatBufferReaderFast.set(UnsafeMutablePointer<UInt8>(buffer), myOffset, propertyIndex: 2, value: newValue) }
	}
	public var streetAndNumber : UnsafeBufferPointer<UInt8>? { get { return FlatBufferReaderFast.getStringBuffer(buffer, FlatBufferReaderFast.getOffset(buffer, myOffset, propertyIndex:3)) } }
	public var hashValue: Int { return Int(myOffset) }
}
}
public func ==(t1 : PostalAddress.Fast, t2 : PostalAddress.Fast) -> Bool {
	return t1.buffer == t2.buffer && t1.myOffset == t2.myOffset
}
public extension PostalAddress {
	private func addToByteArray(builder : FlatBufferBuilder) -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		// let offset3 = try! builder.createString(streetAndNumber)
		var offset3 : Offset
		if let s = streetAndNumber_b {
			offset3 = try! builder.createString(s)
		} else if let s = streetAndNumber_ss {
			offset3 = try! builder.createStaticString(s)
		} else {
			offset3 = try! builder.createString(streetAndNumber)
		}
		// let offset1 = try! builder.createString(city)
		var offset1 : Offset
		if let s = city_b {
			offset1 = try! builder.createString(s)
		} else if let s = city_ss {
			offset1 = try! builder.createStaticString(s)
		} else {
			offset1 = try! builder.createString(city)
		}
		// let offset0 = try! builder.createString(country)
		var offset0 : Offset
		if let s = country_b {
			offset0 = try! builder.createString(s)
		} else if let s = country_ss {
			offset0 = try! builder.createStaticString(s)
		} else {
			offset0 = try! builder.createString(country)
		}
		try! builder.openObject(4)
		try! builder.addPropertyOffsetToOpenObject(3, offset: offset3)
		try! builder.addPropertyToOpenObject(2, value : postalCode, defaultValue : 0)
		try! builder.addPropertyOffsetToOpenObject(1, offset: offset1)
		try! builder.addPropertyOffsetToOpenObject(0, offset: offset0)
		let myOffset =  try! builder.closeObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
extension PostalAddress {
	public func toJSON() -> String{
		var properties : [String] = []
		if let country = country{
			properties.append("\"country\":\"\(country)\"")
		}
		if let city = city{
			properties.append("\"city\":\"\(city)\"")
		}
		properties.append("\"postalCode\":\(postalCode)")
		if let streetAndNumber = streetAndNumber{
			properties.append("\"streetAndNumber\":\"\(streetAndNumber)\"")
		}
		
		return "{\(properties.joinWithSeparator(","))}"
	}

	public static func fromJSON(dict : NSDictionary) -> PostalAddress {
		let result = PostalAddress()
		if let country = dict["country"] as? NSString {
			result.country = country as String
		}
		if let city = dict["city"] as? NSString {
			result.city = city as String
		}
		if let postalCode = dict["postalCode"] as? NSNumber {
			result.postalCode = postalCode.intValue
		}
		if let streetAndNumber = dict["streetAndNumber"] as? NSString {
			result.streetAndNumber = streetAndNumber as String
		}
		return result
	}
	
	public func jsonTypeName() -> String {
		return "\"PostalAddress\""
	}
}
public final class EmailAddress {
	public static var instancePoolMutex : pthread_mutex_t = EmailAddress.setupInstancePoolMutex()
	public static var maxInstanceCacheSize : UInt = 0
	public static var instancePool : ContiguousArray<EmailAddress> = []
	public var mailto : String? {
		get {
			if let s = mailto_s {
				return s
			}
			if let s = mailto_ss {
				mailto_s = s.stringValue
			}
			if let s = mailto_b {
				mailto_s = String.init(bytesNoCopy: UnsafeMutablePointer<UInt8>(s.baseAddress), length: s.count, encoding: NSUTF8StringEncoding, freeWhenDone: false)
			}
			return mailto_s
		}
		set {
			mailto_s = newValue
			mailto_ss = nil
			mailto_b = nil
		}
	}
	public func mailtoStaticString(newValue : StaticString) {
		mailto_ss = newValue
		mailto_s = nil
		mailto_b = nil
	}
	private var mailto_b : UnsafeBufferPointer<UInt8>? = nil
	public var mailtoBuffer : UnsafeBufferPointer<UInt8>? {return mailto_b}
	private var mailto_s : String? = nil
	private var mailto_ss : StaticString? = nil
	
	public init(){}
	public init(mailto: String?){
		self.mailto_s = mailto
	}
	public init(mailto: StaticString?){
		self.mailto_ss = mailto
	}
}

extension EmailAddress : PoolableInstances {
	public func reset() { 
		mailto = nil
	}
}
public extension EmailAddress {
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> EmailAddress? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if reader.config.uniqueTables {
			if let o = reader.objectPool[objectOffset]{
				return o as? EmailAddress
			}
		}
		let _result = EmailAddress.createInstance()
		if reader.config.uniqueTables {
			reader.objectPool[objectOffset] = _result
		}
		_result.mailto_b = reader.getStringBuffer(reader.getOffset(objectOffset, propertyIndex: 0))
		return _result
	}
}
public extension EmailAddress {
	public final class LazyAccess : Hashable {
		private let _reader : FlatBufferReader!
		private let _objectOffset : Offset!
		private init?(reader : FlatBufferReader, objectOffset : Offset?){
			guard let objectOffset = objectOffset else {
				_reader = nil
				_objectOffset = nil
				return nil
			}
			_reader = reader
			_objectOffset = objectOffset
		}

		public lazy var mailto : String? = self._reader.getString(self._reader.getOffset(self._objectOffset, propertyIndex: 0))

		public var createEagerVersion : EmailAddress? { return EmailAddress.create(_reader, objectOffset: _objectOffset) }
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : EmailAddress.LazyAccess, t2 : EmailAddress.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset && t1._reader === t2._reader
}

extension EmailAddress {
public struct Fast : Hashable {
	private var buffer : UnsafePointer<UInt8> = nil
	private var myOffset : Offset = 0
	public init(buffer: UnsafePointer<UInt8>, myOffset: Offset){
		self.buffer = buffer
		self.myOffset = myOffset
	}
	public var mailto : UnsafeBufferPointer<UInt8>? { get { return FlatBufferReaderFast.getStringBuffer(buffer, FlatBufferReaderFast.getOffset(buffer, myOffset, propertyIndex:0)) } }
	public var hashValue: Int { return Int(myOffset) }
}
}
public func ==(t1 : EmailAddress.Fast, t2 : EmailAddress.Fast) -> Bool {
	return t1.buffer == t2.buffer && t1.myOffset == t2.myOffset
}
public extension EmailAddress {
	private func addToByteArray(builder : FlatBufferBuilder) -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		// let offset0 = try! builder.createString(mailto)
		var offset0 : Offset
		if let s = mailto_b {
			offset0 = try! builder.createString(s)
		} else if let s = mailto_ss {
			offset0 = try! builder.createStaticString(s)
		} else {
			offset0 = try! builder.createString(mailto)
		}
		try! builder.openObject(1)
		try! builder.addPropertyOffsetToOpenObject(0, offset: offset0)
		let myOffset =  try! builder.closeObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
extension EmailAddress {
	public func toJSON() -> String{
		var properties : [String] = []
		if let mailto = mailto{
			properties.append("\"mailto\":\"\(mailto)\"")
		}
		
		return "{\(properties.joinWithSeparator(","))}"
	}

	public static func fromJSON(dict : NSDictionary) -> EmailAddress {
		let result = EmailAddress()
		if let mailto = dict["mailto"] as? NSString {
			result.mailto = mailto as String
		}
		return result
	}
	
	public func jsonTypeName() -> String {
		return "\"EmailAddress\""
	}
}
public final class WebAddress {
	public static var instancePoolMutex : pthread_mutex_t = WebAddress.setupInstancePoolMutex()
	public static var maxInstanceCacheSize : UInt = 0
	public static var instancePool : ContiguousArray<WebAddress> = []
	public var url : String? {
		get {
			if let s = url_s {
				return s
			}
			if let s = url_ss {
				url_s = s.stringValue
			}
			if let s = url_b {
				url_s = String.init(bytesNoCopy: UnsafeMutablePointer<UInt8>(s.baseAddress), length: s.count, encoding: NSUTF8StringEncoding, freeWhenDone: false)
			}
			return url_s
		}
		set {
			url_s = newValue
			url_ss = nil
			url_b = nil
		}
	}
	public func urlStaticString(newValue : StaticString) {
		url_ss = newValue
		url_s = nil
		url_b = nil
	}
	private var url_b : UnsafeBufferPointer<UInt8>? = nil
	public var urlBuffer : UnsafeBufferPointer<UInt8>? {return url_b}
	private var url_s : String? = nil
	private var url_ss : StaticString? = nil
	
	public init(){}
	public init(url: String?){
		self.url_s = url
	}
	public init(url: StaticString?){
		self.url_ss = url
	}
}

extension WebAddress : PoolableInstances {
	public func reset() { 
		url = nil
	}
}
public extension WebAddress {
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> WebAddress? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if reader.config.uniqueTables {
			if let o = reader.objectPool[objectOffset]{
				return o as? WebAddress
			}
		}
		let _result = WebAddress.createInstance()
		if reader.config.uniqueTables {
			reader.objectPool[objectOffset] = _result
		}
		_result.url_b = reader.getStringBuffer(reader.getOffset(objectOffset, propertyIndex: 0))
		return _result
	}
}
public extension WebAddress {
	public final class LazyAccess : Hashable {
		private let _reader : FlatBufferReader!
		private let _objectOffset : Offset!
		private init?(reader : FlatBufferReader, objectOffset : Offset?){
			guard let objectOffset = objectOffset else {
				_reader = nil
				_objectOffset = nil
				return nil
			}
			_reader = reader
			_objectOffset = objectOffset
		}

		public lazy var url : String? = self._reader.getString(self._reader.getOffset(self._objectOffset, propertyIndex: 0))

		public var createEagerVersion : WebAddress? { return WebAddress.create(_reader, objectOffset: _objectOffset) }
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : WebAddress.LazyAccess, t2 : WebAddress.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset && t1._reader === t2._reader
}

extension WebAddress {
public struct Fast : Hashable {
	private var buffer : UnsafePointer<UInt8> = nil
	private var myOffset : Offset = 0
	public init(buffer: UnsafePointer<UInt8>, myOffset: Offset){
		self.buffer = buffer
		self.myOffset = myOffset
	}
	public var url : UnsafeBufferPointer<UInt8>? { get { return FlatBufferReaderFast.getStringBuffer(buffer, FlatBufferReaderFast.getOffset(buffer, myOffset, propertyIndex:0)) } }
	public var hashValue: Int { return Int(myOffset) }
}
}
public func ==(t1 : WebAddress.Fast, t2 : WebAddress.Fast) -> Bool {
	return t1.buffer == t2.buffer && t1.myOffset == t2.myOffset
}
public extension WebAddress {
	private func addToByteArray(builder : FlatBufferBuilder) -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		// let offset0 = try! builder.createString(url)
		var offset0 : Offset
		if let s = url_b {
			offset0 = try! builder.createString(s)
		} else if let s = url_ss {
			offset0 = try! builder.createStaticString(s)
		} else {
			offset0 = try! builder.createString(url)
		}
		try! builder.openObject(1)
		try! builder.addPropertyOffsetToOpenObject(0, offset: offset0)
		let myOffset =  try! builder.closeObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
extension WebAddress {
	public func toJSON() -> String{
		var properties : [String] = []
		if let url = url{
			properties.append("\"url\":\"\(url)\"")
		}
		
		return "{\(properties.joinWithSeparator(","))}"
	}

	public static func fromJSON(dict : NSDictionary) -> WebAddress {
		let result = WebAddress()
		if let url = dict["url"] as? NSString {
			result.url = url as String
		}
		return result
	}
	
	public func jsonTypeName() -> String {
		return "\"WebAddress\""
	}
}
public final class TelephoneNumber {
	public static var instancePoolMutex : pthread_mutex_t = TelephoneNumber.setupInstancePoolMutex()
	public static var maxInstanceCacheSize : UInt = 0
	public static var instancePool : ContiguousArray<TelephoneNumber> = []
	public var number : String? {
		get {
			if let s = number_s {
				return s
			}
			if let s = number_ss {
				number_s = s.stringValue
			}
			if let s = number_b {
				number_s = String.init(bytesNoCopy: UnsafeMutablePointer<UInt8>(s.baseAddress), length: s.count, encoding: NSUTF8StringEncoding, freeWhenDone: false)
			}
			return number_s
		}
		set {
			number_s = newValue
			number_ss = nil
			number_b = nil
		}
	}
	public func numberStaticString(newValue : StaticString) {
		number_ss = newValue
		number_s = nil
		number_b = nil
	}
	private var number_b : UnsafeBufferPointer<UInt8>? = nil
	public var numberBuffer : UnsafeBufferPointer<UInt8>? {return number_b}
	private var number_s : String? = nil
	private var number_ss : StaticString? = nil
	
	public init(){}
	public init(number: String?){
		self.number_s = number
	}
	public init(number: StaticString?){
		self.number_ss = number
	}
}

extension TelephoneNumber : PoolableInstances {
	public func reset() { 
		number = nil
	}
}
public extension TelephoneNumber {
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> TelephoneNumber? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if reader.config.uniqueTables {
			if let o = reader.objectPool[objectOffset]{
				return o as? TelephoneNumber
			}
		}
		let _result = TelephoneNumber.createInstance()
		if reader.config.uniqueTables {
			reader.objectPool[objectOffset] = _result
		}
		_result.number_b = reader.getStringBuffer(reader.getOffset(objectOffset, propertyIndex: 0))
		return _result
	}
}
public extension TelephoneNumber {
	public final class LazyAccess : Hashable {
		private let _reader : FlatBufferReader!
		private let _objectOffset : Offset!
		private init?(reader : FlatBufferReader, objectOffset : Offset?){
			guard let objectOffset = objectOffset else {
				_reader = nil
				_objectOffset = nil
				return nil
			}
			_reader = reader
			_objectOffset = objectOffset
		}

		public lazy var number : String? = self._reader.getString(self._reader.getOffset(self._objectOffset, propertyIndex: 0))

		public var createEagerVersion : TelephoneNumber? { return TelephoneNumber.create(_reader, objectOffset: _objectOffset) }
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : TelephoneNumber.LazyAccess, t2 : TelephoneNumber.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset && t1._reader === t2._reader
}

extension TelephoneNumber {
public struct Fast : Hashable {
	private var buffer : UnsafePointer<UInt8> = nil
	private var myOffset : Offset = 0
	public init(buffer: UnsafePointer<UInt8>, myOffset: Offset){
		self.buffer = buffer
		self.myOffset = myOffset
	}
	public var number : UnsafeBufferPointer<UInt8>? { get { return FlatBufferReaderFast.getStringBuffer(buffer, FlatBufferReaderFast.getOffset(buffer, myOffset, propertyIndex:0)) } }
	public var hashValue: Int { return Int(myOffset) }
}
}
public func ==(t1 : TelephoneNumber.Fast, t2 : TelephoneNumber.Fast) -> Bool {
	return t1.buffer == t2.buffer && t1.myOffset == t2.myOffset
}
public extension TelephoneNumber {
	private func addToByteArray(builder : FlatBufferBuilder) -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		// let offset0 = try! builder.createString(number)
		var offset0 : Offset
		if let s = number_b {
			offset0 = try! builder.createString(s)
		} else if let s = number_ss {
			offset0 = try! builder.createStaticString(s)
		} else {
			offset0 = try! builder.createString(number)
		}
		try! builder.openObject(1)
		try! builder.addPropertyOffsetToOpenObject(0, offset: offset0)
		let myOffset =  try! builder.closeObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
extension TelephoneNumber {
	public func toJSON() -> String{
		var properties : [String] = []
		if let number = number{
			properties.append("\"number\":\"\(number)\"")
		}
		
		return "{\(properties.joinWithSeparator(","))}"
	}

	public static func fromJSON(dict : NSDictionary) -> TelephoneNumber {
		let result = TelephoneNumber()
		if let number = dict["number"] as? NSString {
			result.number = number as String
		}
		return result
	}
	
	public func jsonTypeName() -> String {
		return "\"TelephoneNumber\""
	}
}
public protocol Address{
	static func fromJSON(dict : NSDictionary) -> Self
	func toJSON() -> String
	func jsonTypeName() -> String
}
public protocol Address_LazyAccess{}
public protocol Address_Fast{}
extension PostalAddress : Address {}
extension PostalAddress.LazyAccess : Address_LazyAccess {}
extension PostalAddress.Fast : Address_Fast {}
extension EmailAddress : Address {}
extension EmailAddress.LazyAccess : Address_LazyAccess {}
extension EmailAddress.Fast : Address_Fast {}
extension WebAddress : Address {}
extension WebAddress.LazyAccess : Address_LazyAccess {}
extension WebAddress.Fast : Address_Fast {}
extension TelephoneNumber : Address {}
extension TelephoneNumber.LazyAccess : Address_LazyAccess {}
extension TelephoneNumber.Fast : Address_Fast {}
private func create_Address(reader : FlatBufferReader, propertyIndex : Int, objectOffset : Offset?) -> Address? {
	guard let objectOffset = objectOffset else {
		return nil
	}
	let unionCase : Int8 = reader.get(objectOffset, propertyIndex: propertyIndex, defaultValue: 0)
	guard let caseObjectOffset : Offset = reader.getOffset(objectOffset, propertyIndex:propertyIndex + 1) else {
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
private func fromJSON_Address(dict : NSDictionary, typeName : String) -> Address? {
	switch typeName {
	case "PostalAddress" : return PostalAddress.fromJSON(dict)
	case "EmailAddress" : return EmailAddress.fromJSON(dict)
	case "WebAddress" : return WebAddress.fromJSON(dict)
	case "TelephoneNumber" : return TelephoneNumber.fromJSON(dict)
	default : return nil
	}
}
private func create_Address_LazyAccess(reader : FlatBufferReader, propertyIndex : Int, objectOffset : Offset?) -> Address_LazyAccess? {
	guard let objectOffset = objectOffset else {
		return nil
	}
	let unionCase : Int8 = reader.get(objectOffset, propertyIndex: propertyIndex, defaultValue: 0)
	guard let caseObjectOffset : Offset = reader.getOffset(objectOffset, propertyIndex:propertyIndex + 1) else {
		return nil
	}
	switch unionCase {
	case 1 : return PostalAddress.LazyAccess(reader: reader, objectOffset: caseObjectOffset)
	case 2 : return EmailAddress.LazyAccess(reader: reader, objectOffset: caseObjectOffset)
	case 3 : return WebAddress.LazyAccess(reader: reader, objectOffset: caseObjectOffset)
	case 4 : return TelephoneNumber.LazyAccess(reader: reader, objectOffset: caseObjectOffset)
	default : return nil
	}
}
private func create_Address_Fast(buffer : UnsafePointer<UInt8>, propertyIndex : Int, objectOffset : Offset?) -> Address_Fast? {
	guard let objectOffset = objectOffset else {
		return nil
	}
	let unionCase : Int8 = FlatBufferReaderFast.get(buffer, objectOffset, propertyIndex: propertyIndex, defaultValue: 0)
	guard let caseObjectOffset : Offset = FlatBufferReaderFast.getOffset(buffer, objectOffset, propertyIndex:propertyIndex + 1) else {
		return nil
	}
	switch unionCase {
	case 1 : return PostalAddress.Fast(buffer: buffer, myOffset: caseObjectOffset)
	case 2 : return EmailAddress.Fast(buffer: buffer, myOffset: caseObjectOffset)
	case 3 : return WebAddress.Fast(buffer: buffer, myOffset: caseObjectOffset)
	case 4 : return TelephoneNumber.Fast(buffer: buffer, myOffset: caseObjectOffset)
	default : return nil
	}
}
private func unionCase_Address(union : Address?) -> Int8 {
	switch union {
	case is PostalAddress : return 1
	case is EmailAddress : return 2
	case is WebAddress : return 3
	case is TelephoneNumber : return 4
	default : return 0
	}
}
private func addToByteArray_Address(builder : FlatBufferBuilder, union : Address?) -> Offset {
	switch union {
	case let u as PostalAddress : return u.addToByteArray(builder)
	case let u as EmailAddress : return u.addToByteArray(builder)
	case let u as WebAddress : return u.addToByteArray(builder)
	case let u as TelephoneNumber : return u.addToByteArray(builder)
	default : return 0
	}
}
private func performLateBindings(builder : FlatBufferBuilder) {
	for binding in builder.deferedBindings {
		switch binding.object {
		case let object as ContactList: try! builder.replaceOffset(object.addToByteArray(builder), atCursor: binding.cursor)
		case let object as Contact: try! builder.replaceOffset(object.addToByteArray(builder), atCursor: binding.cursor)
		case let object as Date: try! builder.replaceOffset(object.addToByteArray(builder), atCursor: binding.cursor)
		case let object as AddressEntry: try! builder.replaceOffset(object.addToByteArray(builder), atCursor: binding.cursor)
		case let object as PostalAddress: try! builder.replaceOffset(object.addToByteArray(builder), atCursor: binding.cursor)
		case let object as EmailAddress: try! builder.replaceOffset(object.addToByteArray(builder), atCursor: binding.cursor)
		case let object as WebAddress: try! builder.replaceOffset(object.addToByteArray(builder), atCursor: binding.cursor)
		case let object as TelephoneNumber: try! builder.replaceOffset(object.addToByteArray(builder), atCursor: binding.cursor)
		default: continue
		}
	}
}
// MARK: Generic Type Definitions
public typealias Offset = Int32

public protocol Scalar : Equatable {}

extension Bool : Scalar {}
extension Int8 : Scalar {}
extension UInt8 : Scalar {}
extension Int16 : Scalar {}
extension UInt16 : Scalar {}
extension Int32 : Scalar {}
extension UInt32 : Scalar {}
extension Int64 : Scalar {}
extension UInt64 : Scalar {}
extension Int : Scalar {}
extension UInt : Scalar {}
extension Float32 : Scalar {}
extension Float64 : Scalar {}

public protocol PoolableInstances : AnyObject {
    static var maxInstanceCacheSize : UInt { get set }
    static var instancePool : ContiguousArray<Self> { get set }
    static var instancePoolMutex : pthread_mutex_t { get set } /// Should be initialized to setupInstancePoolMutex
    init()
    func reset()
}

public extension PoolableInstances {
    
    // Must be called to initialize mutex
    public static func setupInstancePoolMutex() -> pthread_mutex_t
    {
        var mtx = pthread_mutex_t()
        pthread_mutex_init(&mtx, nil)
        return mtx
    }
    
    // Optional preheat of instance pool
    public static func fillInstancePool(initialPoolSize : UInt) -> Void {
        pthread_mutex_lock(&instancePoolMutex)
        defer { pthread_mutex_unlock(&instancePoolMutex) }

        while ((UInt(instancePool.count) < initialPoolSize) && (UInt(instancePool.count) < maxInstanceCacheSize))
        {
            instancePool.append(Self())
        }
    }
    
    public static func createInstance() -> Self {
        guard maxInstanceCacheSize > 0 else // avoid taking the mutex if not using pool
        {
            return Self()
        }
        
        pthread_mutex_lock(&instancePoolMutex)
        defer { pthread_mutex_unlock(&instancePoolMutex) }

        if (instancePool.count > 0)
        {
            let instance = instancePool.removeLast()
            return instance
        }
        return Self()
    }
    
    // reuseInstance can be called when we believe we are about to zero out
    // the final strong reference we hold ourselves to put the instance in for reuse
    public static func reuseInstance(inout instance : Self) {
        guard maxInstanceCacheSize > 0 else // avoid taking the mutex if not using pool
        {
            return // don't pool
        }

        pthread_mutex_lock(&instancePoolMutex)
        defer { pthread_mutex_unlock(&instancePoolMutex) }
        
        if (isUniquelyReferencedNonObjC(&instance) && (UInt(instancePool.count) < maxInstanceCacheSize))
        {
            instance.reset()
            instancePool.append(instance)
        }
    }
}



public final class LazyVector<T> : SequenceType {
    
    private let _generator : (Int)->T?
    private let _replacer : ((Int, T)->())?
    private let _count : Int
    
    public init(count : Int, _ generator : (Int)->T?){
        _generator = generator
        _count = count
        _replacer = nil
    }
    
    public init(count : Int, _ generator : (Int)->T?, _ replacer: ((Int, T)->())? = nil){
        _generator = generator
        _count = count
        _replacer = replacer
    }
    
    public subscript(i: Int) -> T? {
        get {
            guard i >= 0 && i < _count else {
                return nil
            }
            return _generator(i)
        }
        set {
            guard let replacer = _replacer, let value = newValue else {
                return
            }
            guard i >= 0 && i < _count else {
                return
            }
            replacer(i, value)
        }
    }
    
    public var count : Int {return _count}
    
    public func generate() -> AnyGenerator<T> {
        var index = 0
        
        return AnyGenerator(body: { [self]
            let value = self[index]
            index += 1
            return value
        })
    }
}

public struct BinaryBuildConfig{
    public let initialCapacity : Int
    public let uniqueStrings : Bool
    public let uniqueTables : Bool
    public let uniqueVTables : Bool
    public let forceDefaults : Bool
    public let fullMemoryAlignment : Bool
    public let nullTerminatedUTF8 : Bool
    public init(initialCapacity : Int = 1, uniqueStrings : Bool = true, uniqueTables : Bool = true, uniqueVTables : Bool = true, forceDefaults : Bool = false, fullMemoryAlignment: Bool = false, nullTerminatedUTF8 : Bool = false) {
        self.initialCapacity = initialCapacity
        self.uniqueStrings = uniqueStrings
        self.uniqueTables = uniqueTables
        self.uniqueVTables = uniqueVTables
        self.forceDefaults = forceDefaults
        self.fullMemoryAlignment = fullMemoryAlignment
        self.nullTerminatedUTF8 = nullTerminatedUTF8
    }
}


public struct BinaryReadConfig {
    public let uniqueTables : Bool
    public let uniqueStrings : Bool
    public init(uniqueStrings : Bool = true, uniqueTables : Bool = true) {
        self.uniqueStrings = uniqueStrings
        self.uniqueTables = uniqueTables
    }
}

// MARK: Reader
public enum FlatBufferReaderError : ErrorType {
    case CanOnlySetNonDefaultProperty
}

public final class FlatBufferReader {

    public static var maxInstanceCacheSize : UInt = 0 // max number of cached instances
    static var instancePool : [FlatBufferReader] = []
    
    public var config : BinaryReadConfig
    
    var buffer : UnsafeMutablePointer<UInt8> = nil
    public var objectPool : [Offset : AnyObject] = [:]
    
    func fromByteArray<T : Scalar>(position : Int) -> T{
        return UnsafePointer<T>(buffer.advancedBy(position)).memory
    }
    
    private var length : Int
    public var data : [UInt8] {
        return Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(buffer), count: length))
    }

    public init(buffer : [UInt8], config: BinaryReadConfig){
        self.buffer = UnsafeMutablePointer<UInt8>(buffer)
        self.config = config
        length = buffer.count
    }
    
    public init(bytes : UnsafeBufferPointer<UInt8>, config: BinaryReadConfig){
        self.buffer = UnsafeMutablePointer<UInt8>(bytes.baseAddress)
        self.config = config
        length = bytes.count
    }

    public init(bytes : UnsafeMutablePointer<UInt8>, count : Int, config: BinaryReadConfig){
        self.buffer = bytes
        self.config = config
        length = count
    }

    public var rootObjectOffset : Offset {
        let offset : Int32 = fromByteArray(0)
        return offset
    }
    
    public func get<T : Scalar>(objectOffset : Offset, propertyIndex : Int, defaultValue : T) -> T{
        let propertyOffset = getPropertyOffset(objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return defaultValue
        }
        let position = Int(objectOffset + propertyOffset)
        return fromByteArray(position)
    }
    
    public func get<T : Scalar>(objectOffset : Offset, propertyIndex : Int) -> T?{
        let propertyOffset = getPropertyOffset(objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return nil
        }
        let position = Int(objectOffset + propertyOffset)
        return fromByteArray(position) as T
    }
    
    public func set<T : Scalar>(objectOffset : Offset, propertyIndex : Int, value : T) throws {
        let propertyOffset = getPropertyOffset(objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            throw FlatBufferReaderError.CanOnlySetNonDefaultProperty
        }
        var v = value
        let position = Int(objectOffset + propertyOffset)
        let c = strideofValue(v)
        withUnsafePointer(&v){
            buffer.advancedBy(position).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
    }
    
    public func hasProperty(objectOffset : Offset, propertyIndex : Int) -> Bool {
        return getPropertyOffset(objectOffset, propertyIndex: propertyIndex) != 0
    }
    
    public func getOffset(objectOffset : Offset, propertyIndex : Int) -> Offset?{
        let propertyOffset = getPropertyOffset(objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return nil
        }
        let position = objectOffset + propertyOffset
        let localObjectOffset : Int32 = fromByteArray(Int(position))
        let offset = position + localObjectOffset
        
        if localObjectOffset == 0 {
            return nil
        }
        return offset
    }
    
    var stringCache : [Int32:String] = [:]
    
    public func getString(stringOffset : Offset?) -> String? {
        guard let stringOffset = stringOffset else {
            return nil
        }
        if config.uniqueStrings {
            if let result = stringCache[stringOffset]{
                return result
            }
        }
        
        let stringPosition = Int(stringOffset)
        let stringLength : Int32 = fromByteArray(stringPosition)
        
        let pointer = UnsafeMutablePointer<UInt8>(buffer).advancedBy((stringPosition + strideof(Int32)))
        let result = String.init(bytesNoCopy: pointer, length: Int(stringLength), encoding: NSUTF8StringEncoding, freeWhenDone: false)
        
        if config.uniqueStrings {
            stringCache[stringOffset] = result
        }
        return result
    }
    
    public func getStringBuffer(stringOffset : Offset?) -> UnsafeBufferPointer<UInt8>? {
        guard let stringOffset = stringOffset else {
            return nil
        }
        let stringPosition = Int(stringOffset)
        let stringLength : Int32 = fromByteArray(stringPosition)
        let pointer = UnsafePointer<UInt8>(buffer).advancedBy((stringPosition + strideof(Int32)))
        return UnsafeBufferPointer<UInt8>.init(start: pointer, count: Int(stringLength))
    }
    
    public func getVectorLength(vectorOffset : Offset?) -> Int {
        guard let vectorOffset = vectorOffset else {
            return 0
        }
        let vectorPosition = Int(vectorOffset)
        let length2 : Int32 = fromByteArray(vectorPosition)
        return Int(length2)
    }
    
    public func getVectorScalarElement<T : Scalar>(vectorOffset : Offset, index : Int) -> T {
        let valueStartPosition = Int(vectorOffset + strideof(Int32) + (index * strideof(T)))
        return UnsafePointer<T>(UnsafePointer<UInt8>(buffer).advancedBy(valueStartPosition)).memory
    }
    
    public func setVectorScalarElement<T : Scalar>(vectorOffset : Offset, index : Int, value : T) {
        let valueStartPosition = Int(vectorOffset + strideof(Int32) + (index * strideof(T)))
        var v = value
        let c = strideofValue(v)
        withUnsafePointer(&v){
            buffer.advancedBy(valueStartPosition).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
    }
    
    public func getVectorOffsetElement(vectorOffset : Offset, index : Int) -> Offset? {
        let valueStartPosition = Int(vectorOffset + strideof(Int32) + (index * strideof(Int32)))
        let localOffset : Int32 = fromByteArray(valueStartPosition)
        if(localOffset == 0){
            return nil
        }
        return localOffset + valueStartPosition
    }
    
    private func getPropertyOffset(objectOffset : Offset, propertyIndex : Int)->Int {
        let offset = Int(objectOffset)
        let localOffset : Int32 = fromByteArray(offset)
        let vTableOffset : Int = offset - Int(localOffset)
        let vTableLength : Int16 = fromByteArray(vTableOffset)
        if(vTableLength<=Int16(4 + propertyIndex * 2)) {
            return 0
        }
        let propertyStart = vTableOffset + 4 + (2 * propertyIndex)
        
        let propertyOffset : Int16 = fromByteArray(propertyStart)
        return Int(propertyOffset)
    }
}

public extension FlatBufferReader {
    public func reset ()
    {
        buffer = nil
        objectPool.removeAll(keepCapacity: true)
        stringCache.removeAll(keepCapacity: true)
        length = 0
    }
    
    public static func create(buffer : [UInt8], config: BinaryReadConfig) -> FlatBufferReader {
        objc_sync_enter(instancePool)
        defer { objc_sync_exit(instancePool) }

        if (instancePool.count > 0)
        {
            let reader = instancePool.removeLast()
            
            reader.buffer = UnsafeMutablePointer<UInt8>(buffer)
            reader.config = config
            reader.length = buffer.count
            
            return reader
        }
        
        return FlatBufferReader(buffer: buffer, config: config)
    }
    
    public static func create(bytes : UnsafeBufferPointer<UInt8>, config: BinaryReadConfig) -> FlatBufferReader {
        objc_sync_enter(instancePool)
        defer { objc_sync_exit(instancePool) }

        if (instancePool.count > 0)
        {
            let reader = instancePool.removeLast()
            
            reader.buffer = UnsafeMutablePointer(bytes.baseAddress)
            reader.config = config
            reader.length = bytes.count
            
            return reader
        }
        
        return FlatBufferReader(bytes: bytes, config: config)
    }
    
    public static func create(bytes : UnsafeMutablePointer<UInt8>, count : Int, config: BinaryReadConfig) -> FlatBufferReader {
        objc_sync_enter(instancePool)
        defer { objc_sync_exit(instancePool) }

        if (instancePool.count > 0)
        {
            let reader = instancePool.removeLast()
            
            reader.buffer = bytes
            reader.config = config
            reader.length = count
            
            return reader
        }
        
        return FlatBufferReader(bytes: bytes, count: count, config: config)
    }

    public static func reuse(reader : FlatBufferReader) {
        objc_sync_enter(instancePool)
        defer { objc_sync_exit(instancePool) }

        if (UInt(instancePool.count) < maxInstanceCacheSize)
        {
            reader.reset()
            instancePool.append(reader)
        }
    }
}


// MARK: Fast Reader

public final class FlatBufferReaderFast {

    public static func fromByteArray<T : Scalar>(buffer : UnsafePointer<UInt8>, _ position : Int) -> T{
        return UnsafePointer<T>(buffer.advancedBy(position)).memory
    }

    public static func getPropertyOffset(buffer : UnsafePointer<UInt8>, _ objectOffset : Offset, propertyIndex : Int)->Int {
        let offset = Int(objectOffset)
        let localOffset : Int32 = fromByteArray(buffer, offset)
        let vTableOffset : Int = offset - Int(localOffset)
        let vTableLength : Int16 = fromByteArray(buffer, vTableOffset)
        if(vTableLength<=Int16(4 + propertyIndex * 2)) {
            return 0
        }
        let propertyStart = vTableOffset + 4 + (2 * propertyIndex)

        let propertyOffset : Int16 = fromByteArray(buffer, propertyStart)
        return Int(propertyOffset)
    }

    public static func getOffset(buffer : UnsafePointer<UInt8>, _ objectOffset : Offset, propertyIndex : Int) -> Offset?{
        let propertyOffset = getPropertyOffset(buffer, objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return nil
        }
        let position = objectOffset + propertyOffset
        let localObjectOffset : Int32 = fromByteArray(buffer, Int(position))
        let offset = position + localObjectOffset

        if localObjectOffset == 0 {
            return nil
        }
        return offset
    }

    public static func getVectorLength(buffer : UnsafePointer<UInt8>, _ vectorOffset : Offset?) -> Int {
        guard let vectorOffset = vectorOffset else {
            return 0
        }
        let vectorPosition = Int(vectorOffset)
        let length2 : Int32 = fromByteArray(buffer, vectorPosition)
        return Int(length2)
    }

    public static func getVectorOffsetElement(buffer : UnsafePointer<UInt8>, _ vectorOffset : Offset, index : Int) -> Offset? {
        let valueStartPosition = Int(vectorOffset + strideof(Int32) + (index * strideof(Int32)))
        let localOffset : Int32 = fromByteArray(buffer, valueStartPosition)
        if(localOffset == 0){
            return nil
        }
        return localOffset + valueStartPosition
    }

    public static func getVectorScalarElement<T : Scalar>(buffer : UnsafePointer<UInt8>, _ vectorOffset : Offset, index : Int) -> T {
        let valueStartPosition = Int(vectorOffset + strideof(Int32) + (index * strideof(T)))
        return UnsafePointer<T>(UnsafePointer<UInt8>(buffer).advancedBy(valueStartPosition)).memory
    }

    public static func get<T : Scalar>(buffer : UnsafePointer<UInt8>, _ objectOffset : Offset, propertyIndex : Int, defaultValue : T) -> T{
        let propertyOffset = getPropertyOffset(buffer, objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return defaultValue
        }
        let position = Int(objectOffset + propertyOffset)
        return fromByteArray(buffer, position)
    }

    public static func get<T : Scalar>(buffer : UnsafePointer<UInt8>, _ objectOffset : Offset, propertyIndex : Int) -> T?{
        let propertyOffset = getPropertyOffset(buffer, objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return nil
        }
        let position = Int(objectOffset + propertyOffset)
        return fromByteArray(buffer, position) as T
    }

    public static func getStringBuffer(buffer : UnsafePointer<UInt8>, _ stringOffset : Offset?) -> UnsafeBufferPointer<UInt8>? {
        guard let stringOffset = stringOffset else {
            return nil
        }
        let stringPosition = Int(stringOffset)
        let stringLength : Int32 = fromByteArray(buffer, stringPosition)
        let pointer = UnsafePointer<UInt8>(buffer).advancedBy((stringPosition + strideof(Int32)))
        return UnsafeBufferPointer<UInt8>.init(start: pointer, count: Int(stringLength))
    }

    public static func getString(buffer : UnsafePointer<UInt8>, _ stringOffset : Offset?) -> String? {
        guard let stringOffset = stringOffset else {
            return nil
        }
        let stringPosition = Int(stringOffset)
        let stringLength : Int32 = fromByteArray(buffer, stringPosition)

        let pointer = UnsafeMutablePointer<UInt8>(buffer).advancedBy((stringPosition + strideof(Int32)))
        let result = String.init(bytesNoCopy: pointer, length: Int(stringLength), encoding: NSUTF8StringEncoding, freeWhenDone: false)

        return result
    }

    public static func set<T : Scalar>(buffer : UnsafeMutablePointer<UInt8>, _ objectOffset : Offset, propertyIndex : Int, value : T) throws {
        let propertyOffset = getPropertyOffset(buffer, objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            throw FlatBufferReaderError.CanOnlySetNonDefaultProperty
        }
        var v = value
        let position = Int(objectOffset + propertyOffset)
        let c = strideofValue(v)
        withUnsafePointer(&v){
            buffer.advancedBy(position).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
    }

    public static func setVectorScalarElement<T : Scalar>(buffer : UnsafeMutablePointer<UInt8>, _ vectorOffset : Offset, index : Int, value : T) {
        let valueStartPosition = Int(vectorOffset + strideof(Int32) + (index * strideof(T)))
        var v = value
        let c = strideofValue(v)
        withUnsafePointer(&v){
            buffer.advancedBy(valueStartPosition).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
    }
}






public final class FlatBufferFileReader {
    
    public var config : BinaryReadConfig
    
    let fileHandle : NSFileHandle
    public var objectPool : [Offset : AnyObject] = [:]
    
    func fromByteArray<T : Scalar>(position : Int) -> T{
        fileHandle.seekToFileOffset(UInt64(position))
        return UnsafePointer<T>(fileHandle.readDataOfLength(strideof(T)).bytes).memory
    }
    
    public init(filePath : String, config: BinaryReadConfig){
        self.config = config
        fileHandle = NSFileHandle.init(forUpdatingAtPath: filePath)!
    }
    
    public var rootObjectOffset : Offset {
        let offset : Int32 = fromByteArray(0)
        return offset
    }
    
    public func get<T : Scalar>(objectOffset : Offset, propertyIndex : Int, defaultValue : T) -> T{
        let propertyOffset = getPropertyOffset(objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return defaultValue
        }
        let position = Int(objectOffset + propertyOffset)
        return fromByteArray(position)
    }
    
    public func get<T : Scalar>(objectOffset : Offset, propertyIndex : Int) -> T?{
        let propertyOffset = getPropertyOffset(objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return nil
        }
        let position = Int(objectOffset + propertyOffset)
        return fromByteArray(position) as T
    }
    
    public func hasProperty(objectOffset : Offset, propertyIndex : Int) -> Bool {
        return getPropertyOffset(objectOffset, propertyIndex: propertyIndex) != 0
    }
    
    public func getOffset(objectOffset : Offset, propertyIndex : Int) -> Offset?{
        let propertyOffset = getPropertyOffset(objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return nil
        }
        let position = objectOffset + propertyOffset
        let localObjectOffset : Int32 = fromByteArray(Int(position))
        let offset = position + localObjectOffset
        
        if localObjectOffset == 0 {
            return nil
        }
        return offset
    }
    
    var stringCache : [Int32:String] = [:]
    
    public func getString(stringOffset : Offset?) -> String? {
        guard let stringOffset = stringOffset else {
            return nil
        }
        if config.uniqueStrings {
            if let result = stringCache[stringOffset]{
                return result
            }
        }
        
        let stringPosition = Int(stringOffset)
        let stringLength : Int32 = fromByteArray(stringPosition)
        
        fileHandle.seekToFileOffset(UInt64(stringPosition + strideof(Int32)))
        let pointer = UnsafeMutablePointer<UInt8>(fileHandle.readDataOfLength(Int(stringLength)).bytes)
        let result = String.init(bytesNoCopy: pointer, length: Int(stringLength), encoding: NSUTF8StringEncoding, freeWhenDone: false)
        
        if config.uniqueStrings {
            stringCache[stringOffset] = result
        }
        return result
    }
    
    public func getStringBuffer(stringOffset : Offset?) -> UnsafeBufferPointer<UInt8>? {
        guard let stringOffset = stringOffset else {
            return nil
        }
        let stringPosition = Int(stringOffset)
        let stringLength : Int32 = fromByteArray(stringPosition)
        
        fileHandle.seekToFileOffset(UInt64(stringPosition + strideof(Int32)))
        let pointer = UnsafeMutablePointer<UInt8>(fileHandle.readDataOfLength(Int(stringLength)).bytes)
        return UnsafeBufferPointer<UInt8>.init(start: pointer, count: Int(stringLength))
    }
    
    public func getVectorLength(vectorOffset : Offset?) -> Int {
        guard let vectorOffset = vectorOffset else {
            return 0
        }
        let vectorPosition = Int(vectorOffset)
        let length2 : Int32 = fromByteArray(vectorPosition)
        return Int(length2)
    }
    
    public func getVectorScalarElement<T : Scalar>(vectorOffset : Offset, index : Int) -> T {
        let valueStartPosition = Int(vectorOffset + strideof(Int32) + (index * strideof(T)))
        fileHandle.seekToFileOffset(UInt64(valueStartPosition))
        
        return UnsafePointer<T>(fileHandle.readDataOfLength(strideof(T)).bytes).memory
    }
    
    public func getVectorOffsetElement(vectorOffset : Offset, index : Int) -> Offset? {
        let valueStartPosition = Int(vectorOffset + strideof(Int32) + (index * strideof(Int32)))
        let localOffset : Int32 = fromByteArray(valueStartPosition)
        if(localOffset == 0){
            return nil
        }
        return localOffset + valueStartPosition
    }
    
    private func getPropertyOffset(objectOffset : Offset, propertyIndex : Int)->Int {
        let offset = Int(objectOffset)
        let localOffset : Int32 = fromByteArray(offset)
        let vTableOffset : Int = offset - Int(localOffset)
        let vTableLength : Int16 = fromByteArray(vTableOffset)
        if(vTableLength<=Int16(4 + propertyIndex * 2)) {
            return 0
        }
        let propertyStart = vTableOffset + 4 + (2 * propertyIndex)
        
        let propertyOffset : Int16 = fromByteArray(propertyStart)
        return Int(propertyOffset)
    }
}

// MARK: Builder
public enum FlatBufferBuilderError : ErrorType {
    case ObjectIsNotClosed
    case NoOpenObject
    case PropertyIndexIsInvalid
    case OffsetIsTooBig
    case CursorIsInvalid
    case BadFileIdentifier
    case UnsupportedType
}

public final class FlatBufferBuilder {
    
    public static var maxInstanceCacheSize : UInt = 0 // max number of cached instances
    static var instancePool : [FlatBufferBuilder] = []
    
    public var cache : [ObjectIdentifier : Offset] = [:]
    public var inProgress : Set<ObjectIdentifier> = []
    public var deferedBindings : ContiguousArray<(object:Any, cursor:Int)> = []
    
    public var config : BinaryBuildConfig
    
    var capacity : Int
    private var _data : UnsafeMutablePointer<UInt8>
    public var _dataCount : Int { return cursor } // count of bytes in unsafe buffer
    public var _dataStart : UnsafeMutablePointer<UInt8> { return _data.advancedBy(leftCursor) } // start of actual raw unsafe buffer data
    public var data : [UInt8] {
        return Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(_data).advancedBy(leftCursor), count: cursor))
    }
    var cursor = 0
    var leftCursor : Int {
        return capacity - cursor
    }
    
    var currentVTable : ContiguousArray<Int32> = []
    var objectStart : Int32 = -1
    var vectorNumElems : Int32 = -1;
    var vTableOffsets : ContiguousArray<Int32> = []
    
    public init(config : BinaryBuildConfig){
        self.config = config
        self.capacity = config.initialCapacity
        _data = UnsafeMutablePointer.alloc(capacity)
    }
    
    deinit {
        _data.dealloc(capacity)
    }    

    private func increaseCapacity(size : Int){
        guard leftCursor <= size else {
            return
        }
        let _leftCursor = leftCursor
        let _capacity = capacity
        while leftCursor <= size {
            capacity = capacity << 1
        }
        
        let newData = UnsafeMutablePointer<UInt8>.alloc(capacity)
        newData.advancedBy(leftCursor).initializeFrom(_data.advancedBy(_leftCursor), count: cursor)
        _data.dealloc(_capacity)
        _data = newData
    }
    
    var minalign = 1;
    private func align(size : Int, additionalBytes : Int){
        if config.fullMemoryAlignment == false {
            return
        }
        if size > minalign {
            minalign = size
        }
        let alignSize = ((~(cursor + additionalBytes)) + 1) & (size - 1)
        increaseCapacity(alignSize)
        cursor += alignSize
        
    }
    
    public func put<T : Scalar>(value : T){
        var v = value
        let c = strideofValue(v)
        if c > 8 {
            align(8, additionalBytes: c)
        } else {
            align(c, additionalBytes: 0)
        }

        increaseCapacity(c)
        withUnsafePointer(&v){
            _data.advancedBy(leftCursor-c).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
        cursor += c

    }
    
    public func put<T : Scalar>(value : UnsafePointer<T>, length : Int){
        if length > 8 {
            align(8, additionalBytes: length)
        } else {
            align(length, additionalBytes: 0)
        }
        
        increaseCapacity(length)
        _data.advancedBy(leftCursor-length).assignFrom(UnsafeMutablePointer<UInt8>(value), count: length)
        cursor += length
    }
    
    public func putOffset(offset : Offset?) throws -> Int { // make offset relative and put it into byte buffer
        guard let offset = offset else {
            put(Offset(0))
            return cursor
        }
        guard offset <= Int32(cursor) else {
            throw FlatBufferBuilderError.OffsetIsTooBig
        }
        
        if offset == Int32(0) {
            put(Offset(0))
            return cursor
        }
        align(4, additionalBytes: 0)
        let _offset = Int32(cursor) - offset + strideof(Int32);
        put(_offset)
        return cursor
    }
    
    public func replaceOffset(offset : Offset, atCursor jumpCursor: Int) throws{
        guard offset <= Int32(cursor) else {
            throw FlatBufferBuilderError.OffsetIsTooBig
        }
        guard jumpCursor <= cursor else {
            throw FlatBufferBuilderError.CursorIsInvalid
        }
        let _offset = Int32(jumpCursor) - offset;
        
        var v = _offset
        if UInt32(CFByteOrderGetCurrent()) == CFByteOrderBigEndian.rawValue{
            v = _offset.littleEndian
        }
        let c = strideofValue(v)
        withUnsafePointer(&v){
            _data.advancedBy((capacity - jumpCursor)).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
    }
    
    private func put<T : Scalar>(value : T, at index : Int){
        var v = value
        let c = strideofValue(v)
        withUnsafePointer(&v){
            _data.advancedBy(index + leftCursor).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
    }
    
    public func openObject(numOfProperties : Int) throws {
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBufferBuilderError.ObjectIsNotClosed
        }
        currentVTable.removeAll(keepCapacity: true)
        currentVTable.reserveCapacity(numOfProperties)
        for _ in 0..<numOfProperties {
            currentVTable.append(0)
        }
        objectStart = Int32(cursor)
    }
    
    public func addPropertyOffsetToOpenObject(propertyIndex : Int, offset : Offset) throws -> Int{
        guard objectStart > -1 else {
            throw FlatBufferBuilderError.NoOpenObject
        }
        guard propertyIndex >= 0 && propertyIndex < currentVTable.count else {
            throw FlatBufferBuilderError.PropertyIndexIsInvalid
        }
        try putOffset(offset)
        currentVTable[propertyIndex] = Int32(cursor)
        return cursor
    }
    
    public func addPropertyToOpenObject<T : Scalar>(propertyIndex : Int, value : T, defaultValue : T) throws {
        guard objectStart > -1 else {
            throw FlatBufferBuilderError.NoOpenObject
        }
        guard propertyIndex >= 0 && propertyIndex < currentVTable.count else {
            throw FlatBufferBuilderError.PropertyIndexIsInvalid
        }
        
        if(config.forceDefaults == false && value == defaultValue) {
            return
        }
        
        put(value)
        currentVTable[propertyIndex] = Int32(cursor)
    }
    
    public func addCurrentOffsetAsPropertyToOpenObject(propertyIndex : Int) throws {
        guard objectStart > -1 else {
            throw FlatBufferBuilderError.NoOpenObject
        }
        guard propertyIndex >= 0 && propertyIndex < currentVTable.count else {
            throw FlatBufferBuilderError.PropertyIndexIsInvalid
        }
        currentVTable[propertyIndex] = Int32(cursor)
    }
    
    public func closeObject() throws -> Offset {
        guard objectStart > -1 else {
            throw FlatBufferBuilderError.NoOpenObject
        }
        
        increaseCapacity(4)
        cursor += 4 // Will be set to vtable offset afterwards
        
        let vtableloc = cursor
        
        // vtable is stored as relative offset for object data
        var index = currentVTable.count - 1
        while(index>=0) {
            // Offset relative to the start of the table.
            let off = Int16(currentVTable[index] != 0 ? Int32(vtableloc) - currentVTable[index] : 0);
            put(off);
            index -= 1
        }
        
        let numberOfstandardFields = 2
        
        put(Int16(Int32(vtableloc) - objectStart)); // standard field 1: lenght of the object data
        put(Int16((currentVTable.count + numberOfstandardFields) * strideof(Int16))); // standard field 2: length of vtable and standard fields them selves
        
        // search if we already have same vtable
        let vtableDataLength = cursor - vtableloc
        
        var foundVTableOffset = vtableDataLength
        
        if config.uniqueVTables{
            for otherVTableOffset in vTableOffsets {
                let start = cursor - Int(otherVTableOffset)
                var found = true
                for i in 0 ..< vtableDataLength {
                    let a = _data.advancedBy(leftCursor + i).memory
                    let b = _data.advancedBy(leftCursor + i + start).memory
                    if a != b {
                        found = false
                        break;
                    }
                }
                if found == true {
                    foundVTableOffset = Int(otherVTableOffset) - vtableloc
                    break
                }
            }
            
            if foundVTableOffset != vtableDataLength {
                cursor -= vtableDataLength
            } else {
                vTableOffsets.append(Int32(cursor))
            }
        }
        
        let indexLocation = cursor - vtableloc
        
        put(Int32(foundVTableOffset), at: indexLocation)
        
        objectStart = -1
        
        return Offset(vtableloc)
    }
    
    public func startVector(count : Int, elementSize : Int) throws{
        align(4, additionalBytes: count * elementSize)
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBufferBuilderError.ObjectIsNotClosed
        }
        vectorNumElems = Int32(count)
    }
    
    public func endVector() -> Offset {
        put(vectorNumElems)
        vectorNumElems = -1
        return Int32(cursor)
    }
    
    private var stringCache : [String:Offset] = [:]
    public func createString(value : String?) throws -> Offset {
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBufferBuilderError.ObjectIsNotClosed
        }
        guard let value = value else {
            return 0
        }
        
        if config.uniqueStrings{
            if let o = stringCache[value]{
                return o
            }
        }
        
        if config.nullTerminatedUTF8 {
            let utf8View = value.nulTerminatedUTF8
            
            let length = utf8View.count
            align(4, additionalBytes: length)
            increaseCapacity(length)
            
            let p = UnsafeMutablePointer<UInt8>(_data.advancedBy(leftCursor-length))
            var charofs = 0
            for c in utf8View {
                assert(charofs < length)
                p.advancedBy(charofs).memory = c
                charofs = charofs + 1
            }
            cursor += length
            put(Int32(length - 1))
        } else {
            let utf8View = value.utf8
            
            let length = utf8View.count
            align(4, additionalBytes: length)
            increaseCapacity(length)
            
            let p = UnsafeMutablePointer<UInt8>(_data.advancedBy(leftCursor-length))
            var charofs = 0
            for c in utf8View {
                assert(charofs < length)
                p.advancedBy(charofs).memory = c
                charofs = charofs + 1
            }
            cursor += length
            put(Int32(length))
        }
        
        let o = Offset(cursor)
        if config.uniqueStrings {
            stringCache[value] = o
        }
        return o
    }
    
    public func createString(value : UnsafeBufferPointer<UInt8>?) throws -> Offset {
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBufferBuilderError.ObjectIsNotClosed
        }
        guard let value = value else {
            return 0
        }
        let length = value.count
        align(4, additionalBytes: length)
        increaseCapacity(length)
        _data.advancedBy(leftCursor-length).assignFrom(UnsafeMutablePointer(value.baseAddress), count: length)
        cursor += length
        put(Int32(length))
        return Offset(cursor)
    }
    
    public func createStaticString(value : StaticString?) throws -> Offset {
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBufferBuilderError.ObjectIsNotClosed
        }
        guard let value = value else {
            return 0
        }
        
        let buf = value.utf8Start
        let length = value.byteSize
        align(4, additionalBytes: length)
        increaseCapacity(length)
        _data.advancedBy(leftCursor-length).assignFrom(UnsafeMutablePointer<UInt8>(buf), count: length)
        cursor += length
        
        put(Int32(length))
        return Offset(cursor)
    }
    
    public func finish(offset : Offset, fileIdentifier : String?) throws -> Void {
        guard offset <= Int32(cursor) else {
            throw FlatBufferBuilderError.OffsetIsTooBig
        }
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBufferBuilderError.ObjectIsNotClosed
        }
        var prefixLength = 4
        increaseCapacity(8)
        if let fileIdentifier = fileIdentifier {
            let buf = fileIdentifier.utf8
            guard buf.count == 4 else {
                throw FlatBufferBuilderError.BadFileIdentifier
            }
            
            _data.advancedBy(leftCursor-4).initializeFrom(buf)
            prefixLength += 4
        }
        
        var v = (Int32(cursor + prefixLength) - offset).littleEndian
        let c = strideofValue(v)
        withUnsafePointer(&v){
            _data.advancedBy(leftCursor - prefixLength).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
        cursor += prefixLength
    }
}

// Pooling
public extension FlatBufferBuilder {
    
    public func reset ()
    {
        cursor = 0
        objectStart = -1
        vectorNumElems = -1;
        vTableOffsets.removeAll(keepCapacity: true)
        currentVTable.removeAll(keepCapacity: true)
        cache.removeAll(keepCapacity: true)
        inProgress.removeAll(keepCapacity: true)
        deferedBindings.removeAll(keepCapacity: true)
        stringCache.removeAll(keepCapacity: true)
    }
    
    public static func create(config: BinaryBuildConfig) -> FlatBufferBuilder {
        objc_sync_enter(instancePool)
        defer { objc_sync_exit(instancePool) }

        if (instancePool.count > 0)
        {
            let builder = instancePool.removeLast()
            builder.config = config
            if (config.initialCapacity > builder.capacity) {
                builder._data.dealloc(builder.capacity)
                builder.capacity = config.initialCapacity
                builder._data = UnsafeMutablePointer.alloc(builder.capacity)
            }
            return builder
        }
        
        return FlatBufferBuilder(config: config)
    }
    
    public static func reuse(builder : FlatBufferBuilder) {
        objc_sync_enter(instancePool)
        defer { objc_sync_exit(instancePool) }

        if (UInt(instancePool.count) < maxInstanceCacheSize)
        {
            builder.reset()
            instancePool.append(builder)
        }
    }
    
}

