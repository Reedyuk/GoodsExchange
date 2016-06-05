//
//  CheckoutCell.swift
//  GoodsExchange
//
//  Created by Andrew Reed on 04/06/2016.
//  Copyright © 2016 Andrew Reed. All rights reserved.
//

import UIKit

/// class to represent our items in the checkout screen
class CheckoutCell: UITableViewCell {

    /// setupView: Method to setup cell with a checkout item
    /// - name: The name of the product
    /// - quantity: The number of products
    /// - amount: The amount it will cost
    /// - currency: The currency to display
    func setupView(name: String, quantity: Int, amount: NSDecimalNumber?, currency: String?) {
        self.textLabel?.text = "\(quantity)x \(name)"
        if amount != nil && currency != nil {
            self.detailTextLabel?.text = "\(currency!)\(String(format: "%.2f", amount!.doubleValue))"
        } else {
            self.detailTextLabel?.text = ""
        }
    }

    /// setupTotal: Method to setup cell with the total basket amount
    /// - amount: The amount it will cost in total
    /// - currency: The currency to display
    func setupTotal(amount: NSDecimalNumber?, currency: String?) {
        self.textLabel?.text = "Total".localized
        if amount != nil && currency != nil {
            self.detailTextLabel?.text = "\(currency!)\(String(format: "%.2f", amount!.doubleValue))"
        } else {
            self.detailTextLabel?.text = ""
        }
    }
}
