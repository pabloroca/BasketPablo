//
//  ExchangeNetworkController.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 11/5/16.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import Foundation
import Alamofire
import PR2StudioSwift

/// Exchange network controller
public class ExchangeNetworkController {

   init() {}
   
   /// readFromServer: Reads Exchange JSON feed from network
   ///  - parameter completionHandler:  (success: Bool)
   public func readFromServer(
      completionHandler: (success: Bool) -> Void) {
      
      // read settings (for time stamp exchange)
      SettingsDataController().readFromLocalData(nil) { (success, data) in
         guard let settings = data?.first else {
            completionHandler(success: false)
            return
         }
         // read if we already have exchange data
         ExchangeDataController().readFromLocalData(nil, completionHandler: { (success, data) in
            guard let exchange = data else {
               completionHandler(success: false)
               return
            }
            // cache expired or empty exchange??
            guard (NSDate().timeIntervalSince1970 - settings.tsexchange > Constants.cacheExchangeTime ||
               exchange.isEmpty) else {
                  // cache not expired or not empty currencies
                  completionHandler(success: true)
                  return
            }
            // cache expired or empty exchange, read from network
            PR2Networking.sharedInstance.request(0, method:Alamofire.Method.GET, urlString: EndPoints.exchangerates, parameters: nil, encoding: .URL, headers: nil) { (success, response, statuscode) -> Void in
               guard success else {
                  completionHandler(success: false)
                  return
               }
               guard let JSON = response.result.value else {
                  completionHandler(success: false)
                  return
               }
               // add data in local storage
               ExchangeDataController().addIntoLocalDatafromJSON(JSON, completionHandler: { (success) in
                  guard success else {
                     completionHandler(success: false)
                     return
                  }
                  NSNotificationCenter.defaultCenter().postNotificationName(Notifications.finishCurrencyExchangeDownloadNotification, object: nil)
                  completionHandler(success: success)
               })
            }
         })
      }
   }
   
}
