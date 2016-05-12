//
//  MainTabbarViewController.swift
//  BasketPablo
//
//  Created by Pablo Roca Rozas on 11/05/2016.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

enum MainTab: Int {
    case TabGoods = 0
    case TabBasket
}

import UIKit

class MainTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.items![MainTab.TabGoods.rawValue].title = NSLocalizedString("MainTab.TabGoods", comment: "")
        self.tabBar.items![MainTab.TabBasket.rawValue].title = NSLocalizedString("MainTab.TabBasket", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
