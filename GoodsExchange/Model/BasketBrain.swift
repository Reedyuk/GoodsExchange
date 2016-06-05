//
//  BasketBrain.swift
//  GoodsExchange
//
//  Created by Andrew Reed on 04/06/2016.
//  Copyright © 2016 Andrew Reed. All rights reserved.
//

import Foundation
import UIKit

class BasketBrain : NSObject {
    static let sharedInstance = BasketBrain()   //singleton
    private var basket = [(Goods,Int)]()   /// the Global basket
    
    override init() {
        super.init()
        self.resetBasket()
    }
    
    /// addToBasket: Method to add items to the global basket.
    /// - goods: The item to buy
    func addToBasket(goods: Goods) {
        for i in 0 ..< self.basket.count {
            let basketItem = self.basket[i]
            if basketItem.0.name == goods.name {
                print ("Add to basket item \(goods.name) quantity \(basketItem.1)")
                self.basket.append((basketItem.0, (basketItem.1+1)))
                self.basket.removeAtIndex(i)
                break
            }
        }
    }
    /// removeFromBasket: Method to remove items to the global basket.
    /// - goods: The item to remove
    func removeFromBasket(goods: Goods) {
        for i in 0 ..< self.basket.count {
            let basketItem = self.basket[i]
            if basketItem.0.name == goods.name {
                if basketItem.1 > 0 {
                    print ("Remove from basket item \(goods.name) quantity \(basketItem.1)")
                    self.basket.append((basketItem.0, (basketItem.1-1)))
                    self.basket.removeAtIndex(i)
                    break
                }
            }
        }
    }
    
    /// totalItemsInBasket: Method to find out how many items we have in the basket
    /// returns: The number of items in basket.
    func totalItemsInBasket() -> Int {
        var itemsInBasket = 0
        for productTuple in self.basket {
            itemsInBasket += productTuple.1
        }
        return itemsInBasket
    }
    
    /// totalItemsInBasketForGoods: Method to find out how many items we have in the basket for a goods item
    /// returns: The number of items in basket for a product
    func totalItemsInBasketForGoods(goods: Goods) -> Int {
        var itemsInBasket = 0
        for productTuple in self.basket {
            if productTuple.0.name == goods.name {
                itemsInBasket += productTuple.1
            }
        }
        return itemsInBasket
    }
    
    /// uniqueItemsInBasket: Method to return the unique items in the basket
    /// returns: The unique items in the basket.
    func uniqueItemsInBasket() -> [(Goods, Int)] {
        var basketItems = [(Goods, Int)]()
        for basketItem in self.basket {
            if basketItem.1 > 0 {
                basketItems.append((basketItem.0, basketItem.1))
            }
        }
        return basketItems
    }
    
    /// totalCostOfGoods: Method to get the total costs of the goods in a basket
    /// goods: The goods to get the total for
    /// returns: THe total
    func totalCostOfGoods(goods: Goods) -> NSDecimalNumber {
        for basketItem in self.basket {
            if basketItem.0.name == goods.name {
                if basketItem.1 > 0 {
                    if let amount = goods.amount {
                        return amount.decimalNumberByMultiplyingBy(NSDecimalNumber(integer: basketItem.1))
                    }
                }
            }
        }
        return NSDecimalNumber(integer: 0)
    }
    
    /// totalCostOfBasket: Method to get the total costs of the whole basket
    /// returns: THe total of the basket
    func totalCostOfBasket() -> NSDecimalNumber {
        var total = NSDecimalNumber(integer: 0)
        for basketItem in self.basket {
            let basketItemTotal = self.totalCostOfGoods(basketItem.0)
            total = total.decimalNumberByAdding(basketItemTotal)
            print("Basket item \(basketItem.0.name!) item total \(basketItemTotal) total being \(total)")
        }
        return total
    }
    
    /// resetBasket: Method to empty the basket.
    func resetBasket() {
        let goods = Goods.getGoods((UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext)
        self.basket.removeAll()
        for product in goods {
            self.basket.append((product, 0))
        }
    }
    
}