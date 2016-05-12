//
//  CurrencyDataController.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 11/5/16.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import Foundation
import CoreData
import PR2StudioSwift

/// CRUD operations (CoreData)
public class CurrencyDataController {
   
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
      completionHandler: (success: Bool, data: [CDECurrency]?) -> Void) {
      let fetchRequest = NSFetchRequest(entityName: CDECurrency.entityName())
      fetchRequest.sortDescriptors = [sortDescriptor]
      fetchRequest.predicate = predicate
      
      self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                 managedObjectContext: PR2CoreDataStack.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
      
      do {
         try self.fetchedResultsController.performFetch()
         if let data = self.fetchedResultsController.fetchedObjects as? [CDECurrency] {
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
      PR2CoreDataStack.sharedInstance.deleteAllData(CDECurrency.entityName())
   }
   
   /// addIntoLocalDatafromJSON: Add Items into CoreData
   /// - parameter data: The data to add (Dictionary).
   /// - parameter completionHandler: (success: Bool).
   public func addIntoLocalDatafromJSON(
      data: AnyObject,
      completionHandler: (success: Bool) -> Void) {
      self.deleteInLocalData()
      
      guard let results = data["currencies"] as? [String: String] else {
         completionHandler(success: false)
         return
      }
      
      for (key, value) in results {
         if (!key.isEmpty && !value.isEmpty) {
            let item = CDECurrency.init(managedObjectContext: PR2CoreDataStack.sharedInstance.managedObjectContext)
            
            item.currency = key
            item.name = value
         }
      }
      
      SettingsDataController().setTSforCurrency()
      
      // save context
      do {
         try PR2CoreDataStack.sharedInstance.managedObjectContext.save()
         completionHandler(success: true)
      } catch {
         completionHandler(success: false)
      }
   }
   
   /// changeDefaultCurrency: Add Items into CoreData
   /// - parameter toCurrency: String
   /// - parameter completionHandler: (success: Bool).
   public func changeDefaultCurrency(
      toCurrency: CDECurrency,
      completionHandler: (success: Bool) -> Void) {
      
      SettingsDataController().readFromLocalData(nil) { (success, data) in
         guard let settings = data?.first else {
            completionHandler(success: false)
            return
         }
         settings.currencyselected = toCurrency.currency
         
         BasketDataController().readFromLocalData(nil, completionHandler: { (success, data, total) in
            guard let results = data else {
               completionHandler(success: false)
               return
            }
            for item: CDEBasket in results {
               item.rBaskettoCurrency = toCurrency
            }
         })
         // save context
         do {
            try PR2CoreDataStack.sharedInstance.managedObjectContext.save()
            completionHandler(success: true)
         } catch {
            completionHandler(success: false)
         }

         //let currencyPredicate = NSPredicate(format: "currency == %@", settings.currencyselected!)
      }
   }
   
}
