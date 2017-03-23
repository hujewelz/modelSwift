//
//  Dictionary-toModel.swift
//  Firefly
//
//  Created by jewelz on 2017/3/22.
//  Copyright © 2017年 hujewelz. All rights reserved.
//

import Foundation


infix operator ~>

@discardableResult
func ~><T: NSObject>(lhs: Any, rhs: T.Type) -> T? {
    
    if let data = lhs as? Data {
        if let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String : Any] {
            let model: T = convert(json, to: T.self) as! T
            return model
        }
    }
    
    guard let dict = lhs as? [String: Any] else {
        print("Can't convert \(lhs) to [String: Any].")
        return nil
    }
    
    let model: T = convert(dict, to: T.self) as! T
    return model
}

@discardableResult
func ~><T: NSObject>(lhs: Any, rhs: T.Type) -> [T]? {
    
    guard let array = lhs as? [Any] else {
        print("Can't convert \(lhs) to [Any].")
        return nil
    }
    
    return array.flatMap { $0 ~> rhs }
}

fileprivate func convert(_ any: Any, to classType: AnyClass) -> Any? {
    
    if let dict = any as? [String: Any] {
        return convert(dict, to: classType)
    }
    
    if let array = any as? [Any] {
        return array.map{ convert($0, to: classType)}
    }
    
    return nil
}

fileprivate func convert(_ dict: [String: Any], to classType: AnyClass) -> NSObject {
    
    let type = classType as! NSObject.Type
    let object = type.init()
    let mirror = Mirror(reflecting: object)
    
    for (label, _) in mirror.children {
        
        var jsonValue: Dictionary<String, Any>.Value? = nil
        
        if let jsonKey = object.reflectedProperty[label!] {
            
            jsonValue = dict[jsonKey]
            
        } else if let key = label {
            
            jsonValue = dict[key]
            
        }
        
        if let value = jsonValue {
            
            if value is NSNull { continue }
            
            // 如果 value 的值是字典
            if let dictValue = value as? [String: Any] {
                
                if let _classType = object.reflectedObject[label!] {
                    
                    let obj = convert(dictValue, to: _classType)
                    object.setValue(obj, forKey: label!)
                    
                }
                
            } else if let dictValue = value as? [Any], let _classType = object.objectInArray[label!] { // 如果 value 的值是数组
                
                let obj = dictValue.map{ convert($0, to: _classType) }
                object.setValue(obj, forKey: label!)
                
            } else {
                
                object.setValue(value , forKey: label!)
            }
            
        }
        
    }
    
    return object
}

protocol Reflectable: class {
    
    /// 将 `self` 中的属性映射为另外一个值.
    ///
    /// 例如我们要将 `desc` 替换为 `description`, 可以这样
    ///
    ///     override var reflectedProperty: [String: String] {
    ///         return ["desc": "description"]
    ///     }
    ///
    
    var reflectedProperty: [String: String] { get }
    
    /// 将 `self` 中的属性映射为一个对象.
    ///
    /// 例如我们要将 `user` 替换为 `user` 的实例, 可以这样
    ///
    ///     override var reflectedObject: [String : AnyClass] {
    ///         return ["user": User.self]
    ///    }
    ///
    /// - important: 当你的类中包含另外一个对象时，要实现该方法
    
    var reflectedObject: [String: AnyClass] { get }
    
    /// 数组中包含的对象
    var objectInArray: [String: AnyClass] { get }
}



extension NSObject: Reflectable {
    
    var reflectedObject: [String : AnyClass] { return [:] }
    
    var reflectedProperty: [String: String] { return [:] }
    
    var objectInArray: [String: AnyClass] { return [:] }
    
}


