//
//  BasketTableViewCell.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 11/5/16.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import UIKit

class BasketTableViewCell: UITableViewCell {
   
   @IBOutlet weak var lblGood: UILabel!
   @IBOutlet weak var lblPrice: UILabel!
   @IBOutlet weak var lblUnits: UILabel!
   @IBOutlet weak var stepPlusMinus: UIStepper!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
   }
   
   override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
      // Configure the view for the selected state
   }
   
   // exchange rates
   func configure(item: CDEBasket) {
      self.lblGood.text = item.rBaskettoGoods?.name
      
      let priceraw = item.rBaskettoGoods?.price
      let price = (item.rBaskettoCurrency?.rCurrencytoExchange?.exchange)!*priceraw!

      self.lblPrice.text = String(format: "%.2f", price)
      self.lblUnits.text = "\(item.units)"
      self.stepPlusMinus.value = Double(item.units)
   }
   
}
