//
//  User.swift
//  ModelSwift
//
//  Created by jewelz on 2017/3/24.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import ModelSwift

class User: NSObject {
    var name: String?
    var age = 0
    var desc: String?
    
    override var description: String {
        return "name: \(name ?? "unknow"), age: \(age), description: \(desc ?? "null")"
    }
    
}

extension User: Replacable {
    
    var replacedProperty: [String : String] {
        return ["desc": "description" ]
    }
    
}

extension User: Ignorable {
    /// the store properties can not to be converted.
    var ignoringProperty: [String] {
        return ["name"]
    }

}
