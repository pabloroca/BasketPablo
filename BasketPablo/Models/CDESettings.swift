//
//  CDESettings.swift
//  
//
//  Created by Pablo Roca Rozas on 11/05/2016.
//
//

import Foundation
import CoreData

/// CDESettings
@objc(CDESettings)
public class CDESettings: NSManagedObject {

    // MARK: - Class methods
    /// entityName
    /// - returns: String
    class func entityName () -> String {
        return "CDESettings"
    }
    
    /// entity: Entity description
    /// - parameter managedObjectContext: Managed Object Context.
    /// - returns: Entity description (NSEntityDescription).
    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext)
    }
    
    // MARK: - Life cycle methods
    
    /// init: Designated initializer
    /// - parameter entity: Entity description.
    /// - parameter context: Managed Object Context.
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    /// init: Convenience initializer
    /// - parameter managedObjectContext: Managed Object Context.
    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = CDESettings.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

}
