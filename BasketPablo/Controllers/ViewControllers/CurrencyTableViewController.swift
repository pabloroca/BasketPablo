//
//  CurrencyTableViewController.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 12/5/16.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import UIKit

class CurrencyTableViewController: UITableViewController {
   
   //UI
   @IBOutlet var viewTable: UITableView!
   //UI
   
   var dataController = CurrencyDataController()
   
   var arrData = [CDECurrency]()
   
   // MARK: - View livecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.reloadData()
   }
   
   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      
      self.navigationItem.title = NSLocalizedString("Currency.title", comment:"")
      
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
      self.dataController.readFromLocalData(nil) { (success, data) in
         if let data = data {
            self.arrData = data
            self.viewTable.reloadData()
         }
      }
   }
   
   // MARK: - Table view data source
   
   override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      if self.arrData.isEmpty {
         // Display a message when the table is empty
         let messageLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
         
         messageLabel.text = NSLocalizedString("ErrMsgNodataCurrencyMsg", comment: "")
         messageLabel.textColor = UIColor.blackColor()
         messageLabel.numberOfLines = 0
         messageLabel.textAlignment = NSTextAlignment.Center
         messageLabel.sizeToFit()
         
         self.tableView.backgroundView = messageLabel
         self.tableView.separatorStyle = .None
         return 0
      } else {
         self.tableView.backgroundView = nil
         return 1
      }
   }
   
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.arrData.count
   }
   
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let item = self.arrData[indexPath.row]
      let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CurrencyTableViewCell
      
      // Configure the cell...
      cell.configure(item)
      
      return cell
   }
   
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      tableView.deselectRowAtIndexPath(indexPath, animated: false)
      let item = self.arrData[indexPath.row]

      self.dataController.changeDefaultCurrency(item) { (success) in
         if success {
            self.navigationController!.popViewControllerAnimated(true)
         }
      }
   }

}
