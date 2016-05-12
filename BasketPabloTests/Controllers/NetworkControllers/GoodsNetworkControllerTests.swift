//
//  GoodsNetworkControllerTests.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 12/5/16.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import XCTest
import PR2StudioSwift
@testable import BasketPablo

class GoodsNetworkControllerTests: XCTestCase {
   
   override func setUp() {
      super.setUp()
      
      // initialize CoreData stack
      PR2CoreDataStack.sharedInstance.setdataModel("BasketPablo")
      
      // delete data
      PR2CoreDataStack.sharedInstance.deleteAllData("CDEGoods")
      
   }
   
   override func tearDown() {
      super.tearDown()
      
      // delete data
      PR2CoreDataStack.sharedInstance.deleteAllData("CDEGoods")
   }
   
   func testreadFromServer() {
      let expectation = self.expectationWithDescription("check if network connection can be made")
      
      SettingsDataController().deleteInLocalData()
      SettingsDataController().addInitialData { (success) in
         GoodsNetworkController().readFromServer(forceread: true) { (success) in
            if !success {
               XCTFail()
            }
            expectation.fulfill()
         }
      }
      self.waitForExpectationsWithTimeout(30.0, handler: nil)
   }
   
}
