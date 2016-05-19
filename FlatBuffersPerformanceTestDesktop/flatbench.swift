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

let iterations : UInt = 1000
let inner_loop_iterations : UInt = 1000
let bufsize = 4096
var encodedsize = 0
let readConfiguration = BinaryReadConfig(uniqueStrings: false, uniqueTables: false)
let buildConfiguration = BinaryBuildConfig(initialCapacity: bufsize, uniqueStrings: false, uniqueTables: false, uniqueVTables: false)

func flatencode(builder : FlatBufferBuilder)
{
    let veclen = 3
    var foobars = ContiguousArray<FooBar?>.init(count: veclen, repeatedValue:nil)

    for i in 0..<veclen { // 0xABADCAFEABADCAFE will overflow in usage
        let ident : UInt64 = 0xABADCAFE + UInt64(i)
        let foo = Foo(id: ident, count: 10000 + i, prefix: 64 + i, length: UInt32(1000000 + i))
        let bar = Bar(parent: foo, time: 123456 + i, ratio: 3.14159 + Float(i), size: UInt16(10000 + i))
        let name : StaticString = "Hello, World!"
        let foobar = FooBar(sibling: bar, name: name, rating: 3.1415432432445543543+Double(i), postfix: UInt8(33 + i))
        foobars[i] = foobar
    }
    
    let location : StaticString = "http://google.com/flatbuffers/"
    let foobarcontainer = FooBarContainer(list: foobars, initialized: true, fruit: Enum.Bananas, location: location)
    
    assert(builder._dataCount <= bufsize)
    foobarcontainer.toFlatBufferBuilder(builder)
}

func flatdecode(reader : FlatBufferReader) -> FooBarContainer
{
    return FooBarContainer.fromFlatBufferReader(reader)
}

func flatdecodelazy(inout buf:[UInt8], _ bufsize:Int) -> FooBarContainer.LazyAccess
{
    return buf.withUnsafeBufferPointer {
        FooBarContainer.LazyAccess(data:($0), config: readConfiguration)
    }
}

func flatuse(foobarcontainer : FooBarContainer, start : Int) -> Int
{
    var sum:Int = Int(start)
    sum = sum + Int(foobarcontainer.locationBuffer!.count)
    sum = sum + Int(foobarcontainer.fruit!.rawValue)
    sum = sum + (foobarcontainer.initialized ? 1 : 0)
    
    for i in 0..<foobarcontainer.list.count {
        let foobar = foobarcontainer.list[i]!
        sum = sum + Int(foobar.nameBuffer!.count)
        sum = sum + Int(foobar.postfix)
        sum = sum + Int(foobar.rating)
        
        let bar = foobar.sibling!
        
        sum = sum + Int(bar.ratio)
        sum = sum + Int(bar.size)
        sum = sum + Int(bar.time)
        
        let foo = bar.parent
        sum = sum + Int(foo.count)
        sum = sum + Int(foo.id)
        sum = sum + Int(foo.length)
        sum = sum + Int(foo.prefix)
    }
    return sum
}

// Just a copy-paste as we are lacking a protocol so we could write a generic implementation
func flatuselazy(foobarcontainer : FooBarContainer.LazyAccess, start : Int) -> Int
{
    var sum:Int = start
    sum = sum + Int(foobarcontainer.location!.utf8.count) // characters.count is quite expensive and misleading here
    sum = sum + Int(foobarcontainer.fruit!.rawValue)
    sum = sum + (foobarcontainer.initialized ? 1 : 0)
    
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
        sum = sum + Int(foo.id)
        sum = sum + Int(foo.length)
        sum = sum + Int(foo.prefix)
    }
    return sum
}

