
// generated with FlatBuffersSchemaEditor https://github.com/mzaks/FlatBuffersSchemaEditor

public enum Enum : Int16 {
	case Apples, Pears, Bananas
}
public final class Foo {
	public var id : UInt64 = 0
	public var count : Int16 = 0
	public var prefix : Int8 = 0
	public var length : UInt32 = 0
	public init(){}
	public init(id: UInt64, count: Int16, prefix: Int8, length: UInt32){
		self.id = id
		self.count = count
		self.prefix = prefix
		self.length = length
	}
}
public extension Foo {
	private static var objectPool : [Offset : Foo] = [:]
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> Foo? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if let o = Foo.objectPool[objectOffset]{
			return o
		}
		let _result = Foo()
		Foo.objectPool[objectOffset] = _result
		_result.id = reader.get(objectOffset, propertyIndex: 0, defaultValue: 0)
		_result.count = reader.get(objectOffset, propertyIndex: 1, defaultValue: 0)
		_result.prefix = reader.get(objectOffset, propertyIndex: 2, defaultValue: 0)
		_result.length = reader.get(objectOffset, propertyIndex: 3, defaultValue: 0)
		return _result
	}
}
public extension Foo {
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

		public lazy var id : UInt64 = self._reader.get(self._objectOffset, propertyIndex: 0, defaultValue:0)
		public lazy var count : Int16 = self._reader.get(self._objectOffset, propertyIndex: 1, defaultValue:0)
		public lazy var prefix : Int8 = self._reader.get(self._objectOffset, propertyIndex: 2, defaultValue:0)
		public lazy var length : UInt32 = self._reader.get(self._objectOffset, propertyIndex: 3, defaultValue:0)

		public lazy var createEagerVersion : Foo? = Foo.create(self._reader, objectOffset: self._objectOffset)
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : Foo.LazyAccess, t2 : Foo.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset
}

public extension Foo {
	private static var cache : [ObjectIdentifier : Offset] = [:]
	private static var inProgress : Set<ObjectIdentifier> = []
	private static var deferedBindings : [(object:Foo, cursor:Int)] = []
	static func clearCaches(){
		cache.removeAll()
		inProgress.removeAll()
		deferedBindings.removeAll()
	}
	private func addToByteArray(builder : FlatBufferBuilder) -> Offset {
		if let myOffset = Foo.cache[ObjectIdentifier(self)] {
			return myOffset
		}
		if Foo.inProgress.contains(ObjectIdentifier(self)){
			return 0
		}
		Foo.inProgress.insert(ObjectIdentifier(self))
		try! builder.openObject(4)
		try! builder.addPropertyToOpenObject(3, value : length, defaultValue : 0)
		try! builder.addPropertyToOpenObject(2, value : prefix, defaultValue : 0)
		try! builder.addPropertyToOpenObject(1, value : count, defaultValue : 0)
		try! builder.addPropertyToOpenObject(0, value : id, defaultValue : 0)
		let myOffset =  try! builder.closeObject()
		Foo.cache[ObjectIdentifier(self)] = myOffset
		Foo.inProgress.remove(ObjectIdentifier(self))
		return myOffset
	}
}
public final class Bar {
	public var parent : Foo? = nil
	public var time : Int32 = 0
	public var ratio : Float32 = 0
	public var size : UInt16 = 0
	public init(){}
	public init(parent: Foo?, time: Int32, ratio: Float32, size: UInt16){
		self.parent = parent
		self.time = time
		self.ratio = ratio
		self.size = size
	}
}
public extension Bar {
	private static var objectPool : [Offset : Bar] = [:]
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> Bar? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if let o = Bar.objectPool[objectOffset]{
			return o
		}
		let _result = Bar()
		Bar.objectPool[objectOffset] = _result
		_result.parent = Foo.create(reader, objectOffset: reader.getOffset(objectOffset, propertyIndex: 0))
		_result.time = reader.get(objectOffset, propertyIndex: 1, defaultValue: 0)
		_result.ratio = reader.get(objectOffset, propertyIndex: 2, defaultValue: 0)
		_result.size = reader.get(objectOffset, propertyIndex: 3, defaultValue: 0)
		return _result
	}
}
public extension Bar {
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

