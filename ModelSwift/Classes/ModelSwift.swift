//
//  ModelSwift.swift
//  ModelSwift
//
//  Created by jewelz on 03/23/2017.
//  Copyright (c) 2017 hujewelz. All rights reserved.
//

import Foundation


infix operator ~>

/// transform json or Data to a model object

@discardableResult public func ~><T: NSObject>(lhs: Any, rhs: T.Type) -> T? {
    
    if let data = lhs as? Data, let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String : Any] {
        
        return convert(json, to: T.self) as? T
        
    } else if let dict = lhs as? [String: Any]  {
        
        return convert(dict, to: T.self) as? T
        
    }
    
    print("Can't convert \(lhs) to [String: Any].")
    return nil
}


infix operator =>

/// transform json or Data to an Array object

@discardableResult public func =><T: NSObject>(lhs: Any, rhs: T.Type) -> [T]? {
    
    if let data = lhs as? Data, let array = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [Any] {
        
        return array.flatMap { $0 ~> rhs }
        
    } else if let array = lhs as? [Any] {
        
        return array.flatMap { $0 ~> rhs }
        
    }
    
    print("Can't convert \(lhs) to [Any].")
    return nil
}

fileprivate func convert(_ any: Any, to classType: AnyClass) -> Any? {
    
    if let dict = any as? [String: Any], !dict.isEmpty {
        
        return convert(dict, to: classType)
        
    } else if let array = any as? [Any] {
        
        return array.map{ convert($0, to: classType)}
        
    }
    
    return any
}

fileprivate func convert(_ dict: [String: Any], to classType: AnyClass) -> NSObject? {
    
    if dict.isEmpty {
        return nil
    }
    
    // 只有 NSObject 的子类才能动态创建一个对象
    guard let type = classType as? NSObject.Type else {
        return nil
    }
    let object = type.init()
    let mirror = Mirror(reflecting: object)
    
    for (label, _) in mirror.children {
        
        var jsonValue: Dictionary<String, Any>.Value? = nil
        
        if let obj = object as? Replacable, let jsonKey = obj.replacedProperty[label!] {
            //print("--------Replacable")
            jsonValue = dict[jsonKey]
            
        } else if let key = label {
            
            jsonValue = dict[key]
            
        }
        
        if let value = jsonValue {
            
            if value is NSNull { continue }
            
            // 如果 value 的值是字典
            if let dictValue = value as? [String: Any],
                let obj = object as? Reflectable,
                let _classType = obj.reflectedObject[label!] {
                
                //print("--------Reflectable")
                let _obj = convert(dictValue, to: _classType)
                object.setValue(_obj, forKey: label!)
                
            } else if let dictValue = value as? [Any],
                let obj  = object as? ObjectingArray,
                let _classType = obj.objectInArray[label!] { // 如果 value 的值是数组
                
                //print("--------ObjectingArray")
                let _obj = dictValue.flatMap{ convert($0, to: _classType) }
                object.setValue(_obj, forKey: label!)
                
            } else {
                
                object.setValue(value , forKey: label!)
                
            }
            
        }
        
    }
    
    return object
}

