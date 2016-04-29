//
//  LazyArray.swift
//  FlatBuffersSwift
//
//  Created by Maxim Zaks on 06.01.16.
//  Copyright © 2016 maxim.zaks. All rights reserved.
//

import Foundation

public final class LazyVector<T> : SequenceType, Indexable {
    
    public typealias Index = Int
    private let _generator : (Int)->T?
    private var values : [T?]
    private let _count : Int
    
    public init(count : Int, generator : (Int)->T?){
        _generator = generator
        values = Array<T?>.init(count: count, repeatedValue: nil)
        _count = count
    }

    public subscript(i: Index) -> T? {
        guard i >= 0 && i < _count else {
            return nil
        }
        if let value = values[i]{
            return value
        }
        let value = _generator(i)
        values[i] = value
        return value
    }
    
    public var startIndex: Index { return 0 }
    
    public var endIndex: Index { return _count - 1 }
    
    public func generate() -> AnyGenerator<T> {
        var index = 0
        
        return AnyGenerator(body: {
            let value = self[index]
            index += 1
            return value
        })
    }
}