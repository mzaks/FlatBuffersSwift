//
//  LazyArray.swift
//  FlatBuffersSwift
//
//  Created by Maxim Zaks on 06.01.16.
//  Copyright © 2016 maxim.zaks. All rights reserved.
//

import Foundation

public final class LazyVector<T> : SequenceType {
    private let _generator : (Int)->T?
    private let _count : Int
    
    public init(count : Int, generator : (Int)->T?){
        _generator = generator
        _count = count
    }
    
    public subscript(i: Int) -> T? {
        guard i >= 0 && i < _count else {
            return nil
        }
        return _generator(i)
    }
    
    public var count : Int {return _count}
    
    public func generate() -> AnyGenerator<T> {
        var index = 0
        
        return AnyGenerator(body: { [self]
            let value = self[index]
            index += 1
            return value
        })
    }
}