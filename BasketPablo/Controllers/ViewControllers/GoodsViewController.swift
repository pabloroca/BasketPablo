//
//  GoodsViewController.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 11/5/16.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import UIKit

class GoodsViewController: UITableViewController {
   
   //UI
   @IBOutlet var viewTable: UITableView!
   //UI
   
   lazy var networkController = GoodsNetworkController()
   lazy var basketDataController = BasketDataController()
   
   let dataController = GoodsDataController()
   
   var arrData = [CDEGoods]()
   
   // MARK: - View livecycle

   override func viewDidLoad() {
      super.viewDidLoad()

      self.reloadData()
   }
   
   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)

      self.tabBarController!.navigationItem.title = NSLocalizedString("Goods.title", comment:"")

      self.updateBasketBadge()
      
      // if we don't have goods, wait for finish download notificatiom
      // and refresh
      if self.arrData.isEmpty {
         NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(self.reloadData),
            name: Notifications.finishGoodsDownloadNotification,
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
   
   @IBAction func refreshAction(sender: UIRefreshControl) {
      self.networkController.readFromServer(forceread: true) { (success) in
         if success {
            self.reloadData()
         }
         self.updateBasketBadge()
         sender.endRefreshing()
      }
   }
   
   func reloadData() {
      self.dataController.readFromLocalData(nil) { (success, data) in
         if let data = data {
            self.arrData = data
            self.viewTable.reloadData()
         }
      }
   }
   
   func updateBasketBadge() {
      self.basketDataController.numItemsinBasket { (success, numitems) in
         self.tabBarController?.tabBar.items?.last?.badgeValue = numitems == 0 ? nil: "\(numitems)"
      }
   }
   
   // MARK: - Table view data source
   
   override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      if self.arrData.isEmpty {
         // Display a message when the table is empty
         let messageLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
         
         messageLabel.text = NSLocalizedString("ErrMsgNodataMsg", comment: "")
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
      let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! GoodsTableViewCell
      
      // Configure the cell...
      cell.configure(item)
      
      cell.btnBuyTapBlock = {
         self.basketDataController.addIntoLocalDatafromCDEGoods(item, completionHandler: { (success) in
            self.updateBasketBadge()
         })
      }
      
      return cell
   }
   
}
