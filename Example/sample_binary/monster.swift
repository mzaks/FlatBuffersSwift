
// generated with FlatBuffersSchemaEditor https://github.com/mzaks/FlatBuffersSchemaEditor

import Foundation

import FlatBuffersSwift
public enum Color : Int8 {
	case Red = 0, Green, Blue = 2
}
public struct Vec3 : Scalar {
	public let x : Float32
	public let y : Float32
	public let z : Float32
}
public func ==(v1:Vec3, v2:Vec3) -> Bool {
	return  v1.x==v2.x &&  v1.y==v2.y &&  v1.z==v2.z
}
public final class Monster {
	public static var maxInstanceCacheSize : UInt = 0
	public static var instancePool : [Monster] = []
	public var pos : Vec3? = nil
	public var mana : Int16 = 150
	public var hp : Int16 = 100
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
	
	public var __friendly : Bool = false
	public var inventory : [UInt8] = []
	public var color : Color? = Color.Blue
	public var weapons : [Weapon?] = []
	public var equipped : Equipment? = nil
	public init(){}
	public init(pos: Vec3?, mana: Int16, hp: Int16, name: String?, inventory: [UInt8], color: Color?, weapons: [Weapon?], equipped: Equipment?){
		self.pos = pos
		self.mana = mana
		self.hp = hp
		self.name_s = name
		self.inventory = inventory
		self.color = color
		self.weapons = weapons
		self.equipped = equipped
	}
	public init(pos: Vec3?, mana: Int16, hp: Int16, name: StaticString?, inventory: [UInt8], color: Color?, weapons: [Weapon?], equipped: Equipment?){
		self.pos = pos
		self.mana = mana
		self.hp = hp
		self.name_ss = name
		self.inventory = inventory
		self.color = color
		self.weapons = weapons
		self.equipped = equipped
	}
}

extension Monster : PoolableInstances {
	public func reset() { 
		pos = nil
		mana = 150
		hp = 100
		name = nil
		inventory = []
		color = Color.Blue
		while (weapons.count > 0) {
			var x = weapons.removeLast()!
			Weapon.reuseInstance(&x)
		}
		equipped = nil
	}
}
public extension Monster {
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> Monster? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if reader.config.uniqueTables {
			if let o = reader.objectPool[objectOffset]{
				return o as? Monster
			}
		}
		let _result = Monster.createInstance()
		if reader.config.uniqueTables {
			reader.objectPool[objectOffset] = _result
		}
		_result.pos = reader.get(objectOffset, propertyIndex: 0)
		_result.mana = reader.get(objectOffset, propertyIndex: 1, defaultValue: 150)
		_result.hp = reader.get(objectOffset, propertyIndex: 2, defaultValue: 100)
		_result.name_b = reader.getStringBuffer(reader.getOffset(objectOffset, propertyIndex: 3))
		_result.__friendly = reader.get(objectOffset, propertyIndex: 4, defaultValue: false)
		let offset_inventory : Offset? = reader.getOffset(objectOffset, propertyIndex: 5)
		let length_inventory = reader.getVectorLength(offset_inventory)
		if(length_inventory > 0){
			var index = 0
			_result.inventory.reserveCapacity(length_inventory)
			while index < length_inventory {
				_result.inventory.append(reader.getVectorScalarElement(offset_inventory!, index: index))
				index += 1
			}
		}
		_result.color = Color(rawValue: reader.get(objectOffset, propertyIndex: 6, defaultValue: Color.Blue.rawValue))
		let offset_weapons : Offset? = reader.getOffset(objectOffset, propertyIndex: 7)
		let length_weapons = reader.getVectorLength(offset_weapons)
		if(length_weapons > 0){
			var index = 0
			_result.weapons.reserveCapacity(length_weapons)
			while index < length_weapons {
				_result.weapons.append(Weapon.create(reader, objectOffset: reader.getVectorOffsetElement(offset_weapons!, index: index)))
				index += 1
			}
		}
		_result.equipped = create_Equipment(reader, propertyIndex: 8, objectOffset: objectOffset)
		return _result
	}
}
public extension Monster {
	public static func fromByteArray(data : UnsafeBufferPointer<UInt8>, config : BinaryReadConfig = BinaryReadConfig()) -> Monster {
		let reader = FlatBufferReader.create(data, config: config)
		let objectOffset = reader.rootObjectOffset
		let result = create(reader, objectOffset : objectOffset)!
		FlatBufferReader.reuse(reader)
		return result
	}
	public static func fromRawMemory(data : UnsafeMutablePointer<UInt8>, count : Int, config : BinaryReadConfig = BinaryReadConfig()) -> Monster {
		let reader = FlatBufferReader.create(data, count: count, config: config)
		let objectOffset = reader.rootObjectOffset
		let result = create(reader, objectOffset : objectOffset)!
		FlatBufferReader.reuse(reader)
		return result
	}
	public static func fromFlatBufferReader(flatBufferReader : FlatBufferReader) -> Monster {
		return create(flatBufferReader, objectOffset : flatBufferReader.rootObjectOffset)!
	}
}
public extension Monster {
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

public extension Monster {
	public func toFlatBufferBuilder (builder : FlatBufferBuilder) -> Void {
		let offset = addToByteArray(builder)
		performLateBindings(builder)
		try! builder.finish(offset, fileIdentifier: nil)
	}
}

public extension Monster {
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

