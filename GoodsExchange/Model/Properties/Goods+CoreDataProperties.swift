//
//  Goods+CoreDataProperties.swift
//  GoodsExchange
//
//  Created by Andrew Reed on 03/06/2016.
//  Copyright © 2016 Andrew Reed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Goods {

    @NSManaged var name: String?
    @NSManaged var amount: NSDecimalNumber?
    @NSManaged var currency: String?
    @NSManaged var image: String?
}
