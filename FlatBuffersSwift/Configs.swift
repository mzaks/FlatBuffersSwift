//
//  Configs.swift
//  FlatBuffersSwift
//
//  Created by Maxim Zaks on 01.05.16.
//  Copyright © 2016 maxim.zaks. All rights reserved.
//

import Foundation

public struct BinaryBuildConfig{
    public let initialCapacity : Int
    public let uniqueStrings : Bool
    public let uniqueTables : Bool
    public let uniqueVTables : Bool
    public let forceDefaults : Bool
    public let fullMemoryAlignment : Bool
    public let nullTerminatedUTF8 : Bool
    public init(initialCapacity : Int = 1, uniqueStrings : Bool = true, uniqueTables : Bool = true, uniqueVTables : Bool = true, forceDefaults : Bool = false, fullMemoryAlignment: Bool = false, nullTerminatedUTF8 : Bool = false) {
        self.initialCapacity = initialCapacity
        self.uniqueStrings = uniqueStrings
        self.uniqueTables = uniqueTables
        self.uniqueVTables = uniqueVTables
        self.forceDefaults = forceDefaults
        self.fullMemoryAlignment = fullMemoryAlignment
        self.nullTerminatedUTF8 = nullTerminatedUTF8
    }
}


public struct BinaryReadConfig {
    public let uniqueTables : Bool
    public let uniqueStrings : Bool
    public init(uniqueStrings : Bool = true, uniqueTables : Bool = true) {
        self.uniqueStrings = uniqueStrings
        self.uniqueTables = uniqueTables
    }
}
