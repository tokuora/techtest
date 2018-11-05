//
//  MenuViewController.swift
//  TechTest
//
//  Created by Jane Idelson on 5/11/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

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

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let apiUrl = "https://api.tmsandbox.co.nz/v1/Categories/0.json"
    private var apiData: APIData? = nil {
        didSet {
            if apiData != nil {
                contentTableView.reloadData()
            }
        }
    }
    
    // UI elements
    let contentTableView = UITableView()
    
    convenience init(apiData: APIData?) {
        self.init(nibName: nil, bundle: nil)
        self.apiData = apiData
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if apiData == nil {
            retrieveTopLevelCategories()
        }
        
        navigationController?.navigationBar.isHidden = false
        
        contentTableView.delegate = self
        contentTableView.dataSource = self
        view.addSubview(contentTableView)
        contentTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    private func retrieveTopLevelCategories() {
        Alamofire.request(apiUrl).responseJSON { [weak self] (response) in
            if let jsonData = response.data {
                let decoder = JSONDecoder()
                let data = try! decoder.decode(APIData.self, from: jsonData)
                self?.apiData = data
            }
        }
    }
    
    // MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiData?.Subcategories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = apiData?.Subcategories?[indexPath.row].Name ?? ""
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

