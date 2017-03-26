# ModelSwift

[![CI Status](http://img.shields.io/travis/huluobobo/ModelSwift.svg?style=flat)](https://travis-ci.org/huluobobo/ModelSwift)
[![Version](https://img.shields.io/cocoapods/v/ModelSwift.svg?style=flat)](http://cocoapods.org/pods/ModelSwift)
[![License](https://img.shields.io/cocoapods/l/ModelSwift.svg?style=flat)](http://cocoapods.org/pods/ModelSwift)
[![Platform](https://img.shields.io/cocoapods/p/ModelSwift.svg?style=flat)](http://cocoapods.org/pods/ModelSwift)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

ModelSwift can convert josn (or Data) to model in Swift.

## Usage
**:warning: In order to convert json（or Data） to model, the model  class must be a subclass of NSObject.**

**:warning: If the stored property is Int, Float, Double .etc, it should not be optional.**

example:
```swift
class User: NSObject {
    var name: String?
    var age = 0 // not var age: Int?
    var desc: String?
}

class Repos: NSObject {
    var title: String?
    var owner: User?
    var viewers: [User]?
}
```
You can map a json key  to a property name. 
just like this:

```json
// JSON
{
 "title": "ModelSwift",
 "owner": { "name": "hujewelz", "age": 23, "description": "iOS Developer" },
 "viewers": [
     { "name": "hujewelz", "age": 23, "description": "iOS Developer"},
     { "name": "bob", "age": 24 },
     { "name": "jobs", "age": 54 }
 ]
}

```

#### Match model property to different JSON key:

```swift
var desc: String?
...

extension User: Replacable {
    var replacedProperty: [String : String] {
        return ["desc": "description" ]
    }
}
```
#### Property of object type:

```swift
var owner: User? // an object
...

extension Repos: Reflectable {
    var reflectedObject: [String : AnyClass] {
        return ["owner": User.self]
    }
}
```

#### Property in array:

```swift
var viewers: [User]? // an object array
...

extension Repos: ObjectingArray {
    var objectInArray: [String : AnyClass] {
        return ["viewers": User.self]
    }
}

```

#### ignored property

```swift
extension User: Ignorable {
/// the store properties can not to be converted.
    var ignoredProperty: [String] {
    return ["name"]
    }

}
```

If the type of an object in json cannot be matched to the property of the model, it can be coverted too.

eg.
```
// JSON
{
    "name": "jewelz"
    "age": "24"     // string => Int
    "isNew": "1223" // string => Bool
}

// model

var name: String?
var age = 0         // 24 
var isNew = false  // true

```

When we got the data from our server, we can use 
`func ~><T: NSObject>(lhs: Any, rhs: T.Type) -> T? ` or `func =><T: NSObject>(lhs: Any, rhs: T.Type) -> [T]?`
 to convert it to model or a model array:

```swift
// convert to a model object
if let repos = dict ~> Repos.self {
    print(repos)
}

// convert to a model array
if let users = array => User.self {
	print(users)
}

```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
* iOS 8.0+
* Xcode 8.1+
* Swift 3.0+

## Installation
### CocoaPods
ModelSwift is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ModelSwift"
```
### Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

To integrate ModelSwift into your Xcode project using Carthage, specify it in your Cartfile:
```ruby
github "hujewelz/modelSwift"
```
## Author

hujewelz

* hujewelz@163.com 
* [jewelz.me](http://jewelz.me)

## License

ModelSwift is available under the MIT license. See the LICENSE file for more info.


