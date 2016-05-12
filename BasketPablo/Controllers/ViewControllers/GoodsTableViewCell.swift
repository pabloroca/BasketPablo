//
//  GoodsTableViewCell.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 11/5/16.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import UIKit

class GoodsTableViewCell: UITableViewCell {
   
   @IBOutlet weak var lblGood: UILabel!
   @IBOutlet weak var lblUnittype: UILabel!
   @IBOutlet weak var lblPrice: UILabel!
   @IBOutlet weak var btnBuy: UIButton!
   
   var btnBuyTapBlock: dispatch_block_t?
   
   override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
   }
   
   override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
      // Configure the view for the selected state
   }
   
   func configure(item: CDEGoods) {
      self.lblGood.text = item.name
      self.lblUnittype.text = item.unittype
      self.lblPrice.text = String(format: "%.2f", item.price)
   }
   
   @IBAction func btnBuyAction(sender: AnyObject) {
      if let btnBuyTapBlock = self.btnBuyTapBlock {
         btnBuyTapBlock()
      }
   }
   
}
