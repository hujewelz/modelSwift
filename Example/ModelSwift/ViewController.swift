//
//  ViewController.swift
//  ModelSwift
//
//  Created by huluobobo on 03/23/2017.
//  Copyright (c) 2017 hujewelz. All rights reserved.
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

class Repos: NSObject {
    var title: String?
    var owner: User?
    var views: [User]?
    
    private lazy var viewsLog: String = { [unowned self] in
        var log = "["
        
        guard let views = self.views else {
            return log + "]"
        }
        for user in views {
            log += "{\(user)}, "
        }
        let index = log.index(log.endIndex, offsetBy: -2)
        return log.substring(to: index) + "]"
    }()
    
    override var description: String {
        return "title: \(title ?? ""),\nowner: {\(owner!)},\nviews: \(viewsLog)"
    }
}

extension Repos: Reflectable, ObjectingArray {
    
    var reflectedObject: [String : AnyClass] {
        return ["owner": User.self]
    }
    
    var objectInArray: [String : AnyClass] {
        return ["views": User.self]
    }

}

class ViewController: UIViewController {
    
    let views = [
        [ "name": "hujewelz", "age": 23, "description": "iOS Developer"],
        [ "name": "bob", "age": 24 ],
        [ "name": "jobs", "age": 54 ]
    ]
    
    let json: [String : Any] = [
        "title": "ModelSwift",
        "owner": [ "name": "hujewelz", "age": 23, "description": "iOS Developer" ],
        "views": [
            [ "name": "hujewelz", "age": 23, "description": "iOS Developer"],
            [ "name": "bob", "age": 24 ],
            [ "name": "jobs", "age": 54 ]
        ]
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let repos = json ~> Repos.self else {
            return
        }
        
        print(repos)
        
        print("views count: \(repos.views?.count)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

