# FlatBuffersSwift

[![Join the chat at https://gitter.im/mzaks/FlatBuffersSwift](https://badges.gitter.im/mzaks/FlatBuffersSwift.svg)](https://gitter.im/mzaks/FlatBuffersSwift?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

# Motivation
This project brings [FlatBuffers](https://google.github.io/flatbuffers/) (an efficient cross platform serialization library) to Swift.

# One minute introduction

There are three simple steps for you to use FlatBuffersSwift

## 1. Write a schema file

```flatbuffers
table List {
  people : [Person];
}

table Person {
  firstName : string;
  lastName : string;
}

root_type List;
```

## 2. Generated Swfit code

`java -jar fbsCG.jar -fbs contacts.fbs -out contacts.swift -lang swift`

## 3. Use the generated API

Create objects and write them to file
```swift
let p1 = Person(firstName: "Maxim", lastName: "Zaks")
let p2 = Person(firstName: "Alex", lastName: "Zaks")
let list = List(people: [p1, p2])
let fbData = list.toByteArray
NSData(bytes: UnsafePointer<UInt8>(fbData), length: fbData.count).writeToFile("list.bin", atomically: true)
```
Read data from file very efficiently
```swift
let lazyList = List.LazyAccess(data: UnsafePointer((NSData(contentsOfFile: "")?.bytes)!))
let name = lazyList.people[0]?.firstName
```

# Please check out [Wiki](https://github.com/mzaks/FlatBuffersSwift/wiki) for more information.
