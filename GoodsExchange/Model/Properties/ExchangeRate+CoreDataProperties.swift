//
//  ExchangeRate+CoreDataProperties.swift
//  
//
//  Created by Andrew Reed on 05/06/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ExchangeRate {

    @NSManaged var code: String?
    @NSManaged var rate: NSNumber?

}
