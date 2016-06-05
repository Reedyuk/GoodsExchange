//
//  Goods.swift
//  GoodsExchange
//
//  Created by Andrew Reed on 03/06/2016.
//  Copyright © 2016 Andrew Reed. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Goods: CoreDataObject {

    /// The name of the object
    override class func objectName() -> String {
        return "Goods"
    }
    
    /// createDefaultGoods: function to generate the default goods.
    static func createDefaultGoods() {
        //wipe existing goods.
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        Goods.deleteAllData(context)
        
        //create new objects.
        let arrayOfGoods = [["name":"Peas", "amount":0.95, "image":"peas"],["name":"Eggs", "amount":2.10, "image":"egg"],["name":"Milk", "amount":1.30, "image":"milk"],["name":"Beans", "amount":0.73, "image":"beans"]]
        Goods.parseArrayOfGoods(context, jsonDictionary: arrayOfGoods)
        
    }
    
    /// parseArrayOfGoods: Method used to parse an array of goods
    /// - managedObjectContext: The core data context
    /// - jsonDictionary: The dictionary of goods
    /// - returns: The goods
    static func parseArrayOfGoods(managedObjectContext: NSManagedObjectContext, jsonDictionary: [[String:NSObject]]) -> [Goods] {
        var goods = [Goods]()
        
        for goodsDict in jsonDictionary {
            goods.append(Goods.parseGoods(managedObjectContext, jsonDictionary: goodsDict))

        }
        return goods
    }
    
    /// parseGoods: Method used to parse a dictionary of goods
    /// - managedObjectContext: The core data context
    /// - jsonDictionary: The dictionary of data
    /// - returns: The parsed goods
    static func parseGoods(managedObjectContext: NSManagedObjectContext, jsonDictionary: [String:NSObject]) -> Goods {
        let entity = NSEntityDescription.entityForName(self.objectName(), inManagedObjectContext: managedObjectContext)
        let goods = Goods(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        if let name = jsonDictionary["name"] as? String {
            goods.name = name
        }
        if let amount = jsonDictionary["amount"] as? NSNumber {
            goods.amount = NSDecimalNumber(double:amount.doubleValue)
        }
        if let currency = jsonDictionary["currency"] as? String {
            goods.currency = currency
        }
        if let image = jsonDictionary["image"] as? String {
            goods.image = image
        }
        
        return goods
    }

    /// getGoods: Method to get all stored goods
    /// - managedObjectContext: The core data context
    /// - returns: The stored goods
    static func getGoods(managedObjectContext: NSManagedObjectContext) -> [Goods] {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName(self.objectName(), inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entityDescription
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            if let goods = results as? [Goods] {
                return goods
            }
        } catch {
            let fetchError = error as NSError
            print("failed getGoods entity \(fetchError)")
        }
        
        return [Goods]()
    }
    
    /// getGoodsForName: Method to get a goods item by name
    /// - managedObjectContext: The core data context
    /// - name: The name of the goods item
    /// - returns: The stored goods item
    static func getGoodsForName(managedObjectContext: NSManagedObjectContext, name: String) -> Goods? {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName(self.objectName(), inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entityDescription
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            return results.first as? Goods
        } catch {
            let fetchError = error as NSError
            print("failed getGoodsForName entity \(fetchError)")
        }
        
        return nil
    }
    
    
    /// getDefaultCurrency: Method to get a default currency
    /// - returns: The default currency
    static func getDefaultCurrency() -> String {
        return "$"
    }
}
