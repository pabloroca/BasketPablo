//
//  AppDelegate.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 11/5/16.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import UIKit
import PR2StudioSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
   var window: UIWindow?
   
   
   func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
      // Override point for customization after application launch.
      
      // initialize CoreData stack
      PR2CoreDataStack.sharedInstance.setdataModel("BasketPablo")
      
      // network logger
      PR2Networking.sharedInstance.logLevel = PR2NetworkingLogLevel.PR2NetworkingLogLevelInfo
      
      let settingsDataController = SettingsDataController()
      
      // Settings
      settingsDataController.readFromLocalData(nil) { (success, data) in
         // we do have settings, then read goods and currency from network
         if success && !data!.isEmpty {
            self.readDataFromNetWork()
         } else {
            // we don't have settings, so we create default ones
            settingsDataController.addInitialData({ (success) in
               // read goods and currency from network
               if success {
                  self.readDataFromNetWork()
               } else {
                  print("Error: Cannot create settings")
               }
            })
         }
      }
      
      return true
   }
   
   func readDataFromNetWork() {
      GoodsNetworkController().readFromServer(forceread: false) { (success) in
      }
      
      CurrencyNetworkController().readFromServer { (success) in
         ExchangeNetworkController().readFromServer { (success) in
         }
      }
      
   }
   
   func applicationWillResignActive(application: UIApplication) {
      // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   }
   
   func applicationDidEnterBackground(application: UIApplication) {
      // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   }
   
   func applicationWillEnterForeground(application: UIApplication) {
      // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   }
   
   func applicationDidBecomeActive(application: UIApplication) {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   }
   
   func applicationWillTerminate(application: UIApplication) {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
      PR2CoreDataStack.sharedInstance.saveContext()
   }
   
   
}
