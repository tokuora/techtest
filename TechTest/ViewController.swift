//
//  ViewController.swift
//  TechTest
//
//  Created by Jane Idelson on 5/11/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getData()
    }

    private func getData() {
        Alamofire.request("https://api.tmsandbox.co.nz/v1/Categories/0.json").responseJSON { (response) in
            
            if let json = response.result.value {
                print("JSON: \(json)")
            }
        }
    }

}

