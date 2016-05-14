//
//  BasketViewController.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 11/5/16.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import UIKit

class BasketViewController: UITableViewController {
   
   //UI
   @IBOutlet var viewTable: UITableView!
   @IBOutlet weak var viewFooter: UIView!
   @IBOutlet weak var lblTotal: UILabel!
   @IBOutlet weak var lblCurrency: UILabel!
   //UI
   
   lazy var dataController = BasketDataController()
   lazy var settingsController = SettingsDataController()
   
   var arrData = [CDEBasket]()
   
   // MARK: - View livecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
      // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      
      self.reloadData()
   }
   
   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      
      self.reloadData()
      
      self.tabBarController!.navigationItem.title = NSLocalizedString("Basket.title", comment:"")
      
      self.settingsController.readFromLocalData(nil) { (success, data) in
         if let settings = data?.first {
            self.lblCurrency.text = settings.currencyselected
         }
      }

      // if we don't have currency and exchange, wait for finish download notificatiom
      // and refresh
      if self.arrData.isEmpty {
         NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(self.reloadData),
            name: Notifications.finishCurrencyExchangeDownloadNotification,
            object: nil
         )
      }
      
   }
   
   override func viewWillDisappear(animated: Bool) {
      super.viewWillDisappear(animated)
      NSNotificationCenter.defaultCenter().removeObserver(self)
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   // MARK: - Custom methods
   
   func reloadData() {
      self.dataController.readFromLocalData(nil) { (success, data, total) in
         if let data = data {
            self.arrData = data
            self.lblTotal.text = String(format: "%.2f", total)
            self.viewTable.reloadData()
         }
      }
   }
   
   func updateBasketBadge() {
      self.dataController.numItemsinBasket { (success, numitems) in
         self.tabBarController?.tabBar.items?.last?.badgeValue = numitems == 0 ? nil: "\(numitems)"
      }
   }
   
   // MARK: - Table view data source
   
   override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      if self.arrData.isEmpty {
         // Display a message when the table is empty
         let messageLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
         
         messageLabel.text = NSLocalizedString("ErrMsgNodatainBasketMsg", comment: "")
         messageLabel.textColor = UIColor.blackColor()
         messageLabel.numberOfLines = 0
         messageLabel.textAlignment = NSTextAlignment.Center
         messageLabel.sizeToFit()
         
         self.tableView.backgroundView = messageLabel
         self.tableView.separatorStyle = .None
         self.viewFooter.hidden = true
         return 0
      } else {
         self.tableView.backgroundView = nil
         self.viewFooter.hidden = false
         return 1
      }
   }
   
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.arrData.count
   }
   
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let item = self.arrData[indexPath.row]
      let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! BasketTableViewCell
      
      // Configure the cell...
      cell.configure(item)
      
      return cell
   }
   
   override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
      return true
   }
   
   override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
      if (editingStyle == UITableViewCellEditingStyle.Delete) {
         // handle Delete
         let item = self.arrData[indexPath.row]
         self.dataController.updateItemInBasket(item, units: 0, completionHandler: { (success) in
            self.updateBasketBadge()
         })
         // recalculate total
         self.dataController.readFromLocalData(nil) { (success, data, total) in
            self.lblTotal.text = String(format: "%.2f", total)
         }

         self.arrData.removeAtIndex(indexPath.row)
         tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
      }
   }
   
   @IBAction func stepMinusPlusAction(sender: UIStepper) {
      let point = sender.convertPoint(CGPoint(x: 0, y: 0), toView: tableView)
      let indexPath = self.tableView.indexPathForRowAtPoint(point)!
      let item = self.arrData[indexPath.row]
      self.dataController.updateItemInBasket(item, units: Int(sender.value), completionHandler: { (success) in
         self.updateBasketBadge()
      })
      // recalculate total
      self.dataController.readFromLocalData(nil) { (success, data, total) in
         self.lblTotal.text = String(format: "%.2f", total)
      }

      // 0 = delete row, != 0 update row
      if sender.value == 0 {
         self.arrData.removeAtIndex(indexPath.row)
         tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
      } else {
         self.viewTable.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
      }
   }
   
}
