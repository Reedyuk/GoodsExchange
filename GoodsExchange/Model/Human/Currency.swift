//
//  Currency.swift
//  
//
//  Created by Andrew Reed on 05/06/2016.
//
//

import Foundation
import CoreData
import UIKit

/// core data object to store currencies
class Currency: CoreDataObject {

    /// The name of the object
    override class func objectName() -> String {
        return "Currency"
    }

    /// parseCurrencies: Method used to parse an array of currencies
    /// - managedObjectContext: The core data context
    /// - jsonDictionary: The dictionary of currencies
    /// - returns: The currencies
    static func parseCurrencies(managedObjectContext: NSManagedObjectContext, jsonDictionary: [String:AnyObject]) -> [Currency] {
        var currencies = [Currency]()
        if jsonDictionary.keys.contains("currencies") {
            if let serverCurrencies = jsonDictionary["currencies"] as? [String: AnyObject] {
                for currencyItem in serverCurrencies.keys {
                    currencies.append(Currency.parseCurrency(managedObjectContext, jsonDictionary: [currencyItem:serverCurrencies[currencyItem]!]))
                }
            }
        }
        return currencies
    }
    
    /// parseCurrency: Method used to parse a dictionary of a currency
    /// - managedObjectContext: The core data context
    /// - jsonDictionary: The dictionary of data
    /// - returns: The parsed currency
    static func parseCurrency(managedObjectContext: NSManagedObjectContext, jsonDictionary: [String:AnyObject]) -> Currency {
        Currency.deleteAllDataForIsoCode(managedObjectContext, isoCode: jsonDictionary.keys.first!)
        
        let entity = NSEntityDescription.entityForName(self.objectName(), inManagedObjectContext: managedObjectContext)
        let currency = Currency(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        currency.isoCode = jsonDictionary.keys.first
        currency.name = jsonDictionary[jsonDictionary.keys.first!] as? String
        
        return currency
    }
    
    /// deleteAllDataForIsoCode: Method to delete all the data for an iso code
    /// - managedObjectContext: The core data context
    /// - isoCode: The isoCode of the currency
    static func deleteAllDataForIsoCode(managedObjectContext: NSManagedObjectContext, isoCode: String) {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName(self.objectName(), inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "isoCode == %@", isoCode)
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            for result in results {
                if let message = result as? NSManagedObject {
                    managedObjectContext.deleteObject(message)
                }
            }
        } catch {
            let fetchError = error as NSError
            print("failed to delete deleteAllDataForIsoCode entity \(fetchError)")
        }
    }

    
    /// getCurrencies: Method to get all stored currencies
    /// - managedObjectContext: The core data context
    /// - returns: The stored currencies
    static func getCurrencies(managedObjectContext: NSManagedObjectContext) -> [Currency] {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName(self.objectName(), inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entityDescription
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            if let currencies = results as? [Currency] {
                return currencies
            }
        } catch {
            let fetchError = error as NSError
            print("failed getCurrencies entity \(fetchError)")
        }
        
        return [Currency]()
    }
    
    /// getCurrencyForIsoCode: Method to get the currency for an iso code
    /// - managedObjectContext: The core data context
    /// - returns: The stored currency
    static func getCurrencyForIsoCode(managedObjectContext: NSManagedObjectContext, isoCode: String) -> Currency? {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName(self.objectName(), inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entityDescription
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "isoCode == %@", isoCode)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            return results.first as? Currency
        } catch {
            let fetchError = error as NSError
            print("failed getCurrencyForIsoCode entity \(fetchError)")
        }
        
        return nil
    }
    
    /// getDefaultCurrency: Method to get the default currency
    /// - managedObjectContext: The core data context
    /// - returns: The stored default currency
    static func getDefaultCurrency(managedObjectContext: NSManagedObjectContext) -> Currency? {
        return Currency.getCurrencyForIsoCode(managedObjectContext, isoCode: "USD")
    }
    
    /// currencySymbol: Method to get currency symbol from iso code
    /// returns: The symbol
    func currencySymbol() -> String? {
        if let isoCode = self.isoCode {
            let locale = NSLocale(localeIdentifier: isoCode)
            if let currencySymbol = locale.displayNameForKey(NSLocaleCurrencySymbol, value: isoCode) {
                return currencySymbol
            }
        }
        return self.isoCode
    }
}
