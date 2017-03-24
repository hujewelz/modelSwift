//
//  Type.swift
//  Pods
//
//  Created by jewelz on 2017/3/24.
//
//

import Foundation

//public enum Type<Value> {
//    case type(Value)
//    case int
//    case string
//    case double
//    
//    //let anyClass: Value
//        
//    public var value: Value? {
//        switch self {
//        case .type(let value):
//            return value
//        default:
//            return nil
//        }
//    }
//}

public struct Anything {

    public let subject: Any
    
    
    /// type of the reflecting subject
    public var this: Any.Type {
        let mirror = Mirror(reflecting: subject)
        return  mirror.subjectType
    }
    
    /// An element of the reflected instance's structure.  The optional
    /// `label` may be used to represent the name
    /// of a stored property, and `type` is the stored property`s type.
    
    public typealias Child = (label: String?, type: Any.Type)
    
    public typealias Children = [Anything.Child]
    
    public init(reflecting subject: Any) {
        self.subject = subject
        
       
    }
    
    /// A collection of `Child` elements describing the structure of the
    /// reflected subject.
    public var children: Children {
        var results = [Child]()
        let mirror = Mirror(reflecting: self.subject)
        
        for (lab, value) in mirror.children {
            let v = (lab, self.subjectType(of: value))
            results.append(v)
        }
        
        return results
    }
    
    private func subjectType(of subject: Any) -> Any.Type {
        let mirror = Mirror(reflecting: subject)
        let subjectType = mirror.subjectType
        
        // TODO: 将数组的各种类型转换成自己的类型
        if subjectType is Array<Int>.Type || subjectType is Optional<Int>.Type {
            //arrayType.Element
            print("array Int Type")
        } else if subjectType is Array<String>.Type || subjectType is Optional<String>.Type {
            print("array String Type")
        }
        
        
        return subjectType
    }

}
