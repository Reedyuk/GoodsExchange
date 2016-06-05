//
//  CurrencyService.swift
//  GoodsExchange
//
//  Created by Andrew Reed on 05/06/2016.
//  Copyright © 2016 Andrew Reed. All rights reserved.
//

import Foundation
import UIKit
import Siesta

/// UserService class for user related operations
class CurrencyService {
    
    private let webService = (UIApplication.sharedApplication().delegate as! AppDelegate).webService
    static let sharedInstance = CurrencyService()   //singleton
    private let getCurrenciesUrl = "list"
    private let getExchangeRatesUrl = "live"
    
    /// getCurrencies: Method to get supported currencies
    func getCurrencies() {
        //http://apilayer.net/api/list?access_key=1e76545d738b1a74b86e048b34a6757c
        let resource = self.webService.resource(self.getCurrenciesUrl).withParam("access_key", Constants.Api.jsonRatesKey)
        print("loadifNeeded: \(self.getCurrenciesUrl)")
        resource.loadIfNeeded()
    }
    
    /// registerForCurrencies: Method to register a delegate to recieve currencies
    /// - observer: The delegate to call back on success
    /// - statusOverlay: The loading overlay
    func registerForCurrencies(observer:protocol<ResourceObserver, AnyObject>, statusOverlay: ResourceStatusOverlay?) {
        let resource = self.webService.resource(self.getCurrenciesUrl).withParam("access_key", Constants.Api.jsonRatesKey)
        if statusOverlay != nil {
            resource.addObserver(statusOverlay!)
        }
        resource.addObserver(observer)
    }
    
    /// getExchangeRates: Method to get exchange rates
    func getExchangeRates() {
        //http://apilayer.net/api/live?access_key=1e76545d738b1a74b86e048b34a6757c
        let resource = self.webService.resource(self.getExchangeRatesUrl).withParam("access_key", Constants.Api.jsonRatesKey)
        print("loadifNeeded: \(self.getExchangeRatesUrl)")
        resource.loadIfNeeded()
    }
    
    /// registerForExchangeRates: Method to register a delegate to recieve exchange rates
    /// - observer: The delegate to call back on success
    /// - statusOverlay: The loading overlay
    func registerForExchangeRates(observer:protocol<ResourceObserver, AnyObject>, statusOverlay: ResourceStatusOverlay?) {
        let resource = self.webService.resource(self.getExchangeRatesUrl).withParam("access_key", Constants.Api.jsonRatesKey)
        if statusOverlay != nil {
            resource.addObserver(statusOverlay!)
        }
        resource.addObserver(observer)
    }
    
    

}
