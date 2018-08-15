//
//  TableGen.swift
//  FlatBuffersSwift
//
//  Created by Maxim Zaks on 22.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import Foundation

extension Table {
    
    public func swift(lookup: IdentLookup, isRoot: Bool = false, fileIdentifier: String = "nil") -> String {
        return """
        \(swiftClass(lookup:lookup))
        \(readerProtocolExtension(lookup:lookup))
        \(fromDataExtenstion(lookup:lookup, isRoot: isRoot))
        \(insertExtenstion(lookup:lookup))
        \(insertMethod(lookup:lookup, isRoot: isRoot, fileIdentifier: fileIdentifier))
        """
    }
    
    public func readerProtocolExtension(lookup: IdentLookup) -> String {
        func gen(_ fieldEnum: (String, Int, Field)) -> String {
            let fieldName = fieldEnum.0
            let index = fieldEnum.1
            let field = fieldEnum.2
            return """
                public var \(fieldName): \(protocolType(field.type, lookup)) {
            \(guardForOffset(field, index, lookup))
                    return \(accessorReturnExpression(field, index, lookup))
                }
            """
        }
        let computedFields = computeFieldNamesWithVTableIndex(
            lookup: lookup,
            withUniontypes: false)
        return """
        extension \(name.value).Direct {
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
            public static func ==<T>(t1 : \(name.value).Direct<T>, t2 : \(name.value).Direct<T>) -> Bool {
                return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
            }
        \(computedFields.map{return gen($0)}.joined(separator: "\n"))
        }
        """
    }
    
    public func swiftClass(lookup: IdentLookup) -> String {
        func genFields(fields: [Field]) -> String {
            let fieldDefs = fields.map { (field) -> String in
                return "    public var \(field.fieldName): \(field.type.swiftWithOptional)"
            }
            return fieldDefs.joined(separator: "\n")
        }
        func genInitParams(fields: [Field]) -> String {
            let params = fields.map { (field) -> String in
                var defaultValue = field.defaultValue?.value ?? field.type.defaultValue(lookup: lookup)
                if let defaultIdent = field.defaultIdent?.value {
                    defaultValue = field.type.swift + "." + defaultIdent
                }
                return "\(field.fieldName): \(field.type.swiftWithOptional) = \(defaultValue)"
            }
            return params.joined(separator: ", ")
        }
        func genInitAssignments(fields: [Field]) -> String {
            let statements = fields.map { (field) -> String in
                
                return "        self.\(field.fieldName) = \(field.fieldName)"
            }
            return statements.joined(separator: "\n")
        }
        return """
    public final class \(name.value) {
    \(genFields(fields: fields))
        public init(\(genInitParams(fields: fields))) {
    \(genInitAssignments(fields: fields))
        }
        public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
            fileprivate let _reader : T
            fileprivate let _myOffset : Offset
        }
    }
    """
    }
    
    public func fromDataExtenstion(lookup: IdentLookup, isRoot: Bool = false) -> String {
        func genPub() -> String {
            if isRoot {
                return """
                    public static func from(data: Data) -> \(name.value)? {
                        let reader = FlatBuffersMemoryReader(data: data, withoutCopy: false)
                        return \(name.value).from(selfReader: Direct<FlatBuffersMemoryReader>(reader: reader))
                    }
                """
            }
            return ""
        }
        func genAssignmentStatements(fields: [Field]) -> String {
            let statements = fields.map { (field) -> String in
                let name = field.fieldName
                if field.type.scalar != nil {
                    if field.type.vector {
                        return "        o.\(name) = selfReader.\(name).compactMap{$0}"
                    }
                    return "        o.\(name) = selfReader.\(name)"
                } else if field.type.string {
                    if field.type.vector {
                        return "        o.\(name) = selfReader.\(name).compactMap{ $0§ }"
                    }
                    return "        o.\(name) = selfReader.\(name)§"
                } else if let ref = field.type.ref {
                    if let t = lookup.tables[ref.value] {
                        if field.type.vector {
                            return "        o.\(name) = selfReader.\(name).compactMap{ \(t.name.value).from(selfReader:$0) }"
                        }
                        return "        o.\(name) = \(t.name.value).from(selfReader:selfReader.\(name))"
                    } else if let u = lookup.unions[ref.value] {
                        if field.type.vector {
                            fatalError("Union vector nos supported yet")
                        }
                        return "        o.\(name) = \(u.name.value).from(selfReader: selfReader.\(field.fieldName))"
                    } else {
                        if field.type.vector {
                            return "        o.\(name) = selfReader.\(name).compactMap{$0}"
                        }
                        return "        o.\(name) = selfReader.\(name)"
                    }
                }
                fatalError("Unexpected case")
            }
            return statements.joined(separator: "\n")
        }
        return """
    extension \(name.value) {
    \(genPub())
        fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> \(name.value)? {
            guard let selfReader = selfReader else {
                return nil
            }
            if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? \(name.value) {
                return o
            }
            let o = \(name.value)()
            selfReader._reader.cache?.objectPool[selfReader._myOffset] = o
    \(genAssignmentStatements(fields: fields))

            return o
        }
    }
    """
    }
    
