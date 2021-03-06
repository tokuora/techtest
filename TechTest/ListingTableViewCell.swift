//  ListingTableViewCell.swift
//  TechTest
//
//  Created by Jane Idelson on 6/11/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Foundation
import UIKit

class ListingTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ListingCell"
    
    private var listingImage = UIImageView()
    private var titleLabel = UILabel()
    private var priceLabel = UILabel()
    private var idLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(listingImage)
        listingImage.snp.makeConstraints { (make) in
            make.left.centerY.equalTo(self)
            make.width.equalTo(80)
        }
        
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(self)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 2
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(listingImage.snp.right).offset(10)
            make.top.equalTo(self).offset(10)
            make.right.lessThanOrEqualTo(priceLabel.snp.left).offset(-10)
        }
        
        contentView.addSubview(idLabel)
        idLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(titleLabel.snp.left)
        }
        
        let bottomSeparatorLine = UIView()
        bottomSeparatorLine.backgroundColor = .gray
        contentView.addSubview(bottomSeparatorLine)
        bottomSeparatorLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateFromListing(_ listing: Listing) {
        if let href = listing.PictureHref, let imageDataUrl = URL(string: href) {
            do {
                listingImage.image = UIImage(data: try Data(contentsOf: imageDataUrl))
            } catch let error {
                print(error)
            }
        }
        if let title = listing.Title {
            titleLabel.text = title
        }
        idLabel.text = "Listing ID: \(listing.ListingId)"
        if let price = listing.PriceDisplay {
            priceLabel.text = price
        }
    }
    
}
