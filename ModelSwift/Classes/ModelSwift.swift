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
    
    if let data = lhs as? Data, let array = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [Any], !array.isEmpty {
        return array.flatMap { $0 ~> rhs }
    } else if let array = lhs as? [Any], !array.isEmpty {
        return array.flatMap { $0 ~> rhs }
    }
    
    print("Can't convert \(lhs) to [Any].")
    return nil
}

fileprivate func convert(_ any: Any, to classType: Any.Type) -> Any? {

    if let dict = any as? [String: Any], !dict.isEmpty {
        return convert(dict, to: classType)
    } else if let array = any as? [Any] {
        return array.map{ convert($0, to: classType)}
    }
    
    return any
}

fileprivate func convert(_ dict: [String: Any], to classType: Any.Type) -> NSObject? {
    
    if dict.isEmpty {
        return nil
    }
    
    // 只有 NSObject 的子类才能动态创建一个对象
    guard let type = classType as? NSObject.Type else {
        return nil
    }
    
    let object = type.init()
    let any = Anything(reflecting: object)
    var children = any.children
    
    for (label, type) in children where label != nil {
        print("\(label)`s type is \(type)")
        if let obj = object as? Ignorable {
            if obj.ignoringProperty.contains(label!) {
                continue
            }
        }
        
        var jsonValue: Dictionary<String, Any>.Value? = nil
        
        if let obj = object as? Replacable, let jsonKey = obj.replacedProperty[label!] {
            jsonValue = dict[jsonKey]
        } else if let key = label {
            jsonValue = dict[key]
        }
        
        if let value = jsonValue, let label = label {
            
            if value is NSNull { continue }
            
            // 如果 value 的值是字典
            if let dictValue = value as? [String: Any],
                let obj = object as? Reflectable,
                let _classType = obj.reflectedObject[label] {
                
                let _obj = convert(dictValue, to: _classType)
                object.setValue(_obj, forKey: label)
                
            } else if let dictValue = value as? [Any],
                let obj  = object as? ObjectingArray,
                let _classType = obj.objectInArray[label] { // 如果 value 的值是数组
                
                let convertedValue = dictValue.map{convert(value: $0, to: type)}
                //print("convertedValue: \(convertedValue)")
                let _obj = convertedValue.map{ convert($0, to: _classType) }
                object.setValue(_obj, forKey: label)
            } else {
                let v = convert(value: value, to: type)
                print("set \(v) for \(label)")
                object.setValue(v , forKeyPath: label)
            }
        }
        
    }
    
    return object
}


private func convert(value: Any, to realType: Type<Any>) -> Any {
    let stringVaule = String(describing: value)
    
    switch realType {
    case .int:
        return Int(stringVaule) ?? 0
    case .float:
        return Float(stringVaule) ?? 0.0
    case .double:
        return Double(stringVaule) ?? 0.0
    case .string:
        return stringVaule ?? ""
    case .array(let v):
        if v is String.Type {
            return stringVaule
        } else if v is Int.Type {
            return Int(stringVaule) ?? 0
        } else if v is Float.Type {
            return Float(stringVaule) ?? 0.0
        } else if v is Double.Type {
            return Double(stringVaule) ?? 0.0
        } else {
            return value
        }
    default:
        return value
    }
    
}
