//
//  ExchangeRate.swift
//  
//
//  Created by Andrew Reed on 05/06/2016.
//
//
import Foundation
import CoreData
import UIKit

/// class to hold the exchange rates
class ExchangeRate: CoreDataObject {
    
    /// The name of the object
    override class func objectName() -> String {
        return "ExchangeRate"
    }
    
    /// parseExchangeRates: Method used to parse an array of exchangeRates
    /// - managedObjectContext: The core data context
    /// - jsonDictionary: The dictionary of exchange rates
    /// - returns: The exchange rates
    static func parseExchangeRates(managedObjectContext: NSManagedObjectContext, jsonDictionary: [String:AnyObject]) -> [ExchangeRate] {
        var exchangeRates = [ExchangeRate]()
        if jsonDictionary.keys.contains("quotes") {
            if let serverExchangeRates = jsonDictionary["quotes"] as? [String: AnyObject] {
                for exchangeRateItem in serverExchangeRates.keys {
                    exchangeRates.append(ExchangeRate.parseExchangeRate(managedObjectContext, jsonDictionary: [exchangeRateItem:serverExchangeRates[exchangeRateItem]!]))
                }
            }
        }
        return exchangeRates
    }
    
    /// parseExchangeRate: Method used to parse a dictionary of an exchange rate
    /// - managedObjectContext: The core data context
    /// - jsonDictionary: The dictionary of data
    /// - returns: The parsed exchange rate
    static func parseExchangeRate(managedObjectContext: NSManagedObjectContext, jsonDictionary: [String:AnyObject]) -> ExchangeRate {
        ExchangeRate.deleteAllDataForIsoCode(managedObjectContext, isoCode: jsonDictionary.keys.first!)
        
        let entity = NSEntityDescription.entityForName(self.objectName(), inManagedObjectContext: managedObjectContext)
        let exchangeRate = ExchangeRate(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        exchangeRate.code = jsonDictionary.keys.first
        exchangeRate.rate = jsonDictionary[jsonDictionary.keys.first!] as? NSNumber
        
        return exchangeRate
    }
    
    /// deleteAllDataForIsoCode: Method to delete all the data for an iso code
    /// - managedObjectContext: The core data context
    /// - isoCode: The isoCode of the exchangerate
    static func deleteAllDataForIsoCode(managedObjectContext: NSManagedObjectContext, isoCode: String) {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName(self.objectName(), inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "code == %@", isoCode)
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
    
    
    /// getExchangeRateForCurrency: Method to get the exchange rate for currency
    /// - managedObjectContext: The core data context
    /// - returns: The stored exchange rate
    static func getExchangeRateForCurrency(managedObjectContext: NSManagedObjectContext, isoCode: String) -> ExchangeRate? {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName(self.objectName(), inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "code == 'USD\(isoCode)'")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            return results.first as? ExchangeRate
        } catch {
            let fetchError = error as NSError
            print("failed getExchangeRateForCurrency entity \(fetchError)")
        }
        
        return nil
    }
    
    /// getExchangeRates: Method to get the exchange rates
    /// - managedObjectContext: The core data context
    /// - returns: The stored exchange rates
    static func getExchangeRates(managedObjectContext: NSManagedObjectContext) -> [ExchangeRate] {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName(self.objectName(), inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entityDescription
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            if let exchangeRates = results as? [ExchangeRate] {
                return exchangeRates
            }
        } catch {
            let fetchError = error as NSError
            print("failed getExchangeRates entity \(fetchError)")
        }
        
        return [ExchangeRate]()
    }


}
