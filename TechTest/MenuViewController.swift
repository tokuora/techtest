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
    let IsLeaf: Bool
    let Name: String?
    let Number: String?
    let Subcategories: Array<APIData>?
}

class MenuViewController: UIViewController {
    
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
            self.navigationItem.title = "Select category"
        } else {
            self.navigationItem.title = apiData?.Name
        }
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped(_:)))
        
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
    
    @objc private func doneButtonTapped(_ sender: Any) {
        let vc = ListingsViewController(category: (apiData?.Name, apiData?.Number ?? "") as Category)
        splitViewController?.showDetailViewController(UINavigationController(rootViewController: vc), sender: self)
    }
}

extension MenuViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

// MARK: TableView

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiData?.Subcategories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = apiData?.Subcategories?[indexPath.row].Name ?? ""
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let apiData = apiData?.Subcategories?[indexPath.row] {
            let vc: UIViewController
            if !apiData.IsLeaf {
                vc = MenuViewController(apiData: apiData)
                navigationController?.pushViewController(vc, animated: true)
            } else {
                vc = ListingsViewController(category: (apiData.Name, apiData.Number) as Category)
                splitViewController?.showDetailViewController(UINavigationController(rootViewController: vc), sender: self)
            }
        }
    }
}

