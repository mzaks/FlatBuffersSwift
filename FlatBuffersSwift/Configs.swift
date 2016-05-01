//
//  Configs.swift
//  FlatBuffersSwift
//
//  Created by Maxim Zaks on 01.05.16.
//  Copyright © 2016 maxim.zaks. All rights reserved.
//

import Foundation

public struct BinaryBuildConfig{
    var initialCapacity = 1
    var uniqueStrings = true
    var uniqueTables = true
    var uniqueVTables = true
}

public struct BinaryReadConfig {
    var uniqueTables = true
    var uniqueStrings = true
}
