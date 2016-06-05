//
//  ExchangeRateBrainTests.swift
//  Solera Goods Exchange
//
//  Created by Andrew Reed on 03/06/2016.
//  Copyright © 2016 Andrew Reed. All rights reserved.
//

import XCTest
@testable import GoodsExchange
import CoreData

class ExchangeRateBrainTests: XCTestCase {
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext // core data context
    var testProducts : [Goods]!     // easy access to our products.
    
    override func setUp() {
        super.setUp()
        ExchangeRate.deleteAllData(self.context)
        Currency.deleteAllData(self.context)
        self.createTestExchangeRates()
        self.createTestCurrencies()
        Goods.deleteAllData(context)
        BasketBrainTests.createTestGoods()
        BasketBrain.sharedInstance.resetBasket()
        self.testProducts = Goods.getGoods(self.context)
    }
    
    private func createTestExchangeRates() {
        let gbp = NSEntityDescription.insertNewObjectForEntityForName("ExchangeRate", inManagedObjectContext: self.context) as! ExchangeRate
        gbp.code = "USDGBP"
        gbp.rate = NSNumber(double: 0.688942)
        
        let ron = NSEntityDescription.insertNewObjectForEntityForName("ExchangeRate", inManagedObjectContext: self.context) as! ExchangeRate
        ron.code = "USDRON"
        ron.rate = NSDecimalNumber(double: 3.97245)
    }
    
    private func createTestCurrencies() {
        let gbp = NSEntityDescription.insertNewObjectForEntityForName("Currency", inManagedObjectContext: self.context) as! Currency
        gbp.isoCode = "GBP"
        gbp.name = "Pound"
        
        let ron = NSEntityDescription.insertNewObjectForEntityForName("Currency", inManagedObjectContext: self.context) as! Currency
        ron.isoCode = "RON"
        ron.name = "Romanian Lei"
    }


    func testExchangeToDollar() {
        let testProduct = self.testProducts.first!
        BasketBrain.sharedInstance.resetBasket() //required when we add new products
        BasketBrain.sharedInstance.addToBasket(testProduct)
        let expectedTotalCost = BasketBrain.sharedInstance.totalCostOfBasket()
        let returnedCost = ExchangeRateBrain.sharedInstance.priceForSelectedCurrency(expectedTotalCost)
        XCTAssertEqual(expectedTotalCost, returnedCost)
    }
    
    func testExchangeToPound() {
        let testProduct = self.testProducts.first!
        let gbp = ExchangeRate.getExchangeRateForCurrency(self.context, isoCode: "GBP")
        let gpbCurrency = Currency.getCurrencyForIsoCode(self.context, isoCode: "GBP")
        BasketBrain.sharedInstance.resetBasket() //required when we add new products
        BasketBrain.sharedInstance.addToBasket(testProduct)
        let expectedTotalCost = BasketBrain.sharedInstance.totalCostOfBasket().decimalNumberByMultiplyingBy(NSDecimalNumber(double:gbp!.rate!.doubleValue))
        
        ExchangeRateBrain.sharedInstance.selectedCurrency = gpbCurrency
        let returnedCost = ExchangeRateBrain.sharedInstance.priceForSelectedCurrency(BasketBrain.sharedInstance.totalCostOfBasket())
        XCTAssertEqual(expectedTotalCost, returnedCost)
    }
    
    func testExchangeToUnknownCurrency() {
        let testProduct = self.testProducts.first!
        let bitCoinCurrency = Currency.getCurrencyForIsoCode(self.context, isoCode: "BTC")
        BasketBrain.sharedInstance.resetBasket() //required when we add new products
        BasketBrain.sharedInstance.addToBasket(testProduct)
        
        ExchangeRateBrain.sharedInstance.selectedCurrency = bitCoinCurrency
        let returnedCost = ExchangeRateBrain.sharedInstance.priceForSelectedCurrency(BasketBrain.sharedInstance.totalCostOfBasket())
        XCTAssertEqual(testProduct.amount!, returnedCost)
    }
    
    func testExchangeToMissingRateCurrency() {
        let testProduct = self.testProducts.first!
        let gbpCurrency = Currency.getCurrencyForIsoCode(self.context, isoCode: "GBP")
        ExchangeRate.deleteAllDataForIsoCode(self.context, isoCode: "USDGBP")
        ExchangeRateBrain.sharedInstance.selectedCurrency = gbpCurrency
        BasketBrain.sharedInstance.resetBasket()
        BasketBrain.sharedInstance.addToBasket(testProduct)
        
        let returnedCost = ExchangeRateBrain.sharedInstance.priceForSelectedCurrency(BasketBrain.sharedInstance.totalCostOfBasket())
        XCTAssertEqual(NSDecimalNumber(integer:0), returnedCost)
    }
    

}
