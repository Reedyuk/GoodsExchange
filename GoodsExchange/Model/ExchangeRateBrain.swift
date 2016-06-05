//
//  ExchangeRateBrain.swift
//  Solera Goods Exchange
//
//  Created by Andrew Reed on 03/06/2016.
//  Copyright © 2016 Andrew Reed. All rights reserved.
//

import Foundation
import UIKit

/// Brain class to handle the exchange rate between goods.
class ExchangeRateBrain : NSObject {
    
    static let sharedInstance = ExchangeRateBrain()   //singleton
    private var currency : Currency?
    var selectedCurrency : Currency? {
        get {
            if self.currency == nil {
                self.currency = Currency.getDefaultCurrency((UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext)
            }
            return self.currency
        } set(newCurrency) {
            self.currency = newCurrency
        }
    }
    
    func priceForSelectedCurrency(amount: NSDecimalNumber) -> NSDecimalNumber {
        if self.selectedCurrency == Currency.getDefaultCurrency((UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext) {
            return amount
        } else {
            if let exchangeRate = ExchangeRate.getExchangeRateForCurrency((UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext, isoCode: self.selectedCurrency!.isoCode!) {
                print("Exchange rate selected \(exchangeRate) for currency code \(self.selectedCurrency!.isoCode)")
                return amount.decimalNumberByMultiplyingBy(NSDecimalNumber(double: exchangeRate.rate!.doubleValue))
            }
            return NSDecimalNumber(double: 0)
        }
    }
    
    
    
}