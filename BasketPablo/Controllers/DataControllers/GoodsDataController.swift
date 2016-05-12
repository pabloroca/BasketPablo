//
//  GoodsDataController.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 11/05/2016.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import Foundation
import CoreData
import PR2StudioSwift

/// CRUD operations (CoreData)
public class GoodsDataController {
    
    var fetchedResultsController = NSFetchedResultsController()
    
    /// order by id
    lazy var sortDescriptor: NSSortDescriptor = {
        var sd = NSSortDescriptor(key: "name", ascending: true)
        return sd
    }()
    
    /// readFromLocalData: Reads Items from CoreData
    /// - parameter predicate: predicate to use in search.
    /// - parameter completionHandler: (success: Bool).
    public func readFromLocalData(
        predicate: NSPredicate?,
        completionHandler: (success: Bool, data: [CDEGoods]?) -> Void) {
        let fetchRequest = NSFetchRequest(entityName: CDEGoods.entityName())
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                   managedObjectContext: PR2CoreDataStack.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try self.fetchedResultsController.performFetch()
            if let data = self.fetchedResultsController.fetchedObjects as? [CDEGoods] {
                completionHandler(success: true, data: data)
            } else {
                completionHandler(success: false, data: nil)
            }
        } catch {
            completionHandler(success: false, data: nil)
        }
    }
    
    /// deleteInLocalData: deletes all Items in CoreData
    public func deleteInLocalData() {
        PR2CoreDataStack.sharedInstance.deleteAllData(CDEGoods.entityName())
    }
    
    /// addIntoLocalDatafromJSON: Add Items into CoreData
    /// - parameter data: The data to add (Dictionary).
    /// - parameter completionHandler: (success: Bool).
    public func addIntoLocalDatafromJSON(
        data: AnyObject,
        completionHandler: (success: Bool) -> Void) {
        self.deleteInLocalData()
      
      guard let results = data["Results"] as? [[String: AnyObject]] else {
         completionHandler(success: false)
         return
      }
      for ditem: Dictionary in results {
         let item = CDEGoods.init(managedObjectContext: PR2CoreDataStack.sharedInstance.managedObjectContext)
         
         // we protect agains nil objects in XML
         
         if let gid = ditem["id"] as? String {
            item.id = gid
         } else {
            item.id = ""
         }
         if let name = ditem["name"] as? String {
            item.name = name
         } else {
            item.name = ""
         }
         if let price = ditem["price"] as? Double {
            item.price = price
         } else {
            item.price = 0
         }
         if let unittype = ditem["unittype"] as? String {
            item.unittype = unittype
         } else {
            item.unittype = ""
         }
      }
      
      SettingsDataController().setTSforGoods()
      
      // save context
      do {
         try PR2CoreDataStack.sharedInstance.managedObjectContext.save()
         completionHandler(success: true)
      } catch {
         completionHandler(success: false)
      }
    }
   
}
