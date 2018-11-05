//
//  ListingsViewController.swift
//  TechTest
//
//  Created by Jane Idelson on 5/11/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import UIKit
import Alamofire

struct Listing: Codable {
    let ListingId: Int
    let Title: String?
    let PictureHref: String?
    let PriceDisplay: String?
    let Region: String?
}

class ListingsViewController: UIViewController {
    
    // API stuff
    private let consumerKey = "A1AC63F0332A131A78FAC304D007E7D1"
    private let secretKey = "EC7F18B17A062962C6930A8AE88B16C7"
    private let searchEndpoint = "https://api.tmsandbox.co.nz/v1/Search/General.json"
    
    var category: String? = nil
    
    private var listings: [Listing] = [] {
        didSet {
            contentTableView.reloadData()
        }
    }
    
    // UI elements
    private let contentTableView = UITableView()
    
    convenience init(category: String?) {
        self.init(nibName: nil, bundle: nil)
        self.category = category
        fetchListings()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTableView.delegate = self
        contentTableView.dataSource = self
        
        view.addSubview(contentTableView)
        contentTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func fetchListings() {
        let headers: HTTPHeaders = [
            "Authorization": "OAuth oauth_consumer_key=\"\(consumerKey)\", oauth_signature_method=\"PLAINTEXT\", oauth_signature=\"\(secretKey)&\""
        ]
        let parameters: Parameters = [
            "category": category ?? "",
            "rows": 20
        ]
        Alamofire.request(searchEndpoint, method: .get, parameters: parameters, headers: headers).responseJSON { [weak self](response) in
            if let jsonData = response.data {
                let decoder = JSONDecoder()
//                let data = try! decoder.decode([Listing].self, from: jsonData)
                print(response.result.value)
            }
        }
    }
}

extension ListingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
