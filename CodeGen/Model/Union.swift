//
//  Union.swift
//  CodeGen
//
//  Created by Maxim Zaks on 19.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import Foundation

struct Union {
    let name: Ident
    let cases: [Ident]
    let metaData: MetaData?
    let comments: [Comment]
}

extension Union: ASTNode {
    static func with(pointer: UnsafePointer<UInt8>, length: Int) -> (Union, UnsafePointer<UInt8>)? {
        var p0 = pointer
        var length = length
        var comments = [Comment]()
        while let r = Comment.with(pointer: p0, length: length) {
            comments.append(r.0)
            length -= p0.distance(to: r.1)
            p0 = r.1
        }
        guard let p1 = eat("union", from: p0, length: length) else {return nil}
        length = length - p0.distance(to: p1)
        guard let (name, p2) = Ident.with(pointer: p1, length: length) else {return nil}
        length -= p1.distance(to: p2)
        var p2_1 = p2
        var metaData: MetaData? = nil
        if let r = MetaData.with(pointer: p2_1, length: length) {
            metaData = r.0
            length -= p2_1.distance(to: r.1)
            p2_1 = r.1
        }
        guard let p3 = eat("{", from: p2_1, length: length) else {return nil}
        length -= p2_1.distance(to: p3)
        var cases = [Ident]()
        var p4 = p3
        while let (_case, _p4) = Ident.with(pointer: p4, length: length) {
            cases.append(_case)
            length -= p4.distance(to: _p4)
            p4 = _p4
            guard let _p5 = eat(",", from: p4, length: length) else {break}
            length -= p4.distance(to: _p5)
            p4 = _p5
        }
        guard let p5 = eat("}", from: p4, length: length) else {return nil}
        return (Union(name: name, cases: cases, metaData: metaData, comments: comments), p5)
    }
}

extension Union {
    var swift: String {
        func genCases(_ cases: [Ident]) -> String {
            let theCases = cases.map { (ident) -> String in
                return "with\(ident.value)(\(ident.value))"
            }
            return theCases.joined(separator: ", ")
        }
        func genDirectCases(_ cases: [Ident]) -> String {
            let theCases = cases.map { (ident) -> String in
                return "with\(ident.value)(\(ident.value).Direct<R>)"
            }
            return theCases.joined(separator: ", ")
        }
        func genSwitchCases(_ caases: [Ident]) -> String {
            let theCases = cases.map { (ident) -> String in
                return """
                        case .with\(ident.value)(let o):
                            guard let o1 = \(ident.value).from(selfReader: o) else {
                                return nil
                            }
                            return .with\(ident.value)(o1)
                """
            }
            return theCases.joined(separator: "\n")
        }
        func genDirectSwitchCases(_ caases: [Ident], _ unionName: String) -> String {
            let theCases = cases.enumerated().map { (tuple) -> String in
                let ident = tuple.element
                let index = tuple.offset + 1
                return """
                            case \(index):
                                guard let o = \(ident.value).Direct<R>(reader: reader, myOffset: caseObjectOffset) else {
                                    return nil
                            }
                            return \(unionName).Direct.with\(ident.value)(o)
                """
            }
            return theCases.joined(separator: "\n")
        }
        func genAsProperties(_ cases: [Ident]) -> String {
            let properties = cases.map { (ident) -> String in
                let name = ident.value
                return """
                    var as\(name): \(name)? {
                        switch self {
                        case .with\(name)(let v):
                            return v
                        default:
                            return nil
                        }
                    }
                """
            }
            return properties.joined(separator: "\n")
        }
        func genValueProperty(_ cases: [Ident]) -> String {
            let caseStatements = cases.map { "        case .with\($0.value)(let v): return v" }.joined(separator: "\n")
            return """
                var value: AnyObject {
                    switch self {
            \(caseStatements)
                    }
                }
            """
        }
        func genDirectAsProperties(_ cases: [Ident]) -> String {
            let properties = cases.map { (ident) -> String in
                let name = ident.value
                return """
                        var as\(name): \(name).Direct<R>? {
                            switch self {
                            case .with\(name)(let v):
                                return v
                            default:
                                return nil
                            }
                        }
                """
            }
            return properties.joined(separator: "\n")
        }
        return """
        public enum \(name.value) {
            case \(genCases(cases))
            fileprivate static func from(selfReader: \(name.value).Direct<FlatBuffersMemoryReader>?) -> \(name.value)? {
                guard let selfReader = selfReader else {
                    return nil
                }
                switch selfReader {
        \(genSwitchCases(cases))
                }
            }
            public enum Direct<R : FlatBuffersReader> {
                case \(genDirectCases(cases))
                fileprivate static func from(reader: R, propertyIndex : Int, objectOffset : Offset?) -> \(name.value).Direct<R>? {
                    guard let objectOffset = objectOffset else {
                        return nil
                    }
                    let unionCase : Int8 = reader.get(objectOffset: objectOffset, propertyIndex: propertyIndex, defaultValue: 0)
                    guard let caseObjectOffset : Offset = reader.offset(objectOffset: objectOffset, propertyIndex:propertyIndex + 1) else {
                        return nil
                    }
                    switch unionCase {
        \(genDirectSwitchCases(cases, name.value))
                    default:
                        break
                    }
                    return nil
                }
        \(genDirectAsProperties(cases))
            }
            var unionCase: Int8 {
                switch self {
        \(cases.enumerated().map{"          case .with\($0.element.value)(_): return \($0.offset + 1)"}.joined(separator: "\n"))
                }
            }
            func insert(_ builder: FlatBuffersBuilder) throws -> Offset {
                switch self {
        \(cases.enumerated().map{"          case .with\($0.element.value)(let o): return try o.insert(builder)"}.joined(separator: "\n"))
                }
            }
        \(genAsProperties(cases))
        \(genValueProperty(cases))
        }
        """
    }
}
