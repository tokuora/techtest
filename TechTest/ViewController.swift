//
//  ViewController.swift
//  TechTest
//
//  Created by Jane Idelson on 5/11/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import UIKit
import Alamofire

struct APIData: Codable {
    let CanBeSecondCategory: Bool?
    let CanHaveSecondCategory: Bool?
    let AreaOfBusiness: Int?
    let HasClassifieds: Bool?
    let IsLeaf: Bool
    let Name: String?
    let Path: String?
    let Subcategories: Array<APIData>?
}

class ViewController: UIViewController {
    
    private let apiUrl = "https://api.tmsandbox.co.nz/v1/Categories/0.json"
    private var categories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        retrieveTopLevelCategories()
        
    }

    private func retrieveTopLevelCategories() {
        Alamofire.request(apiUrl).responseJSON { [weak self] (response) in
            if let jsonData = response.data {
                let decoder = JSONDecoder()
                let topLevel = try! decoder.decode(APIData.self, from: jsonData)
                if let tls = topLevel.Subcategories {
                    for category in tls {
                        if let name = category.Name {
                            self?.categories.append(name)
                        }
                    }
                }
            }
        }
    }
}

