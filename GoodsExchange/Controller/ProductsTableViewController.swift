//
//  ProductsTableViewController.swift
//  GoodsExchange
//
//  Created by Andrew Reed on 03/06/2016.
//  Copyright © 2016 Andrew Reed. All rights reserved.
//

import UIKit
import FontAwesomeKit


/// View controller to show the products availiable for purchase.
class ProductsTableViewController: UITableViewController {
    
    private var goods = [Goods]()   ///the goods we can sell
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.goods.count == 0 {
            self.goods = Goods.getGoods((UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext)
        }
        self.setupNavBar()
    }
    
    /// setupNavBar: Method to setup the display of the nav bar checkout button
    private func setupNavBar() {
        let barButtonItem = self.navigationItem.rightBarButtonItem
        let icon = FAKIonIcons.iosCartIconWithSize(CGFloat(30))
        barButtonItem?.image = icon.imageWithSize(CGSizeMake(30, 30))
        self.enableDisableCheckoutButton()
    }

    /// enableDisableCheckoutButton: Method to enable or disable the checkout button
    private func enableDisableCheckoutButton() {
        let barButtonItem = self.navigationItem.rightBarButtonItem
        if BasketBrain.sharedInstance.totalItemsInBasket() > 0 {
            barButtonItem?.enabled = true
        } else {
            barButtonItem?.enabled = false
        }
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.goods.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("productCell", forIndexPath: indexPath) as! ProductCell
        let product = self.goods[indexPath.row]
        cell.setupView(product, badgeNumber:BasketBrain.sharedInstance.totalItemsInBasketForGoods(product))
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let product = self.goods[indexPath.row]
        BasketBrain.sharedInstance.addToBasket(product)
        self.enableDisableCheckoutButton()
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let product = self.goods[indexPath.row]
        
        if BasketBrain.sharedInstance.totalItemsInBasketForGoods(product) > 0 {
            return true
        }
        
        return false
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let product = self.goods[indexPath.row]
        BasketBrain.sharedInstance.removeFromBasket(product)
        self.enableDisableCheckoutButton()
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Remove".localized
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        self.setupBackButton()
        
    }
}
