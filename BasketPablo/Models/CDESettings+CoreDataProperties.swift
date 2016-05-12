//
//  CDESettings+CoreDataProperties.swift
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

extension CDESettings {

    @NSManaged var currencybase: String?
    @NSManaged var currencyexchange: String?
    @NSManaged var currencyselected: String?
    @NSManaged var tscurrency: Double
    @NSManaged var tsexchange: Double
    @NSManaged var tsgoods: Double

}