		public var pos : Vec3? { 
			get { return self._reader.get(_objectOffset, propertyIndex: 0)}
			set {
				if let value = newValue{
					try!_reader.set(_objectOffset, propertyIndex: 0, value: value)
				}
			}
		}
		public var mana : Int16 { 
			get { return _reader.get(_objectOffset, propertyIndex: 1, defaultValue:150)}
			set { try!_reader.set(_objectOffset, propertyIndex: 1, value: newValue)}
		}
		public var hp : Int16 { 
			get { return _reader.get(_objectOffset, propertyIndex: 2, defaultValue:100)}
			set { try!_reader.set(_objectOffset, propertyIndex: 2, value: newValue)}
		}
		public lazy var name : String? = self._reader.getString(self._reader.getOffset(self._objectOffset, propertyIndex: 3))
		public var __friendly : Bool { 
			get { return _reader.get(_objectOffset, propertyIndex: 4, defaultValue:false)}
			set { try!_reader.set(_objectOffset, propertyIndex: 4, value: newValue)}
		}
		public lazy var inventory : LazyVector<UInt8> = { [self]
			let vectorOffset : Offset? = self._reader.getOffset(self._objectOffset, propertyIndex: 5)
			let vectorLength = self._reader.getVectorLength(vectorOffset)
			let reader = self._reader
			return LazyVector(count: vectorLength, { [reader] in
				reader.getVectorScalarElement(vectorOffset!, index: $0) as UInt8
			}) { [reader] in
				reader.setVectorScalarElement(vectorOffset!, index: $0, value: $1)
			}
		}()
		public var color : Color? { 
			get { return Color(rawValue: _reader.get(self._objectOffset, propertyIndex: 6, defaultValue:Color.Blue.rawValue))}
			set { 
				if let value = newValue{
					try!_reader.set(_objectOffset, propertyIndex: 6, value: value.rawValue)
				}
			}
		}
		public lazy var weapons : LazyVector<Weapon.LazyAccess> = { [self]
			let vectorOffset : Offset? = self._reader.getOffset(self._objectOffset, propertyIndex: 7)
			let vectorLength = self._reader.getVectorLength(vectorOffset)
			let reader = self._reader
			return LazyVector(count: vectorLength){ [reader] in
				Weapon.LazyAccess(reader: reader, objectOffset : reader.getVectorOffsetElement(vectorOffset!, index: $0))
			}
		}()
		public lazy var equipped : Equipment_LazyAccess? = create_Equipment_LazyAccess(self._reader, propertyIndex: 8, objectOffset: self._objectOffset)