		public lazy var parent : Foo.LazyAccess? = Foo.LazyAccess(reader: self._reader, objectOffset : self._reader.getOffset(self._objectOffset, propertyIndex: 0))
		public lazy var time : Int32 = self._reader.get(self._objectOffset, propertyIndex: 1, defaultValue:0)
		public lazy var ratio : Float32 = self._reader.get(self._objectOffset, propertyIndex: 2, defaultValue:0)
		public lazy var size : UInt16 = self._reader.get(self._objectOffset, propertyIndex: 3, defaultValue:0)

		public lazy var createEagerVersion : Bar? = Bar.create(self._reader, objectOffset: self._objectOffset)
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : Bar.LazyAccess, t2 : Bar.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset
}

public extension Bar {
	private static var cache : [ObjectIdentifier : Offset] = [:]
	private static var inProgress : Set<ObjectIdentifier> = []
	private static var deferedBindings : [(object:Bar, cursor:Int)] = []
	static func clearCaches(){
		cache.removeAll()
		inProgress.removeAll()
		deferedBindings.removeAll()
	}
	private func addToByteArray(builder : FlatBufferBuilder) -> Offset {
		if let myOffset = Bar.cache[ObjectIdentifier(self)] {
			return myOffset
		}
		if Bar.inProgress.contains(ObjectIdentifier(self)){
			return 0
		}
		Bar.inProgress.insert(ObjectIdentifier(self))
		let offset0 = parent?.addToByteArray(builder) ?? 0
		try! builder.openObject(4)
		try! builder.addPropertyToOpenObject(3, value : size, defaultValue : 0)
		try! builder.addPropertyToOpenObject(2, value : ratio, defaultValue : 0)
		try! builder.addPropertyToOpenObject(1, value : time, defaultValue : 0)
		if parent != nil {
			let cursor0 = try! builder.addPropertyOffsetToOpenObject(0, offset: offset0)
			if offset0 == 0 {
				Foo.deferedBindings.append((object: parent!, cursor: cursor0))
			}
		}
		let myOffset =  try! builder.closeObject()
		Bar.cache[ObjectIdentifier(self)] = myOffset
		Bar.inProgress.remove(ObjectIdentifier(self))
		return myOffset
	}
}
public final class FooBar {
	public var sibling : Bar? = nil
	public var name : String? = nil
	public var rating : Float64 = 0
	public var postfix : UInt8 = 0
	public init(){}
	public init(sibling: Bar?, name: String?, rating: Float64, postfix: UInt8){
		self.sibling = sibling
		self.name = name
		self.rating = rating
		self.postfix = postfix
	}
}
public extension FooBar {
	private static var objectPool : [Offset : FooBar] = [:]
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> FooBar? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if let o = FooBar.objectPool[objectOffset]{
			return o
		}
		let _result = FooBar()
		FooBar.objectPool[objectOffset] = _result
		_result.sibling = Bar.create(reader, objectOffset: reader.getOffset(objectOffset, propertyIndex: 0))
		_result.name = reader.getString(reader.getOffset(objectOffset, propertyIndex: 1))
		_result.rating = reader.get(objectOffset, propertyIndex: 2, defaultValue: 0)
		_result.postfix = reader.get(objectOffset, propertyIndex: 3, defaultValue: 0)
		return _result
	}
}
public extension FooBar {
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

		public lazy var sibling : Bar.LazyAccess? = Bar.LazyAccess(reader: self._reader, objectOffset : self._reader.getOffset(self._objectOffset, propertyIndex: 0))
		public lazy var name : String? = self._reader.getString(self._reader.getOffset(self._objectOffset, propertyIndex: 1))
		public lazy var rating : Float64 = self._reader.get(self._objectOffset, propertyIndex: 2, defaultValue:0)
		public lazy var postfix : UInt8 = self._reader.get(self._objectOffset, propertyIndex: 3, defaultValue:0)

		public lazy var createEagerVersion : FooBar? = FooBar.create(self._reader, objectOffset: self._objectOffset)
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : FooBar.LazyAccess, t2 : FooBar.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset
}

public extension FooBar {
	private static var cache : [ObjectIdentifier : Offset] = [:]
	private static var inProgress : Set<ObjectIdentifier> = []
	private static var deferedBindings : [(object:FooBar, cursor:Int)] = []
	static func clearCaches(){
		cache.removeAll()
		inProgress.removeAll()
		deferedBindings.removeAll()
	}
	private func addToByteArray(builder : FlatBufferBuilder) -> Offset {
		if let myOffset = FooBar.cache[ObjectIdentifier(self)] {
			return myOffset
		}
		if FooBar.inProgress.contains(ObjectIdentifier(self)){
			return 0
		}
		FooBar.inProgress.insert(ObjectIdentifier(self))
		let offset1 = try! builder.createString(name)
		let offset0 = sibling?.addToByteArray(builder) ?? 0
		try! builder.openObject(4)
		try! builder.addPropertyToOpenObject(3, value : postfix, defaultValue : 0)
		try! builder.addPropertyToOpenObject(2, value : rating, defaultValue : 0)
		try! builder.addPropertyOffsetToOpenObject(1, offset: offset1)
		if sibling != nil {
			let cursor0 = try! builder.addPropertyOffsetToOpenObject(0, offset: offset0)
			if offset0 == 0 {
				Bar.deferedBindings.append((object: sibling!, cursor: cursor0))
			}
		}
		let myOffset =  try! builder.closeObject()
		FooBar.cache[ObjectIdentifier(self)] = myOffset
		FooBar.inProgress.remove(ObjectIdentifier(self))
		return myOffset
	}
}
public final class FooBarContainer {
	public var list : [FooBar?] = []
	public var initialized : Bool = false
	public var fruit : Enum? = Enum.Apples
	public var location : String? = nil
	public init(){}
	public init(list: [FooBar?], initialized: Bool, fruit: Enum?, location: String?){
		self.list = list
		self.initialized = initialized
		self.fruit = fruit
		self.location = location
	}
}
public extension FooBarContainer {
	private static var objectPool : [Offset : FooBarContainer] = [:]
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> FooBarContainer? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if let o = FooBarContainer.objectPool[objectOffset]{
			return o
		}
		let _result = FooBarContainer()
		FooBarContainer.objectPool[objectOffset] = _result
		let offset_list : Offset? = reader.getOffset(objectOffset, propertyIndex: 0)
		let length_list = reader.getVectorLength(offset_list)
		if(length_list > 0){
			var index = 0
			while index < length_list {
				_result.list.append(FooBar.create(reader, objectOffset: reader.getVectorOffsetElement(offset_list!, index: index)))
				index += 1
			}
		}
		_result.initialized = reader.get(objectOffset, propertyIndex: 1, defaultValue: false)
		_result.fruit = Enum(rawValue: reader.get(objectOffset, propertyIndex: 2, defaultValue: Enum.Apples.rawValue))
		_result.location = reader.getString(reader.getOffset(objectOffset, propertyIndex: 3))
		return _result
	}
}
public extension FooBarContainer {
	public static func fromByteArray(data : UnsafePointer<UInt8>) -> FooBarContainer {
		let reader = FlatBufferReader(bytes: data)
		let objectOffset = reader.rootObjectOffset
		return create(reader, objectOffset : objectOffset)!
	}
}
public extension FooBarContainer {
	public var toByteArray : [UInt8] {
		let builder = FlatBufferBuilder()
		let offset = addToByteArray(builder)
		performLateBindings(builder)
		performClearCaches()
		return try! builder.finish(offset, fileIdentifier: nil)
	}
}
public extension FooBarContainer {
	public final class LazyAccess : Hashable {
		private let _reader : FlatBufferReader!
		private let _objectOffset : Offset!
		public init(data : UnsafePointer<UInt8>){
			_reader = FlatBufferReader(bytes: data)
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

		public lazy var list : LazyVector<FooBar.LazyAccess> = {
			let vectorOffset : Offset? = self._reader.getOffset(self._objectOffset, propertyIndex: 0)
			let vectorLength = self._reader.getVectorLength(vectorOffset)
			return LazyVector(count: vectorLength){ [unowned self] in
				FooBar.LazyAccess(reader: self._reader, objectOffset : self._reader.getVectorOffsetElement(vectorOffset!, index: $0))
			}
		}()
		public lazy var initialized : Bool = self._reader.get(self._objectOffset, propertyIndex: 1, defaultValue:false)
		public lazy var fruit : Enum? = Enum(rawValue: self._reader.get(self._objectOffset, propertyIndex: 2, defaultValue:Enum.Apples.rawValue))
		public lazy var location : String? = self._reader.getString(self._reader.getOffset(self._objectOffset, propertyIndex: 3))

		public lazy var createEagerVersion : FooBarContainer? = FooBarContainer.create(self._reader, objectOffset: self._objectOffset)
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : FooBarContainer.LazyAccess, t2 : FooBarContainer.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset
}

public extension FooBarContainer {
	private static var cache : [ObjectIdentifier : Offset] = [:]
	private static var inProgress : Set<ObjectIdentifier> = []
	private static var deferedBindings : [(object:FooBarContainer, cursor:Int)] = []
	static func clearCaches(){
		cache.removeAll()
		inProgress.removeAll()
		deferedBindings.removeAll()
	}
	private func addToByteArray(builder : FlatBufferBuilder) -> Offset {
		if let myOffset = FooBarContainer.cache[ObjectIdentifier(self)] {
			return myOffset
		}
		if FooBarContainer.inProgress.contains(ObjectIdentifier(self)){
			return 0
		}
		FooBarContainer.inProgress.insert(ObjectIdentifier(self))
		let offset3 = try! builder.createString(location)
		var offset0 = Offset(0)
		if list.count > 0{
			var offsets = [Offset?](count: list.count, repeatedValue: nil)
			var index = list.count - 1
			var deferedBindingObjects : [Int : FooBar] = [:]
			while(index >= 0){
				offsets[index] = list[index]?.addToByteArray(builder)
				if offsets[index] == 0 {
					deferedBindingObjects[index] = list[index]!
				}
				index -= 1
			}
			try! builder.startVector(list.count)
			index = list.count - 1
			var deferedBindingCursors : [Int : Int] = [:]
			while(index >= 0){
				let cursor = try! builder.putOffset(offsets[index])
				if offsets[index] == 0 {
					deferedBindingCursors[index] = cursor
				}
				index -= 1
			}
			for key in deferedBindingObjects.keys {
				FooBar.deferedBindings.append((object: deferedBindingObjects[key]!, cursor: deferedBindingCursors[key]!))
			}
			offset0 = builder.endVector()
		}
		try! builder.openObject(4)
		try! builder.addPropertyOffsetToOpenObject(3, offset: offset3)
		try! builder.addPropertyToOpenObject(2, value : fruit!.rawValue, defaultValue : 0)
		try! builder.addPropertyToOpenObject(1, value : initialized, defaultValue : false)
		if list.count > 0 {
			try! builder.addPropertyOffsetToOpenObject(0, offset: offset0)
		}
		let myOffset =  try! builder.closeObject()
		FooBarContainer.cache[ObjectIdentifier(self)] = myOffset
		FooBarContainer.inProgress.remove(ObjectIdentifier(self))
		return myOffset
	}
}
private func performLateBindings(builder : FlatBufferBuilder) {
	for binding in Foo.deferedBindings {
		try! builder.replaceOffset(binding.object.addToByteArray(builder), atCursor: binding.cursor)
	}
	for binding in Bar.deferedBindings {
		try! builder.replaceOffset(binding.object.addToByteArray(builder), atCursor: binding.cursor)
	}
	for binding in FooBar.deferedBindings {
		try! builder.replaceOffset(binding.object.addToByteArray(builder), atCursor: binding.cursor)
	}
	for binding in FooBarContainer.deferedBindings {
		try! builder.replaceOffset(binding.object.addToByteArray(builder), atCursor: binding.cursor)
	}
}
private func performClearCaches() {
	Foo.clearCaches()
	Bar.clearCaches()
	FooBar.clearCaches()
	FooBarContainer.clearCaches()
}
