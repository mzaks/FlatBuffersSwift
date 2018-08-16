//
//  main.swift
//  CodeGen
//
//  Created by Maxim Zaks on 10.07.17.
//  Copyright © 2017 maxim.zaks. All rights reserved.
//

import Foundation

if CommandLine.arguments.count < 2 {
    print("⚠️ Please provide path to .fbs file as first argument")
    exit(1)
}

let fbsPath = CommandLine.arguments[1]

let fbsUrl = URL(fileURLWithPath: fbsPath)

guard let fileContent = try?Data(contentsOf: fbsUrl) else {
    print("⚠️ Could not read content of the .fbs file \(fbsUrl)")
    exit(1)
}



if CommandLine.arguments.count < 3 {
    print("⚠️ Please provide path to .swift file (which you want to generate) as second argument")
    exit(1)
}

let swiftPath = CommandLine.arguments[2]
let swiftUtl = URL(fileURLWithPath: swiftPath)

print("Generating: \(fbsPath) -> \(swiftPath)")

let schema = fileContent.withUnsafeBytes { (p: UnsafePointer<UInt8>) -> Schema? in
    return Schema.with(pointer: p, length: fileContent.count)?.0
}


if let swiftFileContent = schema?.swift {
    try!swiftFileContent.data(using: .utf8)?.write(to: swiftUtl)
    print("✅ Completed")
} else {
    print("❌ Could not generate")
}