    public func insertExtenstion(lookup: IdentLookup) -> String {
        func parameters(values: [(name: String, index: Int, root: Field)]) -> String {
            let results = values.filter({ (v) -> Bool in
                return v.root.isDeprecated == false
            }).map { (v) -> String in
                return "\(v.name): \(v.root.type.swiftFB(lookup: lookup)) = \(v.root.type.defaultValueFB(lookup: lookup))"
            }
            return results.joined(separator: ", ")
        }
        func insertStatements(values: [(name: String, index: Int, root: Field)]) -> String {
            let results = values.filter({ (v) -> Bool in
                return v.root.isDeprecated == false
            }).map { (v) -> String in
                if v.root.type.string ||
                    v.root.type.vector {
                    return """
                            if let \(v.name) = \(v.name) {
                                valueCursors[\(v.index)] = try self.insert(offset: \(v.name), toStartedObjectAt: \(v.index))
                            }
                    """
                }
                if  let ref = v.root.type.ref {
                    if lookup.tables[ref.value] != nil ||
                        lookup.unions[ref.value] != nil {
                        return """
                                if let \(v.name) = \(v.name) {
                                    valueCursors[\(v.index)] = try self.insert(offset: \(v.name), toStartedObjectAt: \(v.index))
                                }
                        """
                    }
                    if lookup.structs[ref.value] != nil {
                        return """
                                if let \(v.name) = \(v.name) {
                                    self.insert(value: \(v.name))
                                    valueCursors[\(v.index)] = try self.insertCurrentOffsetAsProperty(toStartedObjectAt: \(v.index))
                                }
                        """
                    }
                    if lookup.enums[ref.value] != nil {
                        return "        valueCursors[\(v.index)] = try self.insert(value: \(v.name).rawValue, defaultValue: \(v.root.type.defaultValueFB(lookup: lookup)).rawValue, toStartedObjectAt: \(v.index))"
                    }
                }
                
                if v.root.type.scalar != nil {
                    return "        valueCursors[\(v.index)] = try self.insert(value: \(v.name), defaultValue: \(v.root.type.defaultValueFB(lookup: lookup)), toStartedObjectAt: \(v.index))"
                }
                fatalError("Unexpected case")
            }
            return results.joined(separator: "\n")
        }
        let sorted = self.computeFieldNamesWithVTableIndex(lookup: lookup)
        let sortedBySize = self.computeFieldNamesWithVTableIndexSortedBySize(lookup: lookup)
        
        return """
        extension FlatBuffersBuilder {
            public func insert\(name.value)(\(parameters(values: sorted))) throws -> (Offset, [Int?]) {
                var valueCursors = [Int?](repeating: nil, count: \(sorted.count))
                try self.startObject(withPropertyCount: \(sorted.count))
        \(insertStatements(values: sortedBySize))
                return try (self.endObject(), valueCursors)
            }
        }
        """
    }
    
