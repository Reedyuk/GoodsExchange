//
//  CurrenciesTableViewController.swift
//  GoodsExchange
//
//  Created by Andrew Reed on 05/06/2016.
//  Copyright © 2016 Andrew Reed. All rights reserved.
//

import UIKit

/// View controller to show the availiable currencies
class CurrenciesTableViewController: UITableViewController {
    ///What currencies we have on record.
    private let currencies = Currency.getCurrencies((UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currencies.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("currencyCell", forIndexPath: indexPath)
        
        let currency = self.currencies[indexPath.row]
        cell.textLabel?.text = currency.name
        cell.detailTextLabel?.text = currency.isoCode
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //select the currency
        let currency = self.currencies[indexPath.row]
        /// tell the exchange brain that we have selected this currency.
        ExchangeRateBrain.sharedInstance.selectedCurrency = currency
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }

}
