//
//  ExchangeDataController.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 11/5/16.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import Foundation
import CoreData
import PR2StudioSwift

/// CRUD operations (CoreData)
public class ExchangeDataController {
   
   var fetchedResultsController = NSFetchedResultsController()
   
   /// order by id
   lazy var sortDescriptor: NSSortDescriptor = {
      var sd = NSSortDescriptor(key: "currency", ascending: true)
      return sd
   }()
   
   /// readFromLocalData: Reads Items from CoreData
   /// - parameter predicate: predicate to use in search.
   /// - parameter completionHandler: (success: Bool).
   public func readFromLocalData(
      predicate: NSPredicate?,
      completionHandler: (success: Bool, data: [CDEExchange]?) -> Void) {
      let fetchRequest = NSFetchRequest(entityName: CDEExchange.entityName())
      fetchRequest.sortDescriptors = [sortDescriptor]
      fetchRequest.predicate = predicate
      
      self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                 managedObjectContext: PR2CoreDataStack.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
      
      do {
         try self.fetchedResultsController.performFetch()
         if let data = self.fetchedResultsController.fetchedObjects as? [CDEExchange] {
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
      PR2CoreDataStack.sharedInstance.deleteAllData(CDEExchange.entityName())
   }
   
   /// addIntoLocalDatafromJSON: Add Items into CoreData
   /// - parameter data: The data to add (Dictionary).
   /// - parameter completionHandler: (success: Bool).
   public func addIntoLocalDatafromJSON(
      data: AnyObject,
      completionHandler: (success: Bool) -> Void) {
      self.deleteInLocalData()
      
      guard let results = data["quotes"] as? [String: Double] else {
         completionHandler(success: false)
         return
      }
      
      let currencyDataController = CurrencyDataController()
      
      for (key, value) in results {
         if (!key.isEmpty) {
            let item = CDEExchange.init(managedObjectContext: PR2CoreDataStack.sharedInstance.managedObjectContext)
            
            let currencyright = key.substringFromIndex(key.endIndex.advancedBy(-3))
            
            item.currency = currencyright
            item.exchange = value
            
            // relationship rCurrencytoExchange
            let currencyPredicate = NSPredicate(format: "currency == %@", currencyright)
            currencyDataController.readFromLocalData(currencyPredicate, completionHandler: { (success, data) in
               if let data = data?.first {
                  data.rCurrencytoExchange = item
               }
            })
         }
      }
      
      if let source = data["source"] as? String {
         SettingsDataController().setSourceforExchange(source: source)
      }
      SettingsDataController().setTSforExchange()
      
      // save context
      do {
         try PR2CoreDataStack.sharedInstance.managedObjectContext.save()
         completionHandler(success: true)
      } catch {
         completionHandler(success: false)
      }
   }
   
}
