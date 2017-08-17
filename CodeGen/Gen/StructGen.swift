//
//  Struct.swift
//  CodeGen
//
//  Created by Maxim Zaks on 22.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import Foundation

extension Struct {
    var swift: String {
        if fields.isEmpty {fatalError("struct \(name.value) has no fields")}
        for field in fields {
            if field.defaultIdent != nil || field.defaultValue != nil {fatalError("struct \(name.value).\(field.name.value) has a default value")}
            if field.type.string {fatalError("struct \(name.value).\(field.name.value) is a string")}
            if field.type.ref?.value == name.value {fatalError("struct \(name.value).\(field.name.value) is recursive")}
        }
        func genFields(_ fields: [Field]) -> String {
            let fieldStrings = fields.map {
                "    public let \($0.name.value): \($0.type.swift)"
            }
            return fieldStrings.joined(separator: "\n")
        }
        func genEquals(_ fields: [Field], _ typeName: String) -> String {
            let fieldStrings = fields.map {
                return "v1.\($0.name.value)==v2.\($0.name.value)"
            }
            return """
                public static func ==(v1:\(typeName), v2:\(typeName)) -> Bool {
                    return \(fieldStrings.joined(separator: " && "))
                }
            """
        }
        return """
        public struct \(name.value): Scalar {
        \(genFields(fields))
        \(genEquals(fields, name.value))
        }
        """
    }
}
