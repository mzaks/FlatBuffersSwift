//
//  Configs.swift
//  FlatBuffersSwift
//
//  Created by Maxim Zaks on 01.05.16.
//  Copyright © 2016 maxim.zaks. All rights reserved.
//

import Foundation

public struct BinaryBuildConfig{
    public var initialCapacity = 1
    public var uniqueStrings = true
    public var uniqueTables = true
    public var uniqueVTables = true
    public init() {}
    public init(initialCapacity : Int, uniqueStrings : Bool, uniqueTables : Bool, uniqueVTables : Bool) {
        self.initialCapacity = initialCapacity
        self.uniqueStrings = uniqueStrings
        self.uniqueTables = uniqueTables
        self.uniqueVTables = uniqueVTables
    }
}

public struct BinaryReadConfig {
    public var uniqueTables = true
    public var uniqueStrings = true
    public init() {}
    public init(uniqueStrings : Bool, uniqueTables : Bool) {
        self.uniqueStrings = uniqueStrings
        self.uniqueTables = uniqueTables
    }
}