		public var createEagerVersion : Monster? { return Monster.create(_reader, objectOffset: _objectOffset) }
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : Monster.LazyAccess, t2 : Monster.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset && t1._reader === t2._reader
}

extension Monster {
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
	public var pos : Vec3? { 
		get { return FlatBufferReaderFast.get(buffer, myOffset, propertyIndex: 0)}
		set { 
			if let newValue = newValue {
				try!FlatBufferReaderFast.set(UnsafeMutablePointer<UInt8>(buffer), myOffset, propertyIndex: 0, value: newValue)
			}
		}
	}
	public var mana : Int16 { 
		get { return FlatBufferReaderFast.get(buffer, myOffset, propertyIndex: 1, defaultValue: 150) }
		set { try!FlatBufferReaderFast.set(UnsafeMutablePointer<UInt8>(buffer), myOffset, propertyIndex: 1, value: newValue) }
	}
	public var hp : Int16 { 
		get { return FlatBufferReaderFast.get(buffer, myOffset, propertyIndex: 2, defaultValue: 100) }
		set { try!FlatBufferReaderFast.set(UnsafeMutablePointer<UInt8>(buffer), myOffset, propertyIndex: 2, value: newValue) }
	}
	public var name : UnsafeBufferPointer<UInt8>? { get { return FlatBufferReaderFast.getStringBuffer(buffer, FlatBufferReaderFast.getOffset(buffer, myOffset, propertyIndex:3)) } }
	public var __friendly : Bool { 
		get { return FlatBufferReaderFast.get(buffer, myOffset, propertyIndex: 4, defaultValue: false) }
		set { try!FlatBufferReaderFast.set(UnsafeMutablePointer<UInt8>(buffer), myOffset, propertyIndex: 4, value: newValue) }
	}
	public struct InventoryVector {
		private var buffer : UnsafePointer<UInt8> = nil
		private var myOffset : Offset = 0
		private let offsetList : Offset?
		private init(buffer b: UnsafePointer<UInt8>, myOffset o: Offset ) {
			buffer = b
			myOffset = o
			offsetList = FlatBufferReaderFast.getOffset(buffer, myOffset, propertyIndex: 5)
		}
		public var count : Int { get { return FlatBufferReaderFast.getVectorLength(buffer, offsetList) } }
		public subscript (index : Int) -> UInt8 {
			get {
				return FlatBufferReaderFast.getVectorScalarElement(buffer, offsetList!, index: index)
			}
			set {
				if let newValue = newValue {
					FlatBufferReaderFast.setVectorScalarElement(UnsafeMutablePointer<UInt8>(buffer), offsetList!, index: index, value: newValue)
				}
			}
		}
	}
	public lazy var inventory : InventoryVector = InventoryVector(buffer: self.buffer, myOffset: self.myOffset)
	public var color : Color? { 
		get { return Color(rawValue: FlatBufferReaderFast.get(buffer, myOffset, propertyIndex: 6, defaultValue: Color.Blue.rawValue)) }
		set {
			if let newValue = newValue {
				try!FlatBufferReaderFast.set(UnsafeMutablePointer<UInt8>(buffer), myOffset, propertyIndex: 6, value: newValue.rawValue)
			}
		}
	}
	public struct WeaponsVector {
		private var buffer : UnsafePointer<UInt8> = nil
		private var myOffset : Offset = 0
		private let offsetList : Offset?
		private init(buffer b: UnsafePointer<UInt8>, myOffset o: Offset ) {
			buffer = b
			myOffset = o
			offsetList = FlatBufferReaderFast.getOffset(buffer, myOffset, propertyIndex: 7)
		}
		public var count : Int { get { return FlatBufferReaderFast.getVectorLength(buffer, offsetList) } }
		public subscript (index : Int) -> Weapon.Fast? {
			get {
				if let ofs = FlatBufferReaderFast.getVectorOffsetElement(buffer, offsetList!, index: index) {
					return Weapon.Fast(buffer: buffer, myOffset: ofs)
				}
				return nil
			}
		}
	}
	public lazy var weapons : WeaponsVector = WeaponsVector(buffer: self.buffer, myOffset: self.myOffset)
	public var equipped : Equipment_Fast? { get { 
		return create_Equipment_Fast(buffer, propertyIndex: 8, objectOffset: self.myOffset)
	} }
	public var hashValue: Int { return Int(myOffset) }
}
}
public func ==(t1 : Monster.Fast, t2 : Monster.Fast) -> Bool {
	return t1.buffer == t2.buffer && t1.myOffset == t2.myOffset
}
public extension Monster {
	private func addToByteArray(builder : FlatBufferBuilder) -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		if builder.inProgress.contains(ObjectIdentifier(self)){
			return 0
		}
		builder.inProgress.insert(ObjectIdentifier(self))
		let offset8 = addToByteArray_Equipment(builder, union: equipped)
		var offset7 = Offset(0)
		if weapons.count > 0{
			var offsets = [Offset?](count: weapons.count, repeatedValue: nil)
			var index = weapons.count - 1
			while(index >= 0){
				offsets[index] = weapons[index]?.addToByteArray(builder)
				index -= 1
			}
			try! builder.startVector(weapons.count)
			index = weapons.count - 1
			while(index >= 0){
				try! builder.putOffset(offsets[index])
				index -= 1
			}
			offset7 = builder.endVector()
		}
		var offset5 = Offset(0)
		if inventory.count > 0{
			try! builder.startVector(inventory.count)
			var index = inventory.count - 1
			while(index >= 0){
				builder.put(inventory[index])
				index -= 1
			}
			offset5 = builder.endVector()
		}
		// let offset3 = try! builder.createString(name)
		var offset3 : Offset
		if let s = name_b {
			offset3 = try! builder.createString(s)
		} else if let s = name_ss {
			offset3 = try! builder.createStaticString(s)
		} else {
			offset3 = try! builder.createString(name)
		}
		try! builder.openObject(10)
		if equipped != nil {
			try! builder.addPropertyOffsetToOpenObject(9, offset: offset8)
			try! builder.addPropertyToOpenObject(8, value : unionCase_Equipment(equipped), defaultValue : 0)
		}
		if weapons.count > 0 {
			try! builder.addPropertyOffsetToOpenObject(7, offset: offset7)
		}
		try! builder.addPropertyToOpenObject(6, value : color!.rawValue, defaultValue : 0)
		if inventory.count > 0 {
			try! builder.addPropertyOffsetToOpenObject(5, offset: offset5)
		}
		// __friendly is deprecated
		try! builder.addPropertyOffsetToOpenObject(3, offset: offset3)
		try! builder.addPropertyToOpenObject(2, value : hp, defaultValue : 100)
		try! builder.addPropertyToOpenObject(1, value : mana, defaultValue : 150)
		if let pos = pos {
			builder.put(pos)
			try! builder.addCurrentOffsetAsPropertyToOpenObject(0)
		}
		let myOffset =  try! builder.closeObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		builder.inProgress.remove(ObjectIdentifier(self))
		return myOffset
	}
}
public final class Weapon {
	public static var maxInstanceCacheSize : UInt = 0
	public static var instancePool : [Weapon] = []
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
	
