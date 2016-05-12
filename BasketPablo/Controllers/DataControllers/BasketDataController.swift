//
//  BasketDataController.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 11/05/2016.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import Foundation
import CoreData
import PR2StudioSwift

/// CRUD operations (CoreData)
public class BasketDataController {
   
   var fetchedResultsController = NSFetchedResultsController()
   
   /// order by id
   lazy var sortDescriptor: NSSortDescriptor = {
      var sd = NSSortDescriptor(key: "ts", ascending: true)
      return sd
   }()
   
   /// readFromLocalData: Reads Items from CoreData
   /// - parameter predicate: predicate to use in search.
   /// - parameter completionHandler: (success: Bool).
   public func readFromLocalData(
      predicate: NSPredicate?,
      completionHandler: (success: Bool, data: [CDEBasket]?, total: Double) -> Void) {
      let fetchRequest = NSFetchRequest(entityName: CDEBasket.entityName())
      fetchRequest.sortDescriptors = [sortDescriptor]
      fetchRequest.predicate = predicate
      
      self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                 managedObjectContext: PR2CoreDataStack.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
      
      do {
         try self.fetchedResultsController.performFetch()
         if let data = self.fetchedResultsController.fetchedObjects as? [CDEBasket] {
            // calculate total according the exchange rate
            var total: Double = 0.0
            for item: CDEBasket in data {
               let priceraw = item.rBaskettoGoods?.price
               let price = (item.rBaskettoCurrency?.rCurrencytoExchange?.exchange)!*priceraw!
               total += Double(item.units)*price
            }
            completionHandler(success: true, data: data, total: total)
         } else {
            completionHandler(success: false, data: nil, total: 0)
         }
      } catch {
         completionHandler(success: false, data: nil, total: 0)
      }
   }
   
   /// deleteInLocalData: deletes all Items in CoreData
   public func deleteInLocalData() {
      PR2CoreDataStack.sharedInstance.deleteAllData(CDEBasket.entityName())
   }
   
   /// addIntoLocalDatafromJSON: Add Items into CoreData
   /// - parameter gooddata: The data to add (Dictionary).
   /// - parameter completionHandler: (success: Bool).
   public func addIntoLocalDatafromCDEGoods(
      gooddata: CDEGoods,
      completionHandler: (success: Bool) -> Void) {

      SettingsDataController().readFromLocalData(nil) { (success, data) in
         guard let settings = data?.first else {
            completionHandler(success: false)
            return
         }
         let goodPredicate = NSPredicate(format:"id == %@", gooddata.id!)
         GoodsDataController().readFromLocalData(goodPredicate, completionHandler: { (success, data) in
            guard let good = data?.first else {
               completionHandler(success: false)
               return
            }
            let currencyPredicate = NSPredicate(format:"currency == %@", settings.currencyselected!)
            CurrencyDataController().readFromLocalData(currencyPredicate, completionHandler: { (success, data) in
               guard let currency = data?.first else {
                  completionHandler(success: false)
                  return
               }
               
               if let item = good.rGoodstoBasket {
                  item.units += 1
                  item.ts = NSDate().timeIntervalSince1970
                  // save context
                  do {
                     try PR2CoreDataStack.sharedInstance.managedObjectContext.save()
                     completionHandler(success: true)
                  } catch {
                     completionHandler(success: false)
                  }
               } else {
                  let item = CDEBasket.init(managedObjectContext: PR2CoreDataStack.sharedInstance.managedObjectContext)
                  item.units = 1
                  item.rBaskettoCurrency = currency
                  item.rBaskettoGoods = good
                  item.ts = NSDate().timeIntervalSince1970
                  // save context
                  do {
                     try PR2CoreDataStack.sharedInstance.managedObjectContext.save()
                     completionHandler(success: true)
                  } catch {
                     completionHandler(success: false)
                  }
               }
               
            })
         })
      }
   }
   
   /// numItemsinBasket
   /// - parameter completionHandler: (success: Bool,numitems: Int).
   public func numItemsinBasket(
      completionHandler: (success: Bool, numitems: Int) -> Void) {
      self.readFromLocalData(nil) { (success, data, total) in
         if let data = data {
            completionHandler(success: success, numitems: data.count)
         } else {
            completionHandler(success: success, numitems: 0)
         }
      }
   }
   
   /// updateItemInBasket
   /// - parameter item: CDEBasket
   /// - parameter units: Int
   /// - parameter completionHandler: (success: Bool,numitems: Int)
   public func updateItemInBasket(
      item: CDEBasket,
      units: Int,
      completionHandler: (success: Bool) -> Void) {

      let basketPredicate = NSPredicate(format: "(SELF == %@)", item)
      
      self.readFromLocalData(basketPredicate) { (success, data, total) in
         if let data = data?.first {
            if units == 0 {
               // delete
               let managedContext = PR2CoreDataStack.sharedInstance.managedObjectContext
               managedContext.deleteObject(data)
            } else {
               // update units
               data.units = Int16(units)
            }
            // save context
            do {
               try PR2CoreDataStack.sharedInstance.managedObjectContext.save()
               completionHandler(success: true)
            } catch {
               completionHandler(success: false)
            }
         }
      }
   }
   
}
