//
//  Type.swift
//  Pods
//
//  Created by jewelz on 2017/3/24.
//
//

import Foundation

public enum Type<Value> {
    case some(Value)
    case array(Value)
    case int
    case string
    case double
    case float
    case bool
    case none
    
    public var value: Any.Type? {
        switch self {
        case .some(let v):
            return v as? Any.Type
        case .int:
            return Int.self
        case .float:
            return Float.self
        case .double:
            return Double.self
        case .string:
            return String.self
        case .bool:
            return Bool.self
        case .none:
            return nil
        case .array(let v):
            if v is String.Type {
                return String.self
            } else if v is Int.Type {
                return Int.self
            } else if v is Float.Type {
                return Float.self
            } else if v is Double.Type {
                return Double.self
            } else if v is Bool.Type {
                return Bool.self
            } else {
                return v as? Any.Type
            }
        }
    }
    
}

public struct Image {

    public let subject: Any
    
    
    /// type of the reflecting subject
    public var subjectType: Type<Any> {
        let mirror = Mirror(reflecting: subject)
        return  typeOf(mirror.subjectType)
    }
    
    /// An element of the reflected instance's structure.  The optional
    /// `label` may be used to represent the name
    /// of a stored property, and `type` is the stored property`s type.
    
    public typealias Child = (label: String?, type: Type<Any>)
    
    public typealias Children = [Child]
    
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
    
    private func subjectType(of subject: Any) -> Type<Any> {
        let mirror = Mirror(reflecting: subject)
        
        let subjectType = mirror.subjectType
        
        return typeOf(subjectType)
    }
    
    private func typeOf(_ subjectType: Any.Type) -> Type<Any> {
        //print("subject type: \(subjectType)")
        if subjectType is Int.Type || subjectType is Optional<Int>.Type {
            return .int
        } else if subjectType is String.Type || subjectType is Optional<String>.Type {
            return .string
        } else if subjectType is Float.Type || subjectType is Optional<Float>.Type {
            return .float
        } else if subjectType is Double.Type || subjectType is Optional<Double>.Type {
            return .double
        }  else if subjectType is Bool.Type || subjectType is Optional<Bool>.Type {
            return .bool
        } else if subjectType is Array<String>.Type || subjectType is Optional<Array<String>>.Type {
            return .array(String.self)
        } else if subjectType is Array<Int>.Type || subjectType is Optional<Array<Int>>.Type {
            return .array(Int.self)
        } else if subjectType is Array<Float>.Type || subjectType is Optional<Array<Float>>.Type {
            return .array(Float.self)
        } else if subjectType is Array<Bool>.Type || subjectType is Optional<Array<Bool>>.Type {
            return .array(Bool.self)
        } else if subjectType is Array<Double>.Type || subjectType is Optional<Array<Double>>.Type {
            return .array(Double.self)
        }
        return .some(subjectType)
    }

}