func flatDecodeDirect(buffer : UnsafePointer<UInt8>, start : Int) -> Int{
    
    let fooBarContainerOffset = getFooBarContainerRootOffset(buffer)
    
    var sum:Int = start
    
    sum = sum + Int(getLocationFrom(buffer, fooBarContainerOffset: fooBarContainerOffset).count)
//    sum = sum + Int(getLocationFromS(buffer, fooBarContainerOffset: fooBarContainerOffset).utf8.count)

    sum = sum + Int(getFrootFrom(buffer, fooBarContainerOffset: fooBarContainerOffset).rawValue)
    sum = sum + (getInitializedFrom(buffer, fooBarContainerOffset: fooBarContainerOffset) ? 1 : 0)
//    sum = sum + Int(getInitializedFrom(buffer, fooBarContainerOffset: fooBarContainerOffset))
    
    for i in 0..<getListCountFrom(buffer, fooBarContainerOffset: fooBarContainerOffset) {
        let foobarOffset = getFooBarOffsetFrom(buffer, fooBarContainerOffset: fooBarContainerOffset, listIndex: i)
        sum = sum + Int(getNameFrom(buffer, fooBarOffset: foobarOffset).count)
//        sum = sum + Int(getNameFromS(buffer, fooBarOffset: foobarOffset).utf8.count)
        sum = sum + Int(getPostfixFrom(buffer, fooBarOffset: foobarOffset))
        sum = sum + Int(getRatingFrom(buffer, fooBarOffset: foobarOffset))
        
        let bar = getSiblingFrom(buffer, fooBarOffset: foobarOffset)
        
        sum = sum + Int(bar.ratio)
        sum = sum + Int(bar.size)
        sum = sum + Int(bar.time)
        
        let foo = bar.parent
        sum = sum + Int(foo.count)
        sum = sum + Int(foo.id)
        sum = sum + Int(foo.length)
        sum = sum + Int(foo.prefix)
    }
    
    return sum
}

