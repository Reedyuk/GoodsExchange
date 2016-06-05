//
//  CheckoutTableViewController.swift
//  GoodsExchange
//
//  Created by Andrew Reed on 04/06/2016.
//  Copyright © 2016 Andrew Reed. All rights reserved.
//

import UIKit
import Siesta
import FontAwesomeKit

class CheckoutTableViewController: UITableViewController, ResourceObserver {

    private var basket = [(Goods, Int)]()
    /// The status overlay
    var statusOverlay = ResourceStatusOverlay()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.basket = BasketBrain.sharedInstance.uniqueItemsInBasket()
        self.statusOverlay.embedIn(self)
        CurrencyService.sharedInstance.registerForCurrencies(self, statusOverlay: self.statusOverlay)
        CurrencyService.sharedInstance.registerForExchangeRates(self, statusOverlay: self.statusOverlay)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        CurrencyService.sharedInstance.getCurrencies()
        CurrencyService.sharedInstance.getExchangeRates()
        self.setupNavBar()
        self.tableView.reloadData()
    }
    
    /// setupNavBar: Method to setup the display of the nav bar checkout button
    private func setupNavBar() {
        let barButtonItem = self.navigationItem.rightBarButtonItem
        let currencySymbol = ExchangeRateBrain.sharedInstance.selectedCurrency?.currencySymbol()
        barButtonItem?.title = currencySymbol
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.basket.count+1   /// +1 for the total cell
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row < self.basket.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("checkoutCell", forIndexPath: indexPath) as! CheckoutCell

            let basketItem = self.basket[indexPath.row]
            var amount = BasketBrain.sharedInstance.totalCostOfGoods(basketItem.0)
            amount = ExchangeRateBrain.sharedInstance.priceForSelectedCurrency(amount)
            
            cell.setupView(basketItem.0.name!, quantity: basketItem.1,amount: amount, currency: ExchangeRateBrain.sharedInstance.selectedCurrency?.currencySymbol())
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("checkoutCell", forIndexPath: indexPath) as! CheckoutCell
            //use brain to calculate total
            var amount = BasketBrain.sharedInstance.totalCostOfBasket()
            amount = ExchangeRateBrain.sharedInstance.priceForSelectedCurrency(amount)
            cell.setupTotal(amount, currency: ExchangeRateBrain.sharedInstance.selectedCurrency?.currencySymbol())
            return cell
        }
    }
    
    // MARK: ResourceObserver
    
    ///resourceChanged: callback Method to the transactions with a user changing
    /// - resource: The resource in question
    /// - event: The event of the resource
    func resourceChanged(resource: Resource, event: ResourceEvent) {
        print("CheckoutTableViewController resourceChanged \(event)")
        if case .NewData = event {
            if let data = resource.latestData {
                if resource.url.absoluteString.containsString("list") {
                    Currency.parseCurrencies((UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext, jsonDictionary: data.jsonDict)
                    self.setupNavBar()
                    self.tableView.reloadData()
                }
                if resource.url.absoluteString.containsString("live") {
                    ExchangeRate.parseExchangeRates((UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext, jsonDictionary: data.jsonDict)
                }
            }
        } else if case .Error = event {
            if resource.url.absoluteString.containsString("list") {
                //check if we have any currencies before showing an error.
                if Currency.getCurrencies((UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext).count == 0 {
                    self.showErrorAlert("Network Error".localized, message: "An error has occurred, check your internet connectiob and try again.".localized, actionTitle: "OK".localized)
                }
            }
            if resource.url.absoluteString.containsString("live") {
                //check if we have any exchange rates before showing an error.
                if ExchangeRate.getExchangeRates((UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext).count == 0 {
                    self.showErrorAlert("Network Error".localized, message: "An error has occurred, check your internet connectiob and try again.".localized, actionTitle: "OK".localized)
                }
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        self.setupBackButton()
    }

}
