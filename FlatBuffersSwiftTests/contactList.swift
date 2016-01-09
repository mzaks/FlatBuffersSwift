import FlatBuffersSwift

public final class ContactList {
    public var lastModified : Int64 = 0
    public var entries : [Contact?] = []
}
public extension ContactList {
    private static func create(reader : FlatBufferReader, objectOffset : ObjectOffset?) -> ContactList? {
        guard let objectOffset = objectOffset else {
            return nil
        }
        let _result = ContactList()
        _result.lastModified = reader.get(objectOffset, propertyIndex: 0, defaultValue: 0)
        let offset_entries : VectorOffset? = reader.getOffset(objectOffset, propertyIndex: 1)
        let length_entries = reader.getVectorLength(offset_entries)
        if(length_entries > 0){
            var index = 0
            while index < length_entries {
                _result.entries.append(Contact.create(reader, objectOffset: reader.getVectorOffsetElement(offset_entries!, index: index)))
                index += 1
            }
        }
        return _result
    }
}
public extension ContactList {
    public static func FromByteArray(data : UnsafePointer<UInt8>) -> ContactList {
        let reader = FlatBufferReader(bytes: data)
        let objectOffset = reader.rootObjectOffset
        return create(reader, objectOffset : objectOffset)!
    }
}
public extension ContactList {
    public final class LazyAccess{
        private let _reader : FlatBufferReader!
        private let _objectOffset : ObjectOffset!
        public init(data : UnsafePointer<UInt8>){
            _reader = FlatBufferReader(bytes: data)
            _objectOffset = _reader.rootObjectOffset
        }
        private init?(reader : FlatBufferReader, objectOffset : ObjectOffset?){
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
            let vectorOffset : VectorOffset? = self._reader.getOffset(self._objectOffset, propertyIndex: 1)
            let vectorLength = self._reader.getVectorLength(vectorOffset)
            return LazyVector(count: vectorLength){
                Contact.LazyAccess(reader: self._reader, objectOffset : self._reader.getVectorOffsetElement(vectorOffset!, index: $0))
            }
        }()
        
