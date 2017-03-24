//
//  ViewController.swift
//  ModelSwift
//
//  Created by hujewelz on 03/23/2017.
//  Copyright (c) 2017 hujewelz. All rights reserved.
//

import UIKit
import ModelSwift

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
        ]
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
        print("number of viewers: \(viewers.count)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

