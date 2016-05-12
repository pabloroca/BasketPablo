//
//  GoodsDataControllerTests.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 12/05/2016.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import XCTest
@testable import BasketPablo

class GoodsDataControllerTests: XCTestCase {

   var itemsDatacontroller: GoodsDataController!
   
   override func setUp() {
      super.setUp()
      
      self.itemsDatacontroller = GoodsDataController()
      // clear entity
      self.itemsDatacontroller.deleteInLocalData()
      // load data into coreData
      self.initData()
   }
   
   override func tearDown() {
      super.tearDown()
      // clear entity
      self.itemsDatacontroller.deleteInLocalData()
   }
   
   func initData() {
      guard let info = NSBundle(forClass: self.dynamicType).infoDictionary else {
         XCTFail()
         return
      }
      let data: NSData = info["DataGoods"] as! NSData
      
      guard let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] else {
         return
      }
      
      self.itemsDatacontroller.addIntoLocalDatafromJSON(json!, completionHandler: { (success) in
      })
   }
   
   func testreadFromLocalData() {
      
      self.itemsDatacontroller.readFromLocalData(nil) { (success, data) in
         if success {
            XCTAssert(true, "Pass")
         } else {
            XCTFail()
         }
      }
   }
   
   func testreadFromLocalDataandData() {
      
      self.itemsDatacontroller.readFromLocalData(nil) { (success, data) in
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
      
      self.itemsDatacontroller.readFromLocalData(nil) { (success, data) in
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
