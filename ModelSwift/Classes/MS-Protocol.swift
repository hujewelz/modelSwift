//
//  MS-Protocol.swift
//  ModelSwift
//
//  Created by jewelz on 03/23/2017.
//  Copyright (c) 2017 hujewelz. All rights reserved.
//

import Foundation

public protocol Reflectable: class {
    
    /// 将 `self` 中的属性映射为一个对象.
    ///
    /// 例如我们要将 `owner` 替换为 `user` 的实例, 可以这样
    ///
    /// ```
    /// class Repos: NSObject, Reflectable {
    ///     var owner: User?
    ///
    ///     var reflectedObject: [String : AnyClass] {
    ///         return ["owner": User.self]
    ///     }
    /// }
    /// ```
    ///
    /// - important: 当你的类中包含另外一个对象时，要实现该方法
    
    var reflectedObject: [String: Any.Type] { get }
    
}

public protocol Replacable {
    
    /// 将 `self` 中的属性替换为另外一个值.
    ///
    /// 例如我们要将 `desc` 替换为 `description`, 可以这样
    ///
    /// ```
    /// override var replacedProperty: [String: String] {
    ///     return ["desc": "description"]
    /// }
    /// ```
    ///
    
    var replacedProperty: [String: String] { get }
    
}

public protocol ObjectingArray {
    /// Model object in array.
    /// ```
    /// class Repos: NSObject, ObjectingArray {
    ///     var followers: [User]?
    ///
    ///     var objectInArray: [String : AnyClass] {
    ///         return ["followers": User.self]
    ///     }
    /// }
    /// ```
    var objectInArray: [String: Any.Type] { get }
}

public protocol Ignorable {
    
    /// Properties which will not be converted.
    var ignoredProperty: [String] { get }
}