	public var damage : Int16 = 0
	public init(){}
	public init(name: String?, damage: Int16){
		self.name_s = name
		self.damage = damage
	}
	public init(name: StaticString?, damage: Int16){
		self.name_ss = name
		self.damage = damage
	}
}

extension Weapon : PoolableInstances {
	public func reset() { 
		name = nil
		damage = 0
	}
}
public extension Weapon {
	private static func create(reader : FlatBufferReader, objectOffset : Offset?) -> Weapon? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if reader.config.uniqueTables {
			if let o = reader.objectPool[objectOffset]{
				return o as? Weapon
			}
		}
		let _result = Weapon.createInstance()
		if reader.config.uniqueTables {
			reader.objectPool[objectOffset] = _result
		}
		_result.name_b = reader.getStringBuffer(reader.getOffset(objectOffset, propertyIndex: 0))
		_result.damage = reader.get(objectOffset, propertyIndex: 1, defaultValue: 0)
		return _result
	}
}
public extension Weapon {
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
		public var damage : Int16 { 
			get { return _reader.get(_objectOffset, propertyIndex: 1, defaultValue:0)}
			set { try!_reader.set(_objectOffset, propertyIndex: 1, value: newValue)}
		}

		public var createEagerVersion : Weapon? { return Weapon.create(_reader, objectOffset: _objectOffset) }
		
		public var hashValue: Int { return Int(_objectOffset) }
	}
}

public func ==(t1 : Weapon.LazyAccess, t2 : Weapon.LazyAccess) -> Bool {
	return t1._objectOffset == t2._objectOffset && t1._reader === t2._reader
}

