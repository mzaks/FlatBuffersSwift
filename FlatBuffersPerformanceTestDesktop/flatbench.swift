//
//  flatbench.swift
//  FlatBuffersSwift
//
//  Created by Joakim Hassila on 2016-04-27.
//
//  Reimplementation of parts of the Flatbuffers C++ Benchmark in Swift
//  to get somewhat comparable performance numbers for both eager and lazy variants
//  based on the implementation from https://github.com/google/flatbuffers/tree/benchmarks/benchmarks/cpp

import Foundation

let iterations = 1000
let inner_loop_iterations = 1000
let bufsize = 4096
var buf = [UInt8](count: bufsize, repeatedValue: 0)
var encodedsize = 0

func flatencode(inout buf:[UInt8], _ bufsize:Int)
{
    let veclen = 3
    var foobars : [FooBar?] = Array(count: veclen, repeatedValue:nil)

    for i in 0..<veclen { // 0xABADCAFEABADCAFE will overflow in usage
        let ident : UInt64 = 0xABADCAFE + UInt64(i)
        let foo = Foo(i_d: ident, count: 10000 + i, prefix: 64 + i, length: UInt32(1000000 + i))
        let bar = Bar(parent: foo, time: 123456 + i, ratio: 3.14159 + Float(i), size: UInt16(10000 + i))
        let name = "Hello, World!"
        let foobar = FooBar(sibling: bar, name: name, rating: 3.1415432432445543543+Double(i), postfix: UInt8(33 + i))
        foobars[i] = foobar
    }
    
    let location = "http://google.com/flatbuffers/"
    let foobarcontainer = FooBarContainer(list: foobars, initialized: true, fruit: Enum.Bananas, location: location)
    
    buf = foobarcontainer.toByteArray(BinaryBuildConfig(initialCapacity: 512, uniqueStrings: false, uniqueTables: false, uniqueVTables: false))
}

func flatdecode(inout buf:[UInt8], _ bufsize:Int) -> FooBarContainer
{
    return FooBarContainer.fromByteArray(UnsafePointer(buf), config: BinaryReadConfig(uniqueStrings: false, uniqueTables: false))
}

func flatdecodelazy(inout buf:[UInt8], _ bufsize:Int) -> FooBarContainer.LazyAccess
{
    return FooBarContainer.LazyAccess(data: UnsafePointer(buf), config: BinaryReadConfig(uniqueStrings: false, uniqueTables: false))
}

func flatuse(foobarcontainer : FooBarContainer) -> Int
{
    var sum:Int = 1
    sum = sum + Int(foobarcontainer.location!.utf8.count) // characters.count is quite expensive and misleading here
    sum = sum + Int(foobarcontainer.fruit!.rawValue)
    sum = sum + Int(foobarcontainer.initialized)
    
    for i in 0..<foobarcontainer.list.count {
        let foobar = foobarcontainer.list[i]!
        sum = sum + Int(foobar.name!.utf8.count) // characters.count is quite expensive and misleading here
        sum = sum + Int(foobar.postfix)
        sum = sum + Int(foobar.rating)
        
        let bar = foobar.sibling!
        
        sum = sum + Int(bar.ratio)
        sum = sum + Int(bar.size)
        sum = sum + Int(bar.time)
        
        let foo = bar.parent
        sum = sum + Int(foo.count)
        sum = sum + Int(foo.i_d)
        sum = sum + Int(foo.length)
        sum = sum + Int(foo.prefix)
    }
    return sum
}

// Just a copy-paste as we are lacking a protocol so we could write a generic implementation
func flatuselazy(foobarcontainer : FooBarContainer.LazyAccess) -> Int
{
    var sum:Int = 1
    sum = sum + Int(foobarcontainer.location!.utf8.count) // characters.count is quite expensive and misleading here
    sum = sum + Int(foobarcontainer.fruit!.rawValue)
    sum = sum + Int(foobarcontainer.initialized)
    
    for i in 0..<foobarcontainer.list.count {
        let foobar = foobarcontainer.list[i]!
        sum = sum + Int(foobar.name!.utf8.count) // characters.count is quite expensive and misleading here
        sum = sum + Int(foobar.postfix)
        sum = sum + Int(foobar.rating)
        
        let bar = foobar.sibling!
        
        sum = sum + Int(bar.ratio)
        sum = sum + Int(bar.size)
        sum = sum + Int(bar.time)
        
        let foo = bar.parent
        sum = sum + Int(foo.count)
        sum = sum + Int(foo.i_d)
        sum = sum + Int(foo.length)
        sum = sum + Int(foo.prefix)
    }
    return sum
}

// convenience formatter
extension Double {
    func string(fractionDigits:Int) -> String {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        formatter.minimumIntegerDigits = 1
        return formatter.stringFromNumber(self) ?? "\(self)"
    }
}

func runbench(lazyrun: BooleanType)
{
    var encode = 0.0
    var decode = 0.0
    var use = 0.0
    var dealloc = 0.0
    var total:UInt64 = 0
    var results : [FooBarContainer] = []
    var lazyresults : [FooBarContainer.LazyAccess] = []
    
    results.reserveCapacity(iterations)
    lazyresults.reserveCapacity(iterations)
    
    for _ in 0..<inner_loop_iterations {
        
        let time1 = NSDate()
        for _ in 0..<iterations {
            flatencode(&buf, bufsize)
        }
        let time2 = NSDate()
        
        encodedsize = buf.count
        
        let time3 = NSDate()
        for _ in 0..<iterations {
            if lazyrun {
                lazyresults.append(flatdecodelazy(&buf, bufsize))
            }
            else
            {
                results.append(flatdecode(&buf, bufsize))
            }
        }
        let time4 = NSDate()
        
        let time5 = NSDate()
        for index in 0..<iterations {
            var result = 0
            if lazyrun {
                result = flatuselazy(lazyresults[index])
            }
            else
            {
                result = flatuse(results[index])
            }
            assert(result == 8644311667)
            total = total + UInt64(result)
        }
        let time6 = NSDate()
        
        let time7 = NSDate()
        results.removeAll(keepCapacity:true)
        lazyresults.removeAll(keepCapacity:true)
        let time8 = NSDate()
        
        encode = encode + (time2.timeIntervalSince1970 - time1.timeIntervalSince1970)
        decode = decode + (time4.timeIntervalSince1970 - time3.timeIntervalSince1970)
        use = use + (time6.timeIntervalSince1970 - time5.timeIntervalSince1970)
        dealloc = dealloc + (time8.timeIntervalSince1970 - time7.timeIntervalSince1970)
    }
    
    print("=================================")
    print("\(((encode) * 1000).string(0)) ms encode")
    print("\(((decode) * 1000).string(0)) ms decode")
    print("\(((use) * 1000).string(0)) ms use")
    print("\(((dealloc) * 1000).string(0)) ms dealloc")
    print("\(((decode+use+dealloc) * 1000).string(0)) ms decode+use+dealloc")
    print("=================================")
    print("Total counter is \(total)") // just to make sure we dont get optimized out
    print("Encoded size is \(encodedsize) bytes, should be 344 if not using unique strings") // 344 is with proper padding https://google.github.io/flatbuffers/flatbuffers_benchmarks.html
    print("=================================")
    print("")
}

func flatbench() {
    print("Running a total of \(inner_loop_iterations*iterations) iterations")
    print("")
    
    print("Lazy run")
    runbench(true)
    
    print("Eager run")
    runbench(false)
    print("")
}
