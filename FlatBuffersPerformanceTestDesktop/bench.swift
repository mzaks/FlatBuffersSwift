
// generated with FlatBuffersSchemaEditor https://github.com/mzaks/FlatBuffersSchemaEditor

public enum Enum : Int16 {
	case Apples, Pears, Bananas
}
public struct Foo : Scalar {
	public let i_d : UInt64
	public let count : Int16
	public let prefix : Int8
	public let length : UInt32
}
public func ==(v1:Foo, v2:Foo) -> Bool {
	return  v1.i_d==v2.i_d &&  v1.count==v2.count &&  v1.prefix==v2.prefix &&  v1.length==v2.length
}
public struct Bar : Scalar {
	public let parent : Foo
	public let time : Int32
	public let ratio : Float32
	public let size : UInt16
}
public func ==(v1:Bar, v2:Bar) -> Bool {
	return  v1.parent==v2.parent &&  v1.time==v2.time &&  v1.ratio==v2.ratio &&  v1.size==v2.size
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
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> FooBar? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if reader.config.uniqueTables {
			if let o = reader.objectPool[objectOffset]{
				return o as? FooBar
			}
		}
		let _result = FooBar()
		if reader.config.uniqueTables {
			reader.objectPool[objectOffset] = _result
		}
		_result.sibling = reader.get(objectOffset, propertyIndex: 0)
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

		public var sibling : Bar? { 
			get { return self._reader.get(_objectOffset, propertyIndex: 0)}
			set {
				if let value = newValue{
					try!_reader.set(_objectOffset, propertyIndex: 0, value: value)
				}
			}
		}
		public lazy var name : String? = self._reader.getString(self._reader.getOffset(self._objectOffset, propertyIndex: 1))
		public var rating : Float64 { 
			get { return _reader.get(_objectOffset, propertyIndex: 2, defaultValue:0)}
			set { try!_reader.set(_objectOffset, propertyIndex: 2, value: newValue)}
		}
		public var postfix : UInt8 { 
			get { return _reader.get(_objectOffset, propertyIndex: 3, defaultValue:0)}
			set { try!_reader.set(_objectOffset, propertyIndex: 3, value: newValue)}
		}

		public var createEagerVersion : FooBar? { return FooBar.create(_reader, objectOffset: _objectOffset) }
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : FooBar.LazyAccess, t2 : FooBar.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset && t1._reader === t2._reader
}

public extension FooBar {
	private func addToByteArray(builder : FlatBufferBuilder) -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		let offset1 = try! builder.createString(name)
		try! builder.openObject(4)
		try! builder.addPropertyToOpenObject(3, value : postfix, defaultValue : 0)
		try! builder.addPropertyToOpenObject(2, value : rating, defaultValue : 0)
		try! builder.addPropertyOffsetToOpenObject(1, offset: offset1)
		if let sibling = sibling {
			builder.put(sibling)
			try! builder.addCurrentOffsetAsPropertyToOpenObject(0)
		}
		let myOffset =  try! builder.closeObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
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
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> FooBarContainer? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if reader.config.uniqueTables {
			if let o = reader.objectPool[objectOffset]{
				return o as? FooBarContainer
			}
		}
		let _result = FooBarContainer()
		if reader.config.uniqueTables {
			reader.objectPool[objectOffset] = _result
		}
		let offset_list : Offset? = reader.getOffset(objectOffset, propertyIndex: 0)
		let length_list = reader.getVectorLength(offset_list)
		if(length_list > 0){
			var index = 0
			_result.list.reserveCapacity(length_list)
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
	public static func fromByteArray(data : UnsafeBufferPointer<UInt8>, config : BinaryReadConfig = BinaryReadConfig()) -> FooBarContainer {
		let reader = FlatBufferReader.create(data, config: config)
		let objectOffset = reader.rootObjectOffset
		let result = create(reader, objectOffset : objectOffset)!
		FlatBufferReader.reuse(reader)
		return result
	}
}
public extension FooBarContainer {
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

public extension FooBarContainer {
    public func toFlatBufferBuilder (builder : FlatBufferBuilder) -> Void {
        let offset = addToByteArray(builder)
        performLateBindings(builder)
        try! builder.finish(offset, fileIdentifier: nil)
        return
    }
}
public extension FooBarContainer {
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

		public lazy var list : LazyVector<FooBar.LazyAccess> = { [self]
			let vectorOffset : Offset? = self._reader.getOffset(self._objectOffset, propertyIndex: 0)
			let vectorLength = self._reader.getVectorLength(vectorOffset)
			let reader = self._reader
			return LazyVector(count: vectorLength){ [reader] in
				FooBar.LazyAccess(reader: reader, objectOffset : reader.getVectorOffsetElement(vectorOffset!, index: $0))
			}
		}()
		public var initialized : Bool { 
			get { return _reader.get(_objectOffset, propertyIndex: 1, defaultValue:false)}
			set { try!_reader.set(_objectOffset, propertyIndex: 1, value: newValue)}
		}
		public var fruit : Enum? { 
			get { return Enum(rawValue: _reader.get(self._objectOffset, propertyIndex: 2, defaultValue:Enum.Apples.rawValue))}
			set { 
				if let value = newValue{
					try!_reader.set(_objectOffset, propertyIndex: 2, value: value.rawValue)
				}
			}
		}
		public lazy var location : String? = self._reader.getString(self._reader.getOffset(self._objectOffset, propertyIndex: 3))

		public var createEagerVersion : FooBarContainer? { return FooBarContainer.create(_reader, objectOffset: _objectOffset) }
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : FooBarContainer.LazyAccess, t2 : FooBarContainer.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset && t1._reader === t2._reader
}

public extension FooBarContainer {
	private func addToByteArray(builder : FlatBufferBuilder) -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		let offset3 = try! builder.createString(location)
		var offset0 = Offset(0)
		if list.count > 0{
			var offsets = [Offset?](count: list.count, repeatedValue: nil)
			var index = list.count - 1
			while(index >= 0){
				offsets[index] = list[index]?.addToByteArray(builder)
				index -= 1
			}
			try! builder.startVector(list.count)
			index = list.count - 1
			while(index >= 0){
				try! builder.putOffset(offsets[index])
				index -= 1
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
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
private func performLateBindings(builder : FlatBufferBuilder) {
	for binding in builder.deferedBindings {
		switch binding.object {
		case let object as FooBar: try! builder.replaceOffset(object.addToByteArray(builder), atCursor: binding.cursor)
		case let object as FooBarContainer: try! builder.replaceOffset(object.addToByteArray(builder), atCursor: binding.cursor)
		default: continue
		}
	}
}
