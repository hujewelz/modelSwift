//
//  Repos.swift
//  ModelSwift
//
//  Created by jewelz on 2017/3/24.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import ModelSwift

class Repos: NSObject {
    var title: String?
    var owner: User?
    var viewers: [User]?
    
    private lazy var viewsLog: String = { [unowned self] in
        var log = "["
        
        guard let views = self.viewers else {
            return log + "]"
        }
        for user in views {
            log += "{\(user)}, "
        }
        let index = log.index(log.endIndex, offsetBy: -2)
        return log.substring(to: index) + "]"
    }()
    
    override var description: String {
        return "title: \(title ?? ""),\nowner: {\(owner!)},\nviewers: \(viewsLog)"
    }
}

extension Repos: Reflectable, ObjectingArray {
    
    var reflectedObject: [String : AnyClass] {
        return ["owner": User.self]
    }
    
    var objectInArray: [String : AnyClass] {
        return ["viewers": User.self]
    }
    
}
