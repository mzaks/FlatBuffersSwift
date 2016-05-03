
// generated with FlatBuffersSchemaEditor https://github.com/mzaks/FlatBuffersSchemaEditor

public final class ContactList {
	public var lastModified : Int64 = 0
	public var entries : [Contact?] = []
	public init(){}
	public init(lastModified: Int64, entries: [Contact?]){
		self.lastModified = lastModified
		self.entries = entries
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
		let _result = ContactList()
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
	public static func fromByteArray(data : UnsafePointer<UInt8>, config : BinaryReadConfig = BinaryReadConfig()) -> ContactList {
		let reader = FlatBufferReader(bytes: data, config: config)
		let objectOffset = reader.rootObjectOffset
		return create(reader, objectOffset : objectOffset)!
	}
}
public extension ContactList {
	public func toByteArray (config : BinaryBuildConfig = BinaryBuildConfig()) -> [UInt8] {
		let builder = FlatBufferBuilder(config: config)
		let offset = addToByteArray(builder)
		performLateBindings(builder)
		return try! builder.finish(offset, fileIdentifier: nil)
	}
}
public extension ContactList {
	public final class LazyAccess : Hashable {
		private let _reader : FlatBufferReader!
		private let _objectOffset : Offset!
		public init(data : UnsafePointer<UInt8>, config : BinaryReadConfig = BinaryReadConfig()){
			_reader = FlatBufferReader(bytes: data, config: config)
			_objectOffset = _reader.rootObjectOffset
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

		public lazy var lastModified : Int64 = self._reader.get(self._objectOffset, propertyIndex: 0, defaultValue:0)
		public lazy var entries : LazyVector<Contact.LazyAccess> = {
			let vectorOffset : Offset? = self._reader.getOffset(self._objectOffset, propertyIndex: 1)
			let vectorLength = self._reader.getVectorLength(vectorOffset)
			let this = self
			return LazyVector(count: vectorLength){ [this] in
				Contact.LazyAccess(reader: this._reader, objectOffset : this._reader.getVectorOffsetElement(vectorOffset!, index: $0))
			}
		}()

		public lazy var createEagerVersion : ContactList? = ContactList.create(self._reader, objectOffset: self._objectOffset)
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : ContactList.LazyAccess, t2 : ContactList.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset && t1._reader === t2._reader
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
			try! builder.startVector(entries.count)
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
	public var tags : [String?] = []
	public var addressEntries : [AddressEntry?] = []
	public var currentLoccation : GeoLocation? = nil
	public var previousLocations : [GeoLocation?] = []
	public var moods : [Mood?] = []
	public init(){}
	public init(name: String?, birthday: Date?, gender: Gender?, tags: [String?], addressEntries: [AddressEntry?], currentLoccation: GeoLocation?, previousLocations: [GeoLocation?], moods: [Mood?]){
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
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> Contact? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if reader.config.uniqueTables {
			if let o = reader.objectPool[objectOffset]{
				return o as? Contact
			}
		}
		let _result = Contact()
		if reader.config.uniqueTables {
			reader.objectPool[objectOffset] = _result
		}
		_result.name = reader.getString(reader.getOffset(objectOffset, propertyIndex: 0))
		_result.birthday = Date.create(reader, objectOffset: reader.getOffset(objectOffset, propertyIndex: 1))
		_result.gender = Gender(rawValue: reader.get(objectOffset, propertyIndex: 2, defaultValue: Gender.Male.rawValue))
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
		public lazy var gender : Gender? = Gender(rawValue: self._reader.get(self._objectOffset, propertyIndex: 2, defaultValue:Gender.Male.rawValue))
		public lazy var tags : LazyVector<String> = {
			let vectorOffset : Offset? = self._reader.getOffset(self._objectOffset, propertyIndex: 3)
			let vectorLength = self._reader.getVectorLength(vectorOffset)
			let this = self
			return LazyVector(count: vectorLength){ [this] in
				this._reader.getString(this._reader.getVectorOffsetElement(vectorOffset!, index: $0))
			}
		}()
		public lazy var addressEntries : LazyVector<AddressEntry.LazyAccess> = {
			let vectorOffset : Offset? = self._reader.getOffset(self._objectOffset, propertyIndex: 4)
			let vectorLength = self._reader.getVectorLength(vectorOffset)
			let this = self
			return LazyVector(count: vectorLength){ [this] in
				AddressEntry.LazyAccess(reader: this._reader, objectOffset : this._reader.getVectorOffsetElement(vectorOffset!, index: $0))
			}
		}()
		public lazy var currentLoccation : GeoLocation? = self._reader.get(self._objectOffset, propertyIndex: 5)
		public lazy var previousLocations : LazyVector<GeoLocation> = {
			let vectorOffset : Offset? = self._reader.getOffset(self._objectOffset, propertyIndex: 6)
			let vectorLength = self._reader.getVectorLength(vectorOffset)
			let this = self
			return LazyVector(count: vectorLength){ [this] in
				return this._reader.getVectorScalarElement(vectorOffset!, index: $0) as GeoLocation
			}
		}()
		public lazy var moods : LazyVector<Mood> = {
			let vectorOffset : Offset? = self._reader.getOffset(self._objectOffset, propertyIndex: 7)
			let vectorLength = self._reader.getVectorLength(vectorOffset)
			let this = self
			return LazyVector(count: vectorLength){ [this] in
				Mood(rawValue: this._reader.getVectorScalarElement(vectorOffset!, index: $0))
			}
		}()

		public lazy var createEagerVersion : Contact? = Contact.create(self._reader, objectOffset: self._objectOffset)
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : Contact.LazyAccess, t2 : Contact.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset && t1._reader === t2._reader
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
			try! builder.startVector(moods.count)
			var index = moods.count - 1
			while(index >= 0){
				builder.put(moods[index]!.rawValue)
				index -= 1
			}
			offset7 = builder.endVector()
		}
		var offset6 = Offset(0)
		if previousLocations.count > 0{
			try! builder.startVector(previousLocations.count)
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
			try! builder.startVector(addressEntries.count)
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
			try! builder.startVector(tags.count)
			index = tags.count - 1
			while(index >= 0){
				try! builder.putOffset(offsets[index])
				index -= 1
			}
			offset3 = builder.endVector()
		}
		let offset1 = birthday?.addToByteArray(builder) ?? 0
		let offset0 = try! builder.createString(name)
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
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> Date? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if reader.config.uniqueTables {
			if let o = reader.objectPool[objectOffset]{
				return o as? Date
			}
		}
		let _result = Date()
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

		public lazy var day : Int8 = self._reader.get(self._objectOffset, propertyIndex: 0, defaultValue:0)
		public lazy var month : Int8 = self._reader.get(self._objectOffset, propertyIndex: 1, defaultValue:0)
		public lazy var year : Int16 = self._reader.get(self._objectOffset, propertyIndex: 2, defaultValue:0)

		public lazy var createEagerVersion : Date? = Date.create(self._reader, objectOffset: self._objectOffset)
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : Date.LazyAccess, t2 : Date.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset && t1._reader === t2._reader
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
public struct S1 : Scalar {
	public var i : Int32
}
public func ==(v1:S1, v2:S1) -> Bool {
	return  v1.i==v2.i
}
public struct GeoLocation : Scalar {
	public var latitude : Float64
	public var longitude : Float64
	public var elevation : Float32
	public var s : S1
}
public func ==(v1:GeoLocation, v2:GeoLocation) -> Bool {
	return  v1.latitude==v2.latitude &&  v1.longitude==v2.longitude &&  v1.elevation==v2.elevation &&  v1.s==v2.s
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
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> AddressEntry? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if reader.config.uniqueTables {
			if let o = reader.objectPool[objectOffset]{
				return o as? AddressEntry
			}
		}
		let _result = AddressEntry()
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

		public lazy var order : Int32 = self._reader.get(self._objectOffset, propertyIndex: 0, defaultValue:0)
		public lazy var address : Address_LazyAccess? = create_Address_LazyAccess(self._reader, propertyIndex: 1, objectOffset: self._objectOffset)

		public lazy var createEagerVersion : AddressEntry? = AddressEntry.create(self._reader, objectOffset: self._objectOffset)
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : AddressEntry.LazyAccess, t2 : AddressEntry.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset && t1._reader === t2._reader
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
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> PostalAddress? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if reader.config.uniqueTables {
			if let o = reader.objectPool[objectOffset]{
				return o as? PostalAddress
			}
		}
		let _result = PostalAddress()
		if reader.config.uniqueTables {
			reader.objectPool[objectOffset] = _result
		}
		_result.country = reader.getString(reader.getOffset(objectOffset, propertyIndex: 0))
		_result.city = reader.getString(reader.getOffset(objectOffset, propertyIndex: 1))
		_result.postalCode = reader.get(objectOffset, propertyIndex: 2, defaultValue: 0)
		_result.streetAndNumber = reader.getString(reader.getOffset(objectOffset, propertyIndex: 3))
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
		public lazy var postalCode : Int32 = self._reader.get(self._objectOffset, propertyIndex: 2, defaultValue:0)
		public lazy var streetAndNumber : String? = self._reader.getString(self._reader.getOffset(self._objectOffset, propertyIndex: 3))

		public lazy var createEagerVersion : PostalAddress? = PostalAddress.create(self._reader, objectOffset: self._objectOffset)
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : PostalAddress.LazyAccess, t2 : PostalAddress.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset && t1._reader === t2._reader
}

public extension PostalAddress {
	private func addToByteArray(builder : FlatBufferBuilder) -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		let offset3 = try! builder.createString(streetAndNumber)
		let offset1 = try! builder.createString(city)
		let offset0 = try! builder.createString(country)
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
public final class EmailAddress {
	public var mailto : String? = nil
	public init(){}
	public init(mailto: String?){
		self.mailto = mailto
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
		let _result = EmailAddress()
		if reader.config.uniqueTables {
			reader.objectPool[objectOffset] = _result
		}
		_result.mailto = reader.getString(reader.getOffset(objectOffset, propertyIndex: 0))
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

		public lazy var createEagerVersion : EmailAddress? = EmailAddress.create(self._reader, objectOffset: self._objectOffset)
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : EmailAddress.LazyAccess, t2 : EmailAddress.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset && t1._reader === t2._reader
}

public extension EmailAddress {
	private func addToByteArray(builder : FlatBufferBuilder) -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		let offset0 = try! builder.createString(mailto)
		try! builder.openObject(1)
		try! builder.addPropertyOffsetToOpenObject(0, offset: offset0)
		let myOffset =  try! builder.closeObject()
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
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> WebAddress? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if reader.config.uniqueTables {
			if let o = reader.objectPool[objectOffset]{
				return o as? WebAddress
			}
		}
		let _result = WebAddress()
		if reader.config.uniqueTables {
			reader.objectPool[objectOffset] = _result
		}
		_result.url = reader.getString(reader.getOffset(objectOffset, propertyIndex: 0))
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

		public lazy var createEagerVersion : WebAddress? = WebAddress.create(self._reader, objectOffset: self._objectOffset)
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : WebAddress.LazyAccess, t2 : WebAddress.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset && t1._reader === t2._reader
}

public extension WebAddress {
	private func addToByteArray(builder : FlatBufferBuilder) -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		let offset0 = try! builder.createString(url)
		try! builder.openObject(1)
		try! builder.addPropertyOffsetToOpenObject(0, offset: offset0)
		let myOffset =  try! builder.closeObject()
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
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> TelephoneNumber? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if reader.config.uniqueTables {
			if let o = reader.objectPool[objectOffset]{
				return o as? TelephoneNumber
			}
		}
		let _result = TelephoneNumber()
		if reader.config.uniqueTables {
			reader.objectPool[objectOffset] = _result
		}
		_result.number = reader.getString(reader.getOffset(objectOffset, propertyIndex: 0))
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

		public lazy var createEagerVersion : TelephoneNumber? = TelephoneNumber.create(self._reader, objectOffset: self._objectOffset)
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : TelephoneNumber.LazyAccess, t2 : TelephoneNumber.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset && t1._reader === t2._reader
}

public extension TelephoneNumber {
	private func addToByteArray(builder : FlatBufferBuilder) -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		let offset0 = try! builder.createString(number)
		try! builder.openObject(1)
		try! builder.addPropertyOffsetToOpenObject(0, offset: offset0)
		let myOffset =  try! builder.closeObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
public protocol Address{}
public protocol Address_LazyAccess{}
extension PostalAddress : Address {}
extension PostalAddress.LazyAccess : Address_LazyAccess {}
extension EmailAddress : Address {}
extension EmailAddress.LazyAccess : Address_LazyAccess {}
extension WebAddress : Address {}
extension WebAddress.LazyAccess : Address_LazyAccess {}
extension TelephoneNumber : Address {}
extension TelephoneNumber.LazyAccess : Address_LazyAccess {}
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
import Foundation
public typealias Offset = Int32

public protocol Scalar : Equatable {}

extension Scalar {
    var littleEndian : Self {
        switch self {
        case let v as Int16 : return v.littleEndian as! Self
        case let v as UInt16 : return v.littleEndian as! Self
        case let v as Int32 : return v.littleEndian as! Self
        case let v as UInt32 : return v.littleEndian as! Self
        case let v as Int64 : return v.littleEndian as! Self
        case let v as UInt64 : return v.littleEndian as! Self
        case let v as Int : return v.littleEndian as! Self
        case let v as UInt : return v.littleEndian as! Self
        default : return self
        }
    }
}

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

// String extension from Mike Ash for conveniently creating native Swift strings from UTF8 sequences
// https://www.mikeash.com/pyblog/friday-qa-2015-11-06-why-is-swifts-string-api-so-hard.html

extension String {
    init?<Seq: SequenceType where Seq.Generator.Element == UInt16>(utf16: Seq) {
        self.init()
        
        guard transcode(UTF16.self,
                        UTF32.self,
                        utf16.generate(),
                        { self.append(UnicodeScalar($0)) },
                        stopOnError: true)
            == false else { return nil }
    }
    
    init?<Seq: SequenceType where Seq.Generator.Element == UInt8>(utf8: Seq) {
        self.init()
        
        guard transcode(UTF8.self,
                        UTF32.self,
                        utf8.generate(),
                        { self.append(UnicodeScalar($0)) },
                        stopOnError: true)
            == false else { return nil }
    }
}

public final class LazyVector<T> : SequenceType {
    private let _generator : (Int)->T?
    private let _count : Int
    
    public init(count : Int, generator : (Int)->T?){
        _generator = generator
        _count = count
    }
    
    public subscript(i: Int) -> T? {
        guard i >= 0 && i < _count else {
            return nil
        }
        return _generator(i)
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
    public var initialCapacity = 1
    public var uniqueStrings = true
    public var uniqueTables = true
    public var uniqueVTables = true
    public init() {}
    public init(initialCapacity : Int, uniqueStrings : Bool, uniqueTables : Bool, uniqueVTables : Bool) {
        self.initialCapacity = initialCapacity
        self.uniqueStrings = uniqueStrings
        self.uniqueTables = uniqueTables
        self.uniqueVTables = uniqueVTables
    }
}

public struct BinaryReadConfig {
    public var uniqueTables = true
    public var uniqueStrings = true
    public init() {}
    public init(uniqueStrings : Bool, uniqueTables : Bool) {
        self.uniqueStrings = uniqueStrings
        self.uniqueTables = uniqueTables
    }
}
// MARK: Reader
public final class FlatBufferReader {

    public let config : BinaryReadConfig
    
    let buffer : UnsafePointer<UInt8>
    public var objectPool : [Offset : AnyObject] = [:]
    
    func fromByteArray<T : Scalar>(position : Int) -> T{
        return UnsafePointer<T>(buffer.advancedBy(position)).memory
    }

    public init(buffer : [UInt8], config: BinaryReadConfig){
        self.buffer = UnsafePointer<UInt8>(buffer)
        self.config = config
    }
    
    public init(bytes : UnsafePointer<UInt8>, config: BinaryReadConfig){
        self.buffer = bytes
        self.config = config
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
    
    public func getStructProperty<T : Scalar>(objectOffset : Offset, propertyIndex : Int, structPropertyOffset : Int, defaultValue : T) -> T {
        let propertyOffset = getPropertyOffset(objectOffset, propertyIndex: propertyIndex)
        if propertyOffset == 0 {
            return defaultValue
        }
        let position = Int(objectOffset + propertyOffset) + structPropertyOffset
        
        return fromByteArray(position)
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
    var stringBuffer : [UInt8] = []
    
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

        // This slightly convoluted way makes sure we construct a native Swift string instead of a bridged NSString

        stringBuffer.reserveCapacity(Int(stringLength))
        for i in 0..<stringLength {
            let pointer = UnsafeMutablePointer<UInt8>(buffer).advancedBy((stringPosition + strideof(Int32) + Int(i)))
            stringBuffer.append(pointer.memory)
        }
        let result = String(utf8: stringBuffer)
        stringBuffer.removeAll(keepCapacity: true)

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
    
    public func getVectorStructElement<T : Scalar>(vectorOffset : Offset, vectorIndex : Int, structSize : Int, structElementIndex : Int) -> T {
        let valueStartPosition = Int(vectorOffset + strideof(Int32) + (vectorIndex * structSize) + structElementIndex)
        return UnsafePointer<T>(UnsafePointer<UInt8>(buffer).advancedBy(valueStartPosition)).memory
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
    
    public var cache : [ObjectIdentifier : Offset] = [:]
    public var inProgress : Set<ObjectIdentifier> = []
    public var deferedBindings : [(object:Any, cursor:Int)] = []
    
    public let config : BinaryBuildConfig
    
    var capacity : Int
    private var _data : UnsafeMutablePointer<UInt8>
    var data : [UInt8] {
        return Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(_data).advancedBy(leftCursor), count: cursor))
    }
    var cursor = 0
    var leftCursor : Int {
        return capacity - cursor
    }
    
    var currentVTable : [Int32] = []
    var objectStart : Int32 = -1
    var vectorNumElems : Int32 = -1;
    var vTableOffsets : [Int32] = []
    
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
    
    public func put<T : Scalar>(value : T){
        var v = value
        if UInt32(CFByteOrderGetCurrent()) == CFByteOrderBigEndian.rawValue{
            v = value.littleEndian
        }
        let c = strideofValue(v)
        increaseCapacity(c)
        withUnsafePointer(&v){
            _data.advancedBy(leftCursor-c).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
//        memcpy(_data.advancedBy(leftCursor-c), &v, c)
        cursor += c

    }
    
    public func put<T : Scalar>(value : UnsafePointer<T>, length : Int){
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
//        memcpy(_data.advancedBy(capacity - jumpCursor), &v, c)
    }
    
    private func put<T : Scalar>(value : T, at index : Int){
        var v = value
        if UInt32(CFByteOrderGetCurrent()) == CFByteOrderBigEndian.rawValue{
            v = value.littleEndian
        }
        let c = strideofValue(v)
        withUnsafePointer(&v){
            _data.advancedBy(index + leftCursor).assignFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
//        memcpy(_data.advancedBy(index + leftCursor), &v, c)
    }
    
    public func openObject(numOfProperties : Int) throws {
        guard objectStart == -1 && vectorNumElems == -1 else {
            throw FlatBufferBuilderError.ObjectIsNotClosed
        }
        currentVTable = Array<Int32>(count: numOfProperties, repeatedValue: 0)
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
        
        if(value == defaultValue) {
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
    
    public func startVector(count : Int) throws{
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

        let length = value.utf8.count
        
        increaseCapacity(length)
        
        let p = UnsafeMutablePointer<UInt8>(_data.advancedBy(leftCursor-length))
        var charofs = 0
        for c in value.utf8
        {
            assert(charofs < length)
            p.advancedBy(charofs).memory = c
            charofs = charofs + 1
        }
        
        cursor += length

        put(Int32(length))
        
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
        
        increaseCapacity(length)
        _data.advancedBy(leftCursor-length).initializeFrom(UnsafeMutablePointer<UInt8>(buf), count: length)
        cursor += length
        
        put(Int32(length))
        return Offset(cursor)
    }
    
    public func finish(offset : Offset, fileIdentifier : String?) throws -> [UInt8] {
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
            _data.advancedBy(leftCursor - prefixLength).initializeFrom(UnsafeMutablePointer<UInt8>($0), count: c)
        }
//        memcpy(_data.advancedBy(leftCursor - prefixLength), &v, c)
        
        return Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(_data).advancedBy(leftCursor - prefixLength), count: cursor+prefixLength))
    }
}