func flatuseStruct(buffer : UnsafePointer<UInt8>, start : Int) -> Int
{
    var sum:Int = start
    
    // this struct or copies of it are only valid as long as pointer
    // to the underlying data is valid
    // should use an "eager" instance for a long-term usable mutable object instance
    // if needed, but the struct interface is good for lazy stream processing
    var foobarcontainer = FooBarContainer.Fast(buffer)
    
    sum = sum + Int(foobarcontainer.location!.count)
    sum = sum + Int(foobarcontainer.fruit!.rawValue)
    sum = sum + (foobarcontainer.initialized ? 1 : 0)
    let list = foobarcontainer.list
    for i in 0..<list.count {
        let foobar = list[i]!
        sum = sum + Int(foobar.name!.count)
        sum = sum + Int(foobar.postfix)
        sum = sum + Int(foobar.rating)

        let bar = foobar.sibling!
        
        sum = sum + Int(bar.ratio)
        sum = sum + Int(bar.size)
        sum = sum + Int(bar.time)
        
        let foo = bar.parent
        sum = sum + Int(foo.count)
        sum = sum + Int(foo.id)
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

enum BenchmarkRunType {
    case lazyDecode     /// lazy object graph creation
    case eagerDecode    /// up-front object graph creation
    case directDecode     /// stream processing
    case structDecode     /// stream processing
}

func runbench(runType: BenchmarkRunType) -> (Int, Int)
{
    var encode = 0.0
    var decode = 0.0
    var use = 0.0
    var dealloc = 0.0
    var total:UInt64 = 0
    var results : ContiguousArray<FooBarContainer> = []
    var lazyResults : ContiguousArray<FooBarContainer.LazyAccess> = []
    var rawResults : ContiguousArray<UnsafePointer<UInt8>> = []
    let builder = FlatBufferBuilder.create(buildConfiguration)
    var reader : FlatBufferReader
    var buf = [UInt8](count: bufsize, repeatedValue: 0)
    
    results.reserveCapacity(Int(iterations))
    lazyResults.reserveCapacity(Int(iterations))
    rawResults.reserveCapacity(Int(iterations))
    
    // doing optional preload of instance caches
    FlatBufferBuilder.maxInstanceCacheSize = 10
    FlatBufferReader.maxInstanceCacheSize = iterations
    FooBarContainer.maxInstanceCacheSize = iterations
    FooBar.maxInstanceCacheSize = iterations * 3
    
    FooBarContainer.fillInstancePool(FooBarContainer.maxInstanceCacheSize)
    FooBar.fillInstancePool(FooBar.maxInstanceCacheSize)

    print("\(runType)")
    for _ in 0..<inner_loop_iterations {

        // Build buffers
        let time1 = CFAbsoluteTimeGetCurrent()
        for _ in 0..<iterations-1 {
            builder.reset() // we keep the last encoding to decode directly from the builder to mimic original test - no unnecessary memcpy
            flatencode(builder)
        }
        buf = Array(UnsafeBufferPointer(start: builder._dataStart, count: builder._dataCount)) // only needed for lazy
        let time2 = CFAbsoluteTimeGetCurrent()

        // Decode
        let time3 = CFAbsoluteTimeGetCurrent()

        reader = FlatBufferReader.create(builder._dataStart, count: builder._dataCount, config: readConfiguration)
        encodedsize = builder._dataCount
        
        switch runType {
        case .eagerDecode:
            for _ in 0..<iterations {
                results.append(flatdecode(reader))
            }
        case .lazyDecode:
            for _ in 0..<iterations {
                lazyResults.append(flatdecodelazy(&buf, bufsize))
            }
        case .directDecode:
            for _ in 0..<iterations {
                rawResults.append(builder._dataStart)
            }
        case .structDecode:
            for _ in 0..<iterations {
                rawResults.append(builder._dataStart)
            }
        }
        
        let time4 = CFAbsoluteTimeGetCurrent()

        // Use results
        let time5 = CFAbsoluteTimeGetCurrent()
        
        switch runType {
        case .eagerDecode:
            for i in 0..<Int(iterations) {
                var result = 0
                result = flatuse(results[i], start:i)
                assert(result == 8644311666 + Int(i))
                total = total + UInt64(result)
            }
        case .lazyDecode:
            for i in 0..<Int(iterations) {
                var result = 0
                result = flatuselazy(lazyResults[i], start:i)
                assert(result == 8644311666 + Int(i))
                total = total + UInt64(result)
            }
        case .directDecode:
            for i in 0..<Int(iterations) {
                let result = flatDecodeDirect(rawResults[i], start:i)
                assert(result == 8644311666 + Int(i))
                total = total + UInt64(result)
            }
        case .structDecode:
            for i in 0..<Int(iterations) {
                assert(rawResults[i] == UnsafePointer(builder._dataStart))
                let result = flatuseStruct(rawResults[i], start:i)
                assert(result == 8644311666 + Int(i))
                total = total + UInt64(result)
            }
        }

        let time6 = CFAbsoluteTimeGetCurrent()

        // Clean up
        let time7 = CFAbsoluteTimeGetCurrent()
        
        switch runType {
        case .eagerDecode:
            // Try to return objects to instance pool
            while (results.count > 0)
            {
                var x = results.removeLast()
                FooBarContainer.reuseInstance(&x)
            }
        case .lazyDecode:
            lazyResults.removeAll(keepCapacity:true)
        case .directDecode:
            rawResults.removeAll(keepCapacity:true)
        case .structDecode:
            rawResults.removeAll(keepCapacity:true)
        }

        FlatBufferReader.reuse(reader)
        
        let time8 = CFAbsoluteTimeGetCurrent()
        
        encode = encode + (time2 - time1)
        decode = decode + (time4 - time3)
        use = use + (time6 - time5)
        dealloc = dealloc + (time8 - time7)
    }
    
    print("=================================")
    print("\(((encode) * 1000).string(0)) ms encode")
    print("\(((decode) * 1000).string(0)) ms decode")
    print("\(((use) * 1000).string(0)) ms use")
    print("\(((dealloc) * 1000).string(0)) ms dealloc")
    print("\(((decode+use+dealloc) * 1000).string(0)) ms decode+use+dealloc")
    print("=================================")
    print("")
    return (Int(total), encodedsize)
}

func flatbench() {
    let benchMarks : [BenchmarkRunType] = [.lazyDecode, .eagerDecode, .directDecode, .structDecode]
    var total = 0
    var subtotal = 0
    var messageSize = 0
    
    print("Running a total of \(inner_loop_iterations*iterations) iterations")
    print("")
    
    for benchmark in benchMarks
    {
        (subtotal, messageSize) = runbench(benchmark)
        total = total + subtotal
    }
    
    print("")
    print("=================================")
    print("Subtotal: \(subtotal) Total: \(total)")
    print("Encoded size is \(messageSize) bytes, should be 344 if not using unique strings")
    // 344 is with proper padding https://google.github.io/flatbuffers/flatbuffers_benchmarks.html
    print("=================================")
    print("")
}
