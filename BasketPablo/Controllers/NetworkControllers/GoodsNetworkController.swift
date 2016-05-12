//
//  GoodsNetworkController.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 11/05/2016.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import Foundation
import Alamofire
import PR2StudioSwift

/// Goods network controller
public class  GoodsNetworkController {
   
   init() {}
   
   /// readFromServer: Reads Goods JSON feed from network
   ///  - parameter forceread:  We force to read from network (bool)
   ///  - parameter completionHandler:  (success: Bool)
   public func readFromServer(
      forceread forceread: Bool,
      completionHandler: (success: Bool) -> Void) {
      
      // read settings (for time stamp Goods)
      SettingsDataController().readFromLocalData(nil) { (success, data) in
         guard let settings = data?.first else {
            completionHandler(success: false)
            return
         }
         // read if we already have goods data
         GoodsDataController().readFromLocalData(nil, completionHandler: { (success, data) in
            guard let goods = data else {
               completionHandler(success: false)
               return
            }
            // cache expired or empty goods??
            guard (NSDate().timeIntervalSince1970 - settings.tsgoods > Constants.cacheGoodsTime ||
               goods.isEmpty || forceread) else {
                  // cache not expired or not empty goods
                  completionHandler(success: true)
                  return
            }
            // cache expired or empty goods or forceread, read from network
            PR2Networking.sharedInstance.request(0, method:Alamofire.Method.GET, urlString: EndPoints.goods, parameters: nil, encoding: .URL, headers: nil) { (success, response, statuscode) -> Void in
               guard success else {
                  completionHandler(success: false)
                  return
               }
               guard let JSON = response.result.value else {
                  completionHandler(success: false)
                  return
               }
               // add data in local storage
               GoodsDataController().addIntoLocalDatafromJSON(JSON, completionHandler: { (success) in
                  guard success else {
                     completionHandler(success: false)
                     return
                  }
                  NSNotificationCenter.defaultCenter().postNotificationName(Notifications.finishGoodsDownloadNotification, object: nil)
                  completionHandler(success: success)
               })
            }
         })
      }
   }
   
}
