//
//  CDEBasket+CoreDataProperties.swift
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

extension CDEBasket {

    @NSManaged var units: Int16
    @NSManaged var ts: Double
    @NSManaged var rBaskettoGoods: CDEGoods?
    @NSManaged var rBaskettoCurrency: CDECurrency?

}