    public func insertMethod(lookup: IdentLookup, isRoot: Bool = false, fileIdentifier: String) -> String {
        func genOffsetAssignements(_ fields: [Field]) -> String {
            
            let statements = fields.map { (f) -> String in
                if f.type.vector {
                    if f.type.scalar != nil || f.type.isStruct(lookup) || f.type.isEnum(lookup) {
                        let typeName: String
                        if let scalar = f.type.scalar {
                            typeName = scalar.swift
                        } else if let ref = f.type.ref?.value{
                            typeName = ref
                        } else {
                            fatalError("Unexpected case")
                        }
                        
                        let dataObject = f.type.isEnum(lookup) ? "o.rawValue" : "o"
                        
                        return """
                                let \(f.fieldName): Offset?
                                if self.\(f.fieldName).isEmpty {
                                    \(f.fieldName) = nil
                                } else {
                                    try builder.startVector(count: self.\(f.fieldName).count, elementSize: MemoryLayout<\(typeName)>.stride)
                                    for o in self.\(f.fieldName).reversed() {
                                        builder.insert(value: \(dataObject))
                                    }
                                    \(f.fieldName) = builder.endVector()
                                }
                        """
                    }
                    if f.type.string || f.type.isTable(lookup) {
                        let insertStm = f.type.string ? "builder.insert(value: $0)" : "$0.insert(builder)"
                        let isRecursive = f.type.isRecursive(lookup)
                        let insertElementStm = isRecursive ? """
                                        let cursor = try builder.insert(offset: o)
                                        if o == 0 {
                                            builder.deferedBindings.append((object: self.\(f.fieldName).reversed()[index], cursor: cursor))
                                        }
                        """
                        : """
                                        try builder.insert(offset: o)
                        """
                        return """
                                let \(f.fieldName): Offset?
                                if self.\(f.fieldName).isEmpty {
                                    \(f.fieldName) = nil
                                } else {
                                    let offsets = try self.\(f.fieldName).reversed().map{ try \(insertStm) }
                                    try builder.startVector(count: self.\(f.fieldName).count, elementSize: MemoryLayout<Offset>.stride)
                                    for (\(isRecursive ? "index" : "_" ), o) in offsets.enumerated() {
                        \(insertElementStm)
                                    }
                                    \(f.fieldName) = builder.endVector()
                                }
                        """
                    }
                }
                if f.type.string {
                    return "        let \(f.fieldName) = self.\(f.fieldName) == nil ? nil : try builder.insert(value: self.\(f.fieldName))"
                }
                if f.type.isTable(lookup) {
                    return "        let \(f.fieldName) = try self.\(f.fieldName)?.insert(builder)"
                }
                if f.type.isUnion(lookup) {
                    return """
                            let \(f.fieldName) = try self.\(f.fieldName)?.insert(builder)
                            let \(f.fieldName)_type = self.\(f.fieldName)?.unionCase ?? 0
                    """
                }
                fatalError("Unexpected Case")
            }
            return statements.joined(separator: "\n")
        }

        func genCheckForLateBindings(lookup: IdentLookup, sorted: [(name: String, index: Int, root: Field)]) -> String {
            let statements = sorted.compactMap { f -> String? in
                if f.root.type.vector {
                    return nil
                }
                guard f.root.type.isRecursive(lookup) else { return nil }
                let isUnion = f.root.type.isUnion(lookup)
                return """
                        if \(f.root.fieldName) == 0,
                           let o = self.\(f.root.fieldName),
                           let cursor = valueCursors[\(f.index)] {
                            builder.deferedBindings.append((\(isUnion ? "o.value" : "o"), cursor))
                        }
                """
            }
            return statements.joined(separator: "\n")
        }

        func parameters(values: [(name: String, index: Int, root: Field)]) -> String {
            let results = values.filter({ (v) -> Bool in
                return v.root.isDeprecated == false
            }).map { (v) -> String in
                var rightHand = v.name
                if !v.root.type.vector {
                    if v.root.type.isEnum(lookup) {
                        rightHand = "\(v.name) ?? \(v.root.type.defaultValueFB(lookup: lookup))"
                    }
                }
                
                return "            \(v.name): \(rightHand)"
            }
            return results.joined(separator: ",\n")
        }

        let isRecursive = findCycle(lookup: lookup, visited: [])

        func inserRootMethods(_ fileIdentifier: String) -> String {
            if isRoot {
                let escapedFileIdentifier = fileIdentifier == "nil" ? fileIdentifier : "\"\(fileIdentifier)\""
                return """
                    public func makeData(withOptions options : FlatBuffersBuilderOptions = FlatBuffersBuilderOptions()) throws -> Data {
                        let builder = FlatBuffersBuilder(options: options)
                        let offset = try insert(builder)
                        try builder.finish(offset: offset, fileIdentifier: \(escapedFileIdentifier))
                        \(isRecursive ? "try performLateBindings(builder)" : "")
                        return builder.makeData
                    }
                """
            } else {
                return ""
            }
        }

        let monitorProgressStart = isRecursive ? """
                if builder.inProgress.contains(ObjectIdentifier(self)){
                    return 0
                }
                builder.inProgress.insert(ObjectIdentifier(self))
        """ : ""
        
        let monitorProgressEnd = isRecursive ? """
                builder.inProgress.remove(ObjectIdentifier(self))
        """ : ""
        
        let offsetBasedFields = fields.filter { (f) -> Bool in
            if f.type.string || f.type.vector {
                return true
            }
            if let ref = f.type.ref?.value {
                return lookup.tables[ref] != nil ||
                    lookup.unions[ref] != nil
            }
            
            return false
        }
        
        let sorted = self.computeFieldNamesWithVTableIndex(lookup: lookup)

        let hasRecursiveProperties = isRecursive && sorted.filter{ $0.root.type.vector == false && $0.root.type.isRecursive(lookup)}.isEmpty == false
        
        return """
        extension \(name.value) {
            func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
                if builder.options.uniqueTables {
                    if let myOffset = builder.cache[ObjectIdentifier(self)] {
                        return myOffset
                    }
                }
        \(monitorProgressStart)
        \(genOffsetAssignements(offsetBasedFields))
                let (myOffset, \(hasRecursiveProperties ? "valueCursors" : "_")) = try builder.insert\(name.value)(
        \(parameters(values: sorted))
                )
        \(isRecursive ? genCheckForLateBindings(lookup: lookup, sorted: sorted) : "")
                if builder.options.uniqueTables {
                    builder.cache[ObjectIdentifier(self)] = myOffset
                }
        \(monitorProgressEnd)
                return myOffset
            }
        \(inserRootMethods(fileIdentifier))
        }
        """
    }
    
