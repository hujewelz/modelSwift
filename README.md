# ModelSwift

[![CI Status](http://img.shields.io/travis/huluobobo/ModelSwift.svg?style=flat)](https://travis-ci.org/huluobobo/ModelSwift)
[![Version](https://img.shields.io/cocoapods/v/ModelSwift.svg?style=flat)](http://cocoapods.org/pods/ModelSwift)
[![License](https://img.shields.io/cocoapods/l/ModelSwift.svg?style=flat)](http://cocoapods.org/pods/ModelSwift)
[![Platform](https://img.shields.io/cocoapods/p/ModelSwift.svg?style=flat)](http://cocoapods.org/pods/ModelSwift)

## Example
When we got the data from our server, we can use ModelSwift to transform it to model:
```swift
guard let json = response.result.value as? [Any] else {
    return
}

let repos: [Repos] = (json ~> Repos.self)!
```
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ModelSwift is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ModelSwift"
```

## Author

hujewelz, hujewelz@163.com

## License

ModelSwift is available under the MIT license. See the LICENSE file for more info.
