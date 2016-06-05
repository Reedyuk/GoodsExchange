//
//  ProductCell.swift
//  GoodsExchange
//
//  Created by Andrew Reed on 03/06/2016.
//  Copyright © 2016 Andrew Reed. All rights reserved.
//

import UIKit
import Sheriff

/// Cell to represent our products availiable to purchase.
class ProductCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var badgeContainerView: UIView!
    let badgeView = GIBadgeView()
    
    /// setupView: Method to setup cell with a goods item
    /// - product: The product in question
    /// - badgeNumber: The number of items in basket.
    func setupView(product: Goods, badgeNumber: Int) {
        self.titleLabel.text = product.name

        self.setupAmountLabel(product.amount, currency: product.currency)
        self.setupBackgroundImage(product.image)
        
        self.badgeContainerView.addSubview(self.badgeView)
        self.badgeView.rightOffset = self.amountLabel.frame.width/6
        self.badgeView.badgeValue = badgeNumber
    }
    
    /// setupAmountLabel: Method to setup the display of the amount label
    /// - amount: The amount to display
    /// - currency: The currency the item is in.
    private func setupAmountLabel(amount: NSDecimalNumber?, currency: String?) {
        if amount != nil {
            let formattedAmount = String(format: "%.2f", amount!.doubleValue)
            if currency != nil {
                self.amountLabel.text = "\(currency!)\(formattedAmount)"
            } else {
                self.amountLabel.text = "\(Goods.getDefaultCurrency())\(formattedAmount)"
            }
        } else {
            self.amountLabel.text = ""
        }
        
        self.amountLabel.layer.cornerRadius = self.amountLabel.frame.width/2
        self.amountLabel.backgroundColor = UIColor.whiteColor()
    }
    
    /// setupBackgroundImage: Method to setup showing the background image
    /// image: THe name of the image.
    private func setupBackgroundImage(image: String?) {
        if image != nil {
            self.backgroundImageView.image = UIImage(named: image!)
        } else {
            self.backgroundImageView.image = nil
        }
    }

}
