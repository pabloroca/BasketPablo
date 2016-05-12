//
//  CurrencyNetworkControllerTests.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 12/05/2016.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import XCTest
import PR2StudioSwift
@testable import BasketPablo

class CurrencyNetworkControllerTests: XCTestCase {

   override func setUp() {
      super.setUp()
      
      // initialize CoreData stack
      PR2CoreDataStack.sharedInstance.setdataModel("BasketPablo")
      
      // delete data
      PR2CoreDataStack.sharedInstance.deleteAllData("CDECurrency")
      
   }
   
   override func tearDown() {
      super.tearDown()
      
      // delete data
      PR2CoreDataStack.sharedInstance.deleteAllData("CDECurrency")
   }
   
   func testreadFromServer() {
      let expectation = self.expectationWithDescription("check if network connection can be made")
      
      SettingsDataController().deleteInLocalData()
      SettingsDataController().addInitialData { (success) in
         CurrencyNetworkController().readFromServer({ (success) in
            if !success {
               XCTFail()
            }
            expectation.fulfill()
         })
      }
      self.waitForExpectationsWithTimeout(30.0, handler: nil)
   }

}
