//
//  main.swift
//  CodeGen
//
//  Created by Maxim Zaks on 10.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import Foundation

print(CommandLine.argc)

print(CommandLine.arguments)

if CommandLine.arguments.count < 2 {
    print("Pleas provide path to .fbs file as first!!!")
    exit(1)
}

let fbsPath = CommandLine.arguments[1]

let fbsUrl = URL(fileURLWithPath: fbsPath)

guard let fileContent = try?Data(contentsOf: fbsUrl) else {
    print("Could not read content of the .fbs file \(fbsUrl)")
    exit(1)
}

print(fbsPath)

if CommandLine.arguments.count < 3 {
    print("Pleas provide path to .swift file as second argument!!!")
    exit(1)
}

let swiftPath = CommandLine.arguments[2]
let swiftUtl = URL(fileURLWithPath: swiftPath)

let schema = fileContent.withUnsafeBytes { (p: UnsafePointer<UInt8>) -> Schema? in
    return Schema.with(pointer: p, length: fileContent.count)?.0
}


if let swiftFileContent = schema?.swift {
    try!swiftFileContent.data(using: .utf8)?.write(to: swiftUtl)
}

