//
//  CDEGoods+CoreDataProperties.swift
//  
//
//  Created by Pablo Roca Rozas on 11/05/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDEGoods {

    @NSManaged var name: String?
    @NSManaged var price: Double
    @NSManaged var unittype: String?
    @NSManaged var id: String?
    @NSManaged var rGoodstoBasket: CDEBasket?

}
