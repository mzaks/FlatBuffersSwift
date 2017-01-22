# FlatBuffersSwift

[![Join the chat at https://gitter.im/mzaks/FlatBuffersSwift](https://badges.gitter.im/mzaks/FlatBuffersSwift.svg)](https://gitter.im/mzaks/FlatBuffersSwift?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Build Status](https://travis-ci.org/mzaks/FlatBuffersSwift.svg?branch=master)](https://travis-ci.org/mzaks/FlatBuffersSwift)

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

## 2. Generate Swift code

`java -jar fbsCG.jar -fbs contacts.fbs -out contacts.swift -lang swift`

## 3. Use the generated API

Create objects and encode them
```swift
let p1 = Person(firstName: "Maxim", lastName: "Zaks")
let p2 = Person(firstName: "Alex", lastName: "Zaks")
let list = List(people: [p1, p2])
let data = try?list.makeData()
```
Decode data very efficiently
```swift
let newList = List.makeList(data: data)
let name = newList?.people[0].firstName
```

# Please check out [Wiki](https://github.com/mzaks/FlatBuffersSwift/wiki) for more information.
