//
//  ModelSwift.swift
//  ModelSwift
//
//  Created by jewelz on 03/23/2017.
//  Copyright (c) 2017 hujewelz. All rights reserved.
//

import Foundation


infix operator ~>

infix operator =>

/// convert json or Data into a model object.
///
/// - Parameter lhs: a json or Data to be converted.
/// - Parameter rhs: type of model.
/// - Returns: the converted model.
@discardableResult public func ~><T: NSObject>(lhs: Any, rhs: T.Type) -> T? {
    
    if let data = lhs as? Data, let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String : Any] {
        return convert(json, to: T.self) as? T
    } else if let dict = lhs as? [String: Any]  {
        return convert(dict, to: T.self) as? T
    }
    
    print("Can't convert \(lhs) to [String: Any].")
    return nil
}


/// convert json or Data into a model array.
///
/// - Parameter lhs: a json or Data to be converted.
/// - Parameter rhs: type of model.
/// - Returns: the converted model array.

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
        return array.flatMap{ convert($0, to: classType)}
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
    let any = Image(reflecting: object)
 
    for case let(label?, type) in any.children {
        //debugPrint("\(label)`s type is \(type)")
        if let obj = object as? Ignorable {
            if obj.ignoredProperty.contains(label) {
                continue
            }
        }
        
        var jsonValue: Dictionary<String, Any>.Value? = nil
        
        if let obj = object as? Replacable, let jsonKey = obj.replacedProperty[label] {
            jsonValue = dict[jsonKey]
            
        } else {
            jsonValue = dict[label]
        }
        
        if let value = jsonValue {
            
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
                
                // 首先要将数组中的元素转换成模型中的类型，例如json中images=[1,2], model中images为[String], 则需要转换
                let convertedValue = dictValue.flatMap{ convert(value: $0, to: type) }
                //print("convertedValue: \(convertedValue)")
                let _obj = convertedValue.flatMap{ convert($0, to: _classType) }
                object.setValue(_obj, forKey: label)
                
            } else {
                // 将json中元素转换成模型中的类型，例如json中age="23", model中age为Int, 则需要转换
                let convertedValue = convert(value: value, to: type)
               
                object.setValue(convertedValue , forKeyPath: label)
            }
        }
        
    }
    
    return object
}


private func convert(value: Any, to realType: Type<Any>) -> Any? {
    let stringVaule = String(describing: value)
    
    switch realType { 
    case .int:
        return Int(stringVaule) ?? 0
    case .float:
        return Float(stringVaule) ?? 0.0
    case .double:
        return Double(stringVaule) ?? 0.0
    case .bool:
        return Bool(stringVaule) ?? ((Int(stringVaule) ?? 0) > 0)
    case .string:
        return stringVaule
    case .none:
        return nil
    case .array(let v):
        if v is String.Type {
            return stringVaule
        } else if v is Int.Type {
            return Int(stringVaule) ?? 0
        } else if v is Float.Type {
            return Float(stringVaule) ?? 0.0
        } else if v is Double.Type {
            return Double(stringVaule) ?? 0.0
        } else if v is Bool.Type {
            return Bool(stringVaule) ?? ((Int(stringVaule) ?? 0) > 0)
        } else {
            return value
        }
    default:
        return value
    }
    
}
