//
//  CoreDataObject.swift
//  GoodsExchange
//
//  Created by Andrew Reed on 03/06/2016.
//  Copyright © 2016 Andrew Reed. All rights reserved.
//

import Foundation
import CoreData

/// base class for core data objects
class CoreDataObject: NSManagedObject {
    
    ///objectName: Method to expose the object name in core data
    /// - returns: The string name
    class func objectName() -> String {
        return ""
    }
    
    /// deleteAllData: Deletes all objects
    /// - managedObjectContext: The core data context
    class func deleteAllData(managedObjectContext: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName(self.objectName(), inManagedObjectContext: managedObjectContext)
        print("About to delete \(self.objectName()) entity")
        fetchRequest.entity = entityDescription
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            for result in results {
                if let teacherProfile = result as? NSManagedObject {
                    managedObjectContext.deleteObject(teacherProfile)
                }
            }
        } catch {
            let fetchError = error as NSError
            print("failed to delete \(self.objectName()) entity \(fetchError)")
        }
    }
    
}