extension Weapon {
public struct Fast : Hashable {
	private var buffer : UnsafePointer<UInt8> = nil
	private var myOffset : Offset = 0
	public init(buffer: UnsafePointer<UInt8>, myOffset: Offset){
		self.buffer = buffer
		self.myOffset = myOffset
	}
	public var name : UnsafeBufferPointer<UInt8>? { get { return FlatBufferReaderFast.getStringBuffer(buffer, FlatBufferReaderFast.getOffset(buffer, myOffset, propertyIndex:0)) } }
	public var damage : Int16 { 
		get { return FlatBufferReaderFast.get(buffer, myOffset, propertyIndex: 1, defaultValue: 0) }
		set { try!FlatBufferReaderFast.set(UnsafeMutablePointer<UInt8>(buffer), myOffset, propertyIndex: 1, value: newValue) }
	}
	public var hashValue: Int { return Int(myOffset) }
}
}
public func ==(t1 : Weapon.Fast, t2 : Weapon.Fast) -> Bool {
	return t1.buffer == t2.buffer && t1.myOffset == t2.myOffset
}
public extension Weapon {
	private func addToByteArray(builder : FlatBufferBuilder) -> Offset {
		if builder.config.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		// let offset0 = try! builder.createString(name)
		var offset0 : Offset
		if let s = name_b {
			offset0 = try! builder.createString(s)
		} else if let s = name_ss {
			offset0 = try! builder.createStaticString(s)
		} else {
			offset0 = try! builder.createString(name)
		}
		try! builder.openObject(2)
		try! builder.addPropertyToOpenObject(1, value : damage, defaultValue : 0)
		try! builder.addPropertyOffsetToOpenObject(0, offset: offset0)
		let myOffset =  try! builder.closeObject()
		if builder.config.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
public protocol Equipment{}
public protocol Equipment_LazyAccess{}
public protocol Equipment_Fast{}
extension Weapon : Equipment {}
extension Weapon.LazyAccess : Equipment_LazyAccess {}
extension Weapon.Fast : Equipment_Fast {}
private func create_Equipment(reader : FlatBufferReader, propertyIndex : Int, objectOffset : Offset?) -> Equipment? {
	guard let objectOffset = objectOffset else {
		return nil
	}
	let unionCase : Int8 = reader.get(objectOffset, propertyIndex: propertyIndex, defaultValue: 0)
	guard let caseObjectOffset : Offset = reader.getOffset(objectOffset, propertyIndex:propertyIndex + 1) else {
		return nil
	}
	switch unionCase {
	case 1 : return Weapon.create(reader, objectOffset: caseObjectOffset)
	default : return nil
	}
}
private func create_Equipment_LazyAccess(reader : FlatBufferReader, propertyIndex : Int, objectOffset : Offset?) -> Equipment_LazyAccess? {
	guard let objectOffset = objectOffset else {
		return nil
	}
	let unionCase : Int8 = reader.get(objectOffset, propertyIndex: propertyIndex, defaultValue: 0)
	guard let caseObjectOffset : Offset = reader.getOffset(objectOffset, propertyIndex:propertyIndex + 1) else {
		return nil
	}
	switch unionCase {
	case 1 : return Weapon.LazyAccess(reader: reader, objectOffset: caseObjectOffset)
	default : return nil
	}
}
private func create_Equipment_Fast(buffer : UnsafePointer<UInt8>, propertyIndex : Int, objectOffset : Offset?) -> Equipment_Fast? {
	guard let objectOffset = objectOffset else {
		return nil
	}
	let unionCase : Int8 = FlatBufferReaderFast.get(buffer, objectOffset, propertyIndex: propertyIndex, defaultValue: 0)
	guard let caseObjectOffset : Offset = FlatBufferReaderFast.getOffset(buffer, objectOffset, propertyIndex:propertyIndex + 1) else {
		return nil
	}
	switch unionCase {
	case 1 : return Weapon.Fast(buffer: buffer, myOffset: caseObjectOffset)
	default : return nil
	}
}
private func unionCase_Equipment(union : Equipment?) -> Int8 {
	switch union {
	case is Weapon : return 1
	default : return 0
	}
}
private func addToByteArray_Equipment(builder : FlatBufferBuilder, union : Equipment?) -> Offset {
	switch union {
	case let u as Weapon : return u.addToByteArray(builder)
	default : return 0
	}
}
private func performLateBindings(builder : FlatBufferBuilder) {
	for binding in builder.deferedBindings {
		switch binding.object {
		case let object as Monster: try! builder.replaceOffset(object.addToByteArray(builder), atCursor: binding.cursor)
		case let object as Weapon: try! builder.replaceOffset(object.addToByteArray(builder), atCursor: binding.cursor)
		default: continue
		}
	}
}