        public lazy var createEagerVersion : ContactList? = ContactList.create(self._reader, objectOffset: self._objectOffset)
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
}
public extension Contact {
    private static func create(reader : FlatBufferReader, objectOffset : ObjectOffset?) -> Contact? {
        guard let objectOffset = objectOffset else {
            return nil
        }
        let _result = Contact()
        _result.name = reader.getString(reader.getOffset(objectOffset, propertyIndex: 0))
        _result.birthday = Date.create(reader, objectOffset: reader.getOffset(objectOffset, propertyIndex: 1))
        _result.gender = Gender(rawValue: reader.get(objectOffset, propertyIndex: 2, defaultValue: Gender.Male.rawValue))
        let offset_tags : VectorOffset? = reader.getOffset(objectOffset, propertyIndex: 3)
        let length_tags = reader.getVectorLength(offset_tags)
        if(length_tags > 0){
            var index = 0
            while index < length_tags {
                _result.tags.append(reader.getString(reader.getVectorOffsetElement(offset_tags!, index: index)))
                index += 1
            }
        }
        let offset_addressEntries : VectorOffset? = reader.getOffset(objectOffset, propertyIndex: 4)
        let length_addressEntries = reader.getVectorLength(offset_addressEntries)
        if(length_addressEntries > 0){
            var index = 0
            while index < length_addressEntries {
                _result.addressEntries.append(AddressEntry.create(reader, objectOffset: reader.getVectorOffsetElement(offset_addressEntries!, index: index)))
                index += 1
            }
        }
        _result.currentLoccation = GeoLocation(
            latitude : reader.getStructProperty(objectOffset, propertyIndex: 5, structPropertyOffset: 0, defaultValue: 0),
            longitude : reader.getStructProperty(objectOffset, propertyIndex: 5, structPropertyOffset: 8, defaultValue: 0),
            elevation : reader.getStructProperty(objectOffset, propertyIndex: 5, structPropertyOffset: 16, defaultValue: 0)
        )
        let offset_previousLocations : VectorOffset? = reader.getOffset(objectOffset, propertyIndex: 6)
        let length_previousLocations = reader.getVectorLength(offset_previousLocations)
        if(length_previousLocations > 0){
            var index = 0
            while index < length_previousLocations {
                _result.previousLocations.append(GeoLocation(
                    latitude : reader.getVectorStructElement(offset_previousLocations!, vectorIndex: index, structSize: 20, structElementIndex: 0),
                    longitude : reader.getVectorStructElement(offset_previousLocations!, vectorIndex: index, structSize: 20, structElementIndex: 8),
                    elevation : reader.getVectorStructElement(offset_previousLocations!, vectorIndex: index, structSize: 20, structElementIndex: 16)
                    ))
                index += 1
            }
        }
        let offset_moods : VectorOffset? = reader.getOffset(objectOffset, propertyIndex: 7)
        let length_moods = reader.getVectorLength(offset_moods)
        if(length_moods > 0){
            var index = 0
            while index < length_moods {
                _result.moods.append(Mood(rawValue: reader.getVectorScalarElement(offset_moods!, index: index)))
                index += 1
            }
        }
        return _result
    }
}
public extension Contact {
    public final class LazyAccess{
        private let _reader : FlatBufferReader!
        private let _objectOffset : ObjectOffset!
        private init?(reader : FlatBufferReader, objectOffset : ObjectOffset?){
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
            let vectorOffset : VectorOffset? = self._reader.getOffset(self._objectOffset, propertyIndex: 3)
            let vectorLength = self._reader.getVectorLength(vectorOffset)
            return LazyVector(count: vectorLength){
                self._reader.getString(self._reader.getVectorOffsetElement(vectorOffset!, index: $0))
            }
        }()
        public lazy var addressEntries : LazyVector<AddressEntry.LazyAccess> = {
            let vectorOffset : VectorOffset? = self._reader.getOffset(self._objectOffset, propertyIndex: 4)
            let vectorLength = self._reader.getVectorLength(vectorOffset)
            return LazyVector(count: vectorLength){
                AddressEntry.LazyAccess(reader: self._reader, objectOffset : self._reader.getVectorOffsetElement(vectorOffset!, index: $0))
            }
        }()
        public lazy var currentLoccation : GeoLocation? = self._reader.hasProperty(self._objectOffset, propertyIndex: 5) ? GeoLocation(
            latitude : self._reader.getStructProperty(self._objectOffset, propertyIndex: 5, structPropertyOffset: 0, defaultValue: 0),
            longitude : self._reader.getStructProperty(self._objectOffset, propertyIndex: 5, structPropertyOffset: 8, defaultValue: 0),
            elevation : self._reader.getStructProperty(self._objectOffset, propertyIndex: 5, structPropertyOffset: 16, defaultValue: 0)
            ) : nil
        public lazy var previousLocations : LazyVector<GeoLocation> = {
            let vectorOffset : VectorOffset? = self._reader.getOffset(self._objectOffset, propertyIndex: 6)
            let vectorLength = self._reader.getVectorLength(vectorOffset)
            return LazyVector(count: vectorLength){
                GeoLocation(
                    latitude : self._reader.getVectorStructElement(vectorOffset!, vectorIndex: $0, structSize: 20, structElementIndex: 0),
                    longitude : self._reader.getVectorStructElement(vectorOffset!, vectorIndex: $0, structSize: 20, structElementIndex: 8),
                    elevation : self._reader.getVectorStructElement(vectorOffset!, vectorIndex: $0, structSize: 20, structElementIndex: 16)
                )
            }
        }()
        public lazy var moods : LazyVector<Mood> = {
            let vectorOffset : VectorOffset? = self._reader.getOffset(self._objectOffset, propertyIndex: 7)
            let vectorLength = self._reader.getVectorLength(vectorOffset)
            return LazyVector(count: vectorLength){
                Mood(rawValue: self._reader.getVectorScalarElement(vectorOffset!, index: $0))
            }
        }()
        
