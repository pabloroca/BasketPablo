//
//  CDEExchange+CoreDataProperties.swift
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

extension CDEExchange {

    @NSManaged var currency: String?
    @NSManaged var exchange: Double
    @NSManaged var rExchangetoCurrency: CDECurrency?

}
