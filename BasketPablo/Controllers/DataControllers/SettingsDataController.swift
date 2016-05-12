//
//  SettingsDataController.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 11/5/16.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import Foundation
import CoreData
import PR2StudioSwift

/// CRUD operations (CoreData)
public class SettingsDataController {
   
   var fetchedResultsController = NSFetchedResultsController()
   
   /// order by id
   lazy var sortDescriptor: NSSortDescriptor = {
      var sd = NSSortDescriptor(key: "currencybase", ascending: true)
      return sd
   }()
   
   /// readFromLocalData: Reads Items from CoreData
   /// - parameter predicate: predicate to use in search.
   /// - parameter completionHandler: (success: Bool).
   public func readFromLocalData(
      predicate: NSPredicate?,
      completionHandler: (success: Bool, data: [CDESettings]?) -> Void) {
      let fetchRequest = NSFetchRequest(entityName: CDESettings.entityName())
      fetchRequest.sortDescriptors = [sortDescriptor]
      fetchRequest.predicate = predicate
      
      self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                 managedObjectContext: PR2CoreDataStack.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
      
      do {
         try self.fetchedResultsController.performFetch()
         if let data = self.fetchedResultsController.fetchedObjects as? [CDESettings] {
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
      PR2CoreDataStack.sharedInstance.deleteAllData(CDESettings.entityName())
   }
   
   /// addInitialData: Add Initial data
   /// - parameter completionHandler: (success: Bool).
   public func addInitialData(
      completionHandler: (success: Bool) -> Void) {
      self.deleteInLocalData()
      
      let item = CDESettings.init(managedObjectContext: PR2CoreDataStack.sharedInstance.managedObjectContext)

      item.currencybase = "USD"
      item.currencyexchange = "USD"
      item.currencyselected = "USD"
      item.tscurrency = 0
      item.tsexchange = 0
      item.tsgoods = 0
      
      // save context
      do {
         try PR2CoreDataStack.sharedInstance.managedObjectContext.save()
         completionHandler(success: true)
      } catch {
         completionHandler(success: false)
      }
   }

   /// setTSforGoods
   public func setTSforGoods() {
      self.readFromLocalData(nil) { (success, data) in
         if let data = data?.first {
            data.tsgoods = NSDate().timeIntervalSince1970
         }
      }
   }

   /// setTSforCurrency
   public func setTSforCurrency() {
      self.readFromLocalData(nil) { (success, data) in
         if let data = data?.first {
            data.tscurrency = NSDate().timeIntervalSince1970
         }
      }
   }

   /// setTSforExchange
   public func setTSforExchange() {
      self.readFromLocalData(nil) { (success, data) in
         if let data = data?.first {
            data.tsexchange = NSDate().timeIntervalSince1970
         }
      }
   }

   /// setSourceforExchange
   /// - parameter source: String
   public func setSourceforExchange(source source: String) {
      self.readFromLocalData(nil) { (success, data) in
         if let data = data?.first {
            data.currencyexchange = source
         }
      }
   }

}
