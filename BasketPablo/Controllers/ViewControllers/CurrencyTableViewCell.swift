//
//  CurrencyTableViewCell.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 12/5/16.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
   
   @IBOutlet weak var lblCurrency: UILabel!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
   }
   
   override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
      // Configure the view for the selected state
   }
   
   func configure(item: CDECurrency) {
      self.lblCurrency.text = item.currency! + " - " + item.name!
   }

}
