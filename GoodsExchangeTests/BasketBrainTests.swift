//
//  BasketBrainTests.swift
//  GoodsExchange
//
//  Created by Andrew Reed on 04/06/2016.
//  Copyright © 2016 Andrew Reed. All rights reserved.
//

import XCTest
@testable import GoodsExchange
import CoreData

class BasketBrainTests: XCTestCase {

    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext // core data context
    var testProducts : [Goods]!     // easy access to our products.
    
    override func setUp() {
        super.setUp()
        
        Goods.deleteAllData(self.context)
        BasketBrainTests.createTestGoods()
        BasketBrain.sharedInstance.resetBasket()
        self.testProducts = Goods.getGoods(self.context)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    static func createTestGoods() {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let peas = NSEntityDescription.insertNewObjectForEntityForName("Goods", inManagedObjectContext: managedObjectContext) as! Goods
        peas.name = "Peas"
        peas.amount = NSDecimalNumber(double: 2.50)
        
        let milk = NSEntityDescription.insertNewObjectForEntityForName("Goods", inManagedObjectContext: managedObjectContext) as! Goods
        milk.name = "Milk"
        milk.amount = NSDecimalNumber(double: 4.25)
    }
    

    func testRemoveBasketItem() {
        let testProduct = self.testProducts.first!
        BasketBrain.sharedInstance.resetBasket() //required when we add new products
        BasketBrain.sharedInstance.addToBasket(testProduct)
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasket(), 1)
        
        BasketBrain.sharedInstance.removeFromBasket(testProduct)
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasket(), 0)
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasketForGoods(testProduct), 0)
        XCTAssertEqual(BasketBrain.sharedInstance.totalCostOfGoods(testProduct), NSDecimalNumber(integer: 0))
        XCTAssertEqual(BasketBrain.sharedInstance.totalCostOfBasket(), NSDecimalNumber(integer: 0))
    }
    
    func testRemoveMultipleBasketItem() {
        let testProdOne = self.testProducts.first!
        let testProdTwo = self.testProducts[1]
        
        BasketBrain.sharedInstance.resetBasket() //required when we add new products
        BasketBrain.sharedInstance.addToBasket(testProdOne)
        BasketBrain.sharedInstance.addToBasket(testProdTwo)
        BasketBrain.sharedInstance.addToBasket(testProdTwo)
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasket(), 3)
        
        BasketBrain.sharedInstance.removeFromBasket(testProdOne)
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasket(), 2)
        BasketBrain.sharedInstance.removeFromBasket(testProdTwo)
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasket(), 1)
        BasketBrain.sharedInstance.removeFromBasket(testProdTwo)
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasket(), 0)
        
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasket(), 0)
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasketForGoods(testProdOne), 0)
        XCTAssertEqual(BasketBrain.sharedInstance.totalCostOfGoods(testProdOne), NSDecimalNumber(integer: 0))
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasketForGoods(testProdTwo), 0)
        XCTAssertEqual(BasketBrain.sharedInstance.totalCostOfGoods(testProdTwo), NSDecimalNumber(integer: 0))
        XCTAssertEqual(BasketBrain.sharedInstance.totalCostOfBasket(), NSDecimalNumber(integer: 0))
    }
    
    func testRemoveNegativeBasketItem() {
        let testProduct = self.testProducts.first!
        BasketBrain.sharedInstance.resetBasket() //required when we add new products
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasket(), 0)
        
        BasketBrain.sharedInstance.removeFromBasket(testProduct)
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasket(), 0)
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasketForGoods(testProduct), 0)
        XCTAssertEqual(BasketBrain.sharedInstance.totalCostOfGoods(testProduct), NSDecimalNumber(integer: 0))
        XCTAssertEqual(BasketBrain.sharedInstance.totalCostOfBasket(), NSDecimalNumber(integer: 0))
    }
    
    func testAddBasketItem() {
        let testProduct = self.testProducts.first!
        BasketBrain.sharedInstance.resetBasket() //required when we add new products
        BasketBrain.sharedInstance.addToBasket(testProduct)
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasket(), 1)
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasketForGoods(testProduct), 1)
        XCTAssertEqual(BasketBrain.sharedInstance.totalCostOfGoods(testProduct), testProduct.amount!)
        XCTAssertEqual(BasketBrain.sharedInstance.totalCostOfBasket(), testProduct.amount!)
    }
    
    func testAddMultipleBasketItems() {
        let testProdOne = self.testProducts.first!
        let testProdTwo = self.testProducts[1]
        
        BasketBrain.sharedInstance.resetBasket() //required when we add new products
        BasketBrain.sharedInstance.addToBasket(testProdOne)
        BasketBrain.sharedInstance.addToBasket(testProdTwo)
        BasketBrain.sharedInstance.addToBasket(testProdTwo)
        
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasket(), 3)
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasketForGoods(testProdOne), 1)
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasketForGoods(testProdTwo), 2)
        XCTAssertEqual(BasketBrain.sharedInstance.totalCostOfGoods(testProdOne), testProdOne.amount!)
        XCTAssertEqual(BasketBrain.sharedInstance.totalCostOfGoods(testProdTwo), testProdTwo.amount!.decimalNumberByMultiplyingBy(NSDecimalNumber(integer: 2)))
        
        var total = testProdOne.amount!
        total = total.decimalNumberByAdding(testProdTwo.amount!.decimalNumberByMultiplyingBy(NSDecimalNumber(integer: 2)))
        
        XCTAssertEqual(BasketBrain.sharedInstance.totalCostOfBasket(), total)
    }
    
    func testRemoveInvalidBasketItem() {
        let testProdOne = self.testProducts.first!
        let testProdTwo = self.testProducts[1]
        BasketBrain.sharedInstance.resetBasket() //required when we add new products
        BasketBrain.sharedInstance.addToBasket(testProdOne)
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasket(), 1)

        BasketBrain.sharedInstance.removeFromBasket(testProdTwo)
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasket(), 1)
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasketForGoods(testProdOne), 1)
        XCTAssertEqual(BasketBrain.sharedInstance.totalCostOfGoods(testProdOne), testProdOne.amount!)
        XCTAssertEqual(BasketBrain.sharedInstance.totalCostOfBasket(), testProdOne.amount!)
    }
    
    func testUniqueBasketItems() {
        let testProdOne = self.testProducts.first!
        let testProdTwo = self.testProducts[1]
        BasketBrain.sharedInstance.resetBasket() //required when we add new products
        BasketBrain.sharedInstance.addToBasket(testProdOne)
        BasketBrain.sharedInstance.addToBasket(testProdTwo)
        BasketBrain.sharedInstance.addToBasket(testProdTwo)
        
        let uniqueItems = BasketBrain.sharedInstance.uniqueItemsInBasket()
        for uniqueItem in uniqueItems {
            if uniqueItem.0.name != testProdOne.name && uniqueItem.0.name != testProdTwo.name {
                XCTFail()
            }
        }
    }
    
    func testEmptyBasket() {
        BasketBrain.sharedInstance.resetBasket() //required when we add new products
        
        XCTAssertEqual(BasketBrain.sharedInstance.totalItemsInBasket(), 0)
        XCTAssertEqual(BasketBrain.sharedInstance.totalCostOfBasket(), NSDecimalNumber(integer: 0))
    }

}