    private func protocolType(_ type : Type, _ lookup: IdentLookup) -> String {
        
        if type.string {
            if type.vector {
                return "FlatBuffersStringVector<T>"
            }
            return "UnsafeBufferPointer<UInt8>?"
        }
        if let ref = type.ref {
            let t = Type(scalar: nil, vector: false, ref: ref, string: false)
            if lookup.tables[ref.value] != nil {
                if type.vector {
                    return "FlatBuffersTableVector<\(t.swift+".Direct<T>"), T>"
                }
                return t.swift + ".Direct<T>?"
            } else if lookup.structs[ref.value] != nil {
                if type.vector {
                    return "FlatBuffersScalarVector<\(t.swift), T>"
                }
                return t.swift + "?"
            } else if let e = lookup.enums[ref.value] {
                if type.vector {
                    return "FlatBuffersEnumVector<\(e.type.swift), T, \(ref.value)>"
                }
                return ref.value + "?"
            } else if let _ = lookup.unions[ref.value] {
                if type.vector {
                    fatalError("Union Vector is not supported yet")
                }
                return ref.value + ".Direct<T>?"
            }
            
            fatalError("Unexpected Type")
        }
        if type.scalar != nil && type.vector {
            let t = Type(scalar: type.scalar, vector: false, ref: nil, string: false)
            return "FlatBuffersScalarVector<\(t.swift), T>"
        }
        return type.swift
        
    }
    
    private func guardForOffset(_ field: Field, _ index: Int, _ lookup: IdentLookup) -> String {
        if field.type.vector {
            return ""
        }
        guard field.type.string || field.type.ref != nil else {
            return ""
        }
        if let ref = field.type.ref, lookup.tables[ref.value] == nil {
            return ""
        }
        return "        guard let offset = _reader.offset(objectOffset: _myOffset, propertyIndex:\(index)) else {return nil}"
    }
    
    private func accessorReturnExpression(_ field: Field, _ index: Int, _ lookup: IdentLookup) -> String {
        let index = field.id ?? index.description
        if let scalar = field.type.scalar {
            if field.type.vector {
                return "FlatBuffersScalarVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:\(index)))"
            }
            let defaultValue = field.defaultValue?.value ?? scalar.defaultValue
            return "_reader.get(objectOffset: _myOffset, propertyIndex: \(index), defaultValue: \(defaultValue))"
        }
        if field.type.string {
            if field.type.vector {
                return "FlatBuffersStringVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:\(index)))"
            }
            return "_reader.stringBuffer(stringOffset: offset)"
        }
        if let ref = field.type.ref {
            let t = Type(scalar: nil, vector: false, ref: ref, string: false)
            if lookup.tables[ref.value] != nil {
                if field.type.vector {
                    return "FlatBuffersTableVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:\(index)))"
                }
                return t.swift + ".Direct(reader: _reader, myOffset: offset)"
            } else if lookup.structs[ref.value] != nil {
                if field.type.vector {
                    return "FlatBuffersScalarVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:\(index)))"
                }
                return "_reader.get(objectOffset: _myOffset, propertyIndex: \(index))"
            } else if let e = lookup.enums[ref.value] {
                if field.type.vector {
                    return "FlatBuffersEnumVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:\(index)))"
                }
                let defaultCase = field.defaultIdent?.value ?? e.cases[0].ident.value
                let enumName = e.name.value
                return "\(enumName)(rawValue:_reader.get(objectOffset: _myOffset, propertyIndex: \(index), defaultValue: \(enumName).\(defaultCase).rawValue))"
            } else if lookup.unions[ref.value] != nil {
                if field.type.vector {
                    fatalError("Vector of unions is not supported yet")
                }
                return t.swift + ".Direct.from(reader: _reader, propertyIndex : \(index), objectOffset : _myOffset)"
            }
        }
        fatalError("Unexpeceted type")
    }
}
