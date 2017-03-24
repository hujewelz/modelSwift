//
//  Type.swift
//  Pods
//
//  Created by jewelz on 2017/3/24.
//
//

import Foundation

public enum Type<Value> {
    case type(Value)
    case int
    case string
    case double
    
    //let anyClass: Value
        
    public var value: Value? {
        switch self {
        case .type(let value):
            return value
        default:
            return nil
        }
    }
}


