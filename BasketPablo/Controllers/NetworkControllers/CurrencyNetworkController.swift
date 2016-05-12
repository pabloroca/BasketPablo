//
//  CurrencyNetworkController.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 11/5/16.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import Foundation
import Alamofire
import PR2StudioSwift

/// Currency network controller
public class CurrencyNetworkController {
   
   init() {}
   
   /// readFromServer: Reads Currency JSON feed from network
   ///  - parameter completionHandler:  (success: Bool)
   public func readFromServer(
      completionHandler: (success: Bool) -> Void) {
      
      // read settings (for time stamp currency)
      SettingsDataController().readFromLocalData(nil) { (success, data) in
         guard let settings = data?.first else {
            completionHandler(success: false)
            return
         }
         // read if we already have currency data
         CurrencyDataController().readFromLocalData(nil, completionHandler: { (success, data) in
            guard let currency = data else {
               completionHandler(success: false)
               return
            }
            // cache expired or empty currencies??
            guard (NSDate().timeIntervalSince1970 - settings.tscurrency > Constants.cacheCurrencyTime ||
               currency.isEmpty) else {
                  // cache not expired or not empty currencies
                  completionHandler(success: true)
                  return
            }
            // cache expired or empty currencies, read from network
            PR2Networking.sharedInstance.request(0, method:Alamofire.Method.GET, urlString: EndPoints.currencylist, parameters: nil, encoding: .URL, headers: nil) { (success, response, statuscode) -> Void in
               guard success else {
                  completionHandler(success: false)
                  return
               }
               guard let JSON = response.result.value else {
                  completionHandler(success: false)
                  return
               }
               // add data in local storage
               CurrencyDataController().addIntoLocalDatafromJSON(JSON, completionHandler: { (success) in
                  guard success else {
                     completionHandler(success: false)
                     return
                  }
                  completionHandler(success: success)
               })
            }
         })
      }
   }

}
