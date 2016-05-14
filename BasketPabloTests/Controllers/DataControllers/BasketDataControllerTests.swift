//
//  BasketDataControllerTests.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 12/05/2016.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import XCTest
@testable import BasketPablo

class BasketDataControllerTests: XCTestCase {

   var itemsDatacontroller: BasketDataController!
   var goodsDatacontroller: GoodsDataController!
   var currencyDatacontroller: CurrencyDataController!
   var exchangeDatacontroller: ExchangeDataController!
   
   override func setUp() {
      super.setUp()
      
      self.itemsDatacontroller = BasketDataController()
      self.goodsDatacontroller = GoodsDataController()
      self.currencyDatacontroller = CurrencyDataController()
      self.exchangeDatacontroller = ExchangeDataController()
      
      // clear entity
      self.itemsDatacontroller.deleteInLocalData()
      self.goodsDatacontroller.deleteInLocalData()
      self.currencyDatacontroller.deleteInLocalData()
      self.exchangeDatacontroller.deleteInLocalData()
      
      // load data into coreData
      self.initData()
   }
   
   override func tearDown() {
      super.tearDown()
      // clear entity
      self.itemsDatacontroller.deleteInLocalData()
      self.goodsDatacontroller.deleteInLocalData()
      self.currencyDatacontroller.deleteInLocalData()
      self.exchangeDatacontroller.deleteInLocalData()
   }
   
   func initData() {
      
      guard let info = NSBundle(forClass: self.dynamicType).infoDictionary else {
         XCTFail()
         return
      }
      
      let dataCurrency: NSData = info["DataCurrency"] as! NSData

      guard let jsonCurrency = try? NSJSONSerialization.JSONObjectWithData(dataCurrency, options: []) as? [String: AnyObject] else {
         return
      }
      
      self.currencyDatacontroller.addIntoLocalDatafromJSON(jsonCurrency!, completionHandler: { (success) in
      })

      
      let dataExchange: NSData = info["DataExchange"] as! NSData

      guard let jsonExchange = try? NSJSONSerialization.JSONObjectWithData(dataExchange, options: []) as? [String: AnyObject] else {
         return
      }
      
      self.exchangeDatacontroller.addIntoLocalDatafromJSON(jsonExchange!, completionHandler: { (success) in
      })

      let datagoods: NSData = info["DataGoods"] as! NSData
      
      guard let jsonGoods = try? NSJSONSerialization.JSONObjectWithData(datagoods, options: []) as? [String: AnyObject] else {
         XCTFail()
         return
      }

      self.goodsDatacontroller.addIntoLocalDatafromJSON(jsonGoods!, completionHandler: { (success) in
         self.goodsDatacontroller.readFromLocalData(nil, completionHandler: { (success, data) in
            guard let results = data else {
               XCTFail()
               return
            }
            for good: CDEGoods in results {
               self.itemsDatacontroller.addIntoLocalDatafromCDEGoods(good, completionHandler: { (success) in
               })
            }
         })
      })
      
      
   }
   
   func testreadFromLocalData() {
      
      self.itemsDatacontroller.readFromLocalData(nil) { (success, data, total) in
         if success {
            XCTAssert(true, "Pass")
         } else {
            XCTFail()
         }
      }
   }
   
   func testreadFromLocalDataandData() {
      
      self.itemsDatacontroller.readFromLocalData(nil) { (success, data, total) in
         if let records = data?.count {
            if (success && records > 0) {
               XCTAssert(true, "Pass")
            } else {
               XCTFail()
            }
         } else {
            XCTFail()
         }
      }
   }
   
   func testdeleteInLocalData() {
      
      self.itemsDatacontroller.deleteInLocalData()
      
      self.itemsDatacontroller.readFromLocalData(nil) { (success, data, total) in
         if let records = data?.count {
            if (success && records == 0) {
               XCTAssert(true, "Pass")
            } else {
               XCTFail()
            }
         } else {
            XCTFail()
         }
      }
   }

}