        public lazy var createEagerVersion : Contact? = Contact.create(self._reader, objectOffset: self._objectOffset)
    }
}
public final class Date {
    public var day : Int8 = 0
    public var month : Int8 = 0
    public var year : Int16 = 0
}
public extension Date {
    private static func create(reader : FlatBufferReader, objectOffset : ObjectOffset?) -> Date? {
        guard let objectOffset = objectOffset else {
            return nil
        }
        let _result = Date()
        _result.day = reader.get(objectOffset, propertyIndex: 0, defaultValue: 0)
        _result.month = reader.get(objectOffset, propertyIndex: 1, defaultValue: 0)
        _result.year = reader.get(objectOffset, propertyIndex: 2, defaultValue: 0)
        return _result
    }
}
public extension Date {
    public final class LazyAccess{
        private let _reader : FlatBufferReader!
        private let _objectOffset : ObjectOffset!
        private init?(reader : FlatBufferReader, objectOffset : ObjectOffset?){
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
    }
}
public struct GeoLocation {
    public var latitude : Float64
    public var longitude : Float64
    public var elevation : Float32
}
public final class AddressEntry {
    public var order : Int32 = 0
    public var address : Address? = nil
}
public extension AddressEntry {
    private static func create(reader : FlatBufferReader, objectOffset : ObjectOffset?) -> AddressEntry? {
        guard let objectOffset = objectOffset else {
            return nil
        }
        let _result = AddressEntry()
        _result.order = reader.get(objectOffset, propertyIndex: 0, defaultValue: 0)
        _result.address = create_Address(reader, propertyIndex: 1, objectOffset: objectOffset)
        return _result
    }
}
public extension AddressEntry {
    public final class LazyAccess{
        private let _reader : FlatBufferReader!
        private let _objectOffset : ObjectOffset!
        private init?(reader : FlatBufferReader, objectOffset : ObjectOffset?){
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
    }
}
public final class PostalAddress {
    public var country : String? = nil
    public var city : String? = nil
    public var postalCode : Int32 = 0
    public var streetAndNumber : String? = nil
}
public extension PostalAddress {
    private static func create(reader : FlatBufferReader, objectOffset : ObjectOffset?) -> PostalAddress? {
        guard let objectOffset = objectOffset else {
            return nil
        }
        let _result = PostalAddress()
        _result.country = reader.getString(reader.getOffset(objectOffset, propertyIndex: 0))
        _result.city = reader.getString(reader.getOffset(objectOffset, propertyIndex: 1))
        _result.postalCode = reader.get(objectOffset, propertyIndex: 2, defaultValue: 0)
        _result.streetAndNumber = reader.getString(reader.getOffset(objectOffset, propertyIndex: 3))
        return _result
    }
}
public extension PostalAddress {
    public final class LazyAccess{
        private let _reader : FlatBufferReader!
        private let _objectOffset : ObjectOffset!
        private init?(reader : FlatBufferReader, objectOffset : ObjectOffset?){
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
    }
}
public final class EmailAddress {
    public var mailto : String? = nil
}
public extension EmailAddress {
    private static func create(reader : FlatBufferReader, objectOffset : ObjectOffset?) -> EmailAddress? {
        guard let objectOffset = objectOffset else {
            return nil
        }
        let _result = EmailAddress()
        _result.mailto = reader.getString(reader.getOffset(objectOffset, propertyIndex: 0))
        return _result
    }
}
public extension EmailAddress {
    public final class LazyAccess{
        private let _reader : FlatBufferReader!
        private let _objectOffset : ObjectOffset!
        private init?(reader : FlatBufferReader, objectOffset : ObjectOffset?){
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
    }
}
public final class WebAddress {
    public var url : String? = nil
}
public extension WebAddress {
    private static func create(reader : FlatBufferReader, objectOffset : ObjectOffset?) -> WebAddress? {
        guard let objectOffset = objectOffset else {
            return nil
        }
        let _result = WebAddress()
        _result.url = reader.getString(reader.getOffset(objectOffset, propertyIndex: 0))
        return _result
    }
}
public extension WebAddress {
    public final class LazyAccess{
        private let _reader : FlatBufferReader!
        private let _objectOffset : ObjectOffset!
        private init?(reader : FlatBufferReader, objectOffset : ObjectOffset?){
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
    }
}
public final class TelephoneNumber {
    public var number : String? = nil
}
public extension TelephoneNumber {
    private static func create(reader : FlatBufferReader, objectOffset : ObjectOffset?) -> TelephoneNumber? {
        guard let objectOffset = objectOffset else {
            return nil
        }
        let _result = TelephoneNumber()
        _result.number = reader.getString(reader.getOffset(objectOffset, propertyIndex: 0))
        return _result
    }
}
public extension TelephoneNumber {
    public final class LazyAccess{
        private let _reader : FlatBufferReader!
        private let _objectOffset : ObjectOffset!
        private init?(reader : FlatBufferReader, objectOffset : ObjectOffset?){
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
private func create_Address(reader : FlatBufferReader, propertyIndex : Int, objectOffset : ObjectOffset?) -> Address? {
    guard let objectOffset = objectOffset else {
        return nil
    }
    let unionCase : Int8 = reader.get(objectOffset, propertyIndex: propertyIndex, defaultValue: 0)
    guard let caseObjectOffset : ObjectOffset = reader.getOffset(objectOffset, propertyIndex:propertyIndex + 1) else {
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
private func create_Address_LazyAccess(reader : FlatBufferReader, propertyIndex : Int, objectOffset : ObjectOffset?) -> Address_LazyAccess? {
    guard let objectOffset = objectOffset else {
        return nil
    }
    let unionCase : Int8 = reader.get(objectOffset, propertyIndex: propertyIndex, defaultValue: 0)
    guard let caseObjectOffset : ObjectOffset = reader.getOffset(objectOffset, propertyIndex:propertyIndex + 1) else {
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
