//
//  ViewController.swift
//  ModelSwift
//
//  Created by jewelz on 03/23/2017.
//  Copyright (c) 2017 hujewelz. All rights reserved.
//

import UIKit
import ModelSwift

class U {
    var name = "U"
    var u = 11
}

class ViewController: UIViewController {
    
    let viewers = [
        [ "name": "hujewelz", "age": 23, "description": "iOS Developer"],
        [ "name": "bob", "age": 24 ],
        [ "name": "jobs", "age": 54 ]
    ]
    
    let json: [String : Any] = [
        "title": "ModelSwift",
        "owner": [ "name": "hujewelz", "age": 23, "description": "iOS Developer" ],
        "viewers": [
            [ "name": "hujewelz", "age": 23, "description": "iOS Developer"],
            [ "name": "bob", "age": 24 ],
            [ "name": "jobs", "age": 54 ]
        ],
        "images": ["1.jpg", "2.jpg"]
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let repos = json ~> Repos.self else {
            return
        }
        
        print(repos)
        
        guard let viewers  = viewers => User.self else {
            return
        }
        print("\(viewers)")
        //print("number of viewers: \(viewers.count)")
        
        
        //let t = Type.type(User.self)
        //print(t.value!)
        
        
//        let type = t.value! as? NSObject.Type
//        let u = type?.init()
//        
        let types = propertyType(of: U())
        
        for (lab, val) in types {
            print("\(lab!): \(val)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func subjectType(of subject: Any) -> Any.Type {
        let mirror = Mirror(reflecting: subject)
        return mirror.subjectType
    }
    
    func propertyType(of subject: Any) -> [(String?, Any.Type)]{
        let mirror = Mirror(reflecting: subject)
        
        var types = [(String?, Any.Type)]()
        
        for (lab, value) in mirror.children {
            let v = (lab, subjectType(of: value))
            types.append(v)
        }
        
        return types
    }

}

