# ModelSwift

[![CI Status](http://img.shields.io/travis/huluobobo/ModelSwift.svg?style=flat)](https://travis-ci.org/huluobobo/ModelSwift)
[![Version](https://img.shields.io/cocoapods/v/ModelSwift.svg?style=flat)](http://cocoapods.org/pods/ModelSwift)
[![License](https://img.shields.io/cocoapods/l/ModelSwift.svg?style=flat)](http://cocoapods.org/pods/ModelSwift)
[![Platform](https://img.shields.io/cocoapods/p/ModelSwift.svg?style=flat)](http://cocoapods.org/pods/ModelSwift)

ModelSwift can conver our josn (or Data) to model in Swift.

## Usage
**:warning: In order to convert json（or Data） to model, our model must be a subclass of NSObject.**

example:
```swift
class User: NSObject {
    var name: String?
    var age = 0
    var desc: String?
}

class Repos: NSObject {
    var title: String?
    var owner: User?
    var views: [User]?
}
```
You can map a json key or an array of json key  to one or multiple property name. 
just like this:

```json
// JSON
{
 "title": "ModelSwift",
 "owner": { "name": "hujewelz", "age": 23, "description": "iOS Developer" },
 "views": [
     { "name": "hujewelz", "age": 23, "description": "iOS Developer"},
     { "name": "bob", "age": 24 },
     { "name": "jobs", "age": 54 }
 ]
}

```

#### Match model property to different JSON key:
```
extension User: Replacable {
    var replacedProperty: [String : String] {
        return ["desc": "description" ]
    }
}
```
#### Property of object type:
```swift
extension Repos: Reflectable {
    var reflectedObject: [String : AnyClass] {
        return ["owner": User.self]
    }
}
```

#### Property in array:
```
extension Repos: ObjectingArray {
    var objectInArray: [String : AnyClass] {
        return ["views": User.self]
    }
}

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

* Xcode 8.0
* Swift 3.0

## Installation

ModelSwift is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ModelSwift"
```

## Author

hujewelz

* hujewelz@163.com 
* [jewelz.me](http://jewelz.me)

## License

ModelSwift is available under the MIT license. See the LICENSE file for more info.


