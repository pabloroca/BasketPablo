//
//  Constants.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 11/5/16.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import Foundation

/// Constants for the App
public struct Constants {
   
   /// cache time for goods (in seconds)
   /// set to 1 day
   static let cacheGoodsTime: Double = 60*60*24

   /// cache time for currency (in seconds)
   /// set to 1 day
   static let cacheCurrencyTime: Double = 60*60*24

   /// cache time for exchange (in seconds)
   /// free plan is 60 minutes
   static let cacheExchangeTime: Double = 60*60

}
