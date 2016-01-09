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
    private var values : [T?]
    
    public init(count : Int, generator : (Int)->T?){
        _generator = generator
        values = Array<T?>.init(count: count, repeatedValue: nil)
    }

    public subscript(i: Int) -> T? {
        guard i >= 0 && i < values.count else {
            return nil
        }
        if let value = values[i]{
            return value
        }
        let value = _generator(i)
        values[i] = value
        return value
    }
    
    public var count : Int {return values.count}
    
    public func generate() -> AnyGenerator<T> {
        var index = 0
        
        return anyGenerator({
            let value = self[index]
            index += 1
            return value
        })
    }
}