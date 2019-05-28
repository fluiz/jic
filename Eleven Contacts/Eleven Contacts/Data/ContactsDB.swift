//
//  ContactsDB.swift
//  Eleven Contacts
//
//  Created by Fabio Luiz on 24/05/19.
//  Copyright © 2019 Jobsity. All rights reserved.
//

import Foundation
import CoreData

class ContactsDB {
    internal let entityName = "Contact"
    internal let context: NSManagedObjectContext
    private let contactEntity: NSEntityDescription?
    private static let config = Config()
    
    // MARK: Singleton shared object
    static let shared: ContactsDB = {
        let instance = ContactsDB()
        return instance
    }()
    
    // MARK: Configuration subclass
    private class Config {
        var context: NSManagedObjectContext?
    }
    
    // MARK: Public configuration func
    class func setup(context: NSManagedObjectContext) {
        ContactsDB.config.context = context
    }
    
    // MARK: private init
    private init() {
        guard let checkContext = ContactsDB.config.context else {
            fatalError("Error: you must call setup method before using ContacDB.shared")
        }
        
        context = checkContext
        contactEntity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        
        if (checkContactsIsEmpty()) {
            createStandardContacts()
        }
    }
    
    // MARK: Database methods
    func createOrUpdate(contactStruct: ElevenContactStruct) {
        var managedContact: NSManagedObject? = nil
        var fetchResults: [NSManagedObject]? = []
        let contact = ElevenContact(fromContactStruct: contactStruct)
        
        if (entityAlreadyExists(contact: contact)) {
            // Proceed update
            print("Updating contact \(contact.firstName) \(contact.lastName) with id: \(contact.contactId)")
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: App.contactEntityName)
            fetchRequest.predicate = NSPredicate(format: "contactId = %@", contact.contactId)
            
            do {
                fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject]
            } catch let error as NSError {
                print("Saving Core Data Failed: \(error.debugDescription)")
            }
            
            if (fetchResults?.count != 0) {
                managedContact = fetchResults?[0]
            }
        } else {
            // Proceed creation
            print("Creating contact \(contact.firstName) \(contact.lastName) with id: \(contact.contactId)")
            let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)!
            managedContact = NSManagedObject(entity: entity, insertInto: context)
            managedContact!.setValue(contact.firstName+contact.lastName+contact.phoneNumber, forKey: "contactId")
        }
        
        managedContact!.setValue(contact.firstName, forKey: "firstName")
        managedContact!.setValue(contact.lastName, forKey: "lastName")
        managedContact!.setValue(contact.phoneNumber, forKey: "phoneNumber")
        managedContact!.setValue(contact.streetAddress1, forKey: "streetAddress1")
        managedContact!.setValue(contact.streetAddress2, forKey: "streetAddress2")
        managedContact!.setValue(contact.city, forKey: "city")
        managedContact!.setValue(contact.state, forKey: "state")
        managedContact!.setValue(contact.zipCode, forKey: "zipCode")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Saving Core Data Failed: \(error.debugDescription)")
        }
    }
    
    func retrieveContacts(_ success: @escaping (_ contacts: [ElevenContact]) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: App.contactEntityName)
        
        do {
            let results = try context.fetch(fetchRequest) as! [ElevenContact]
            let sortedResults = results.sorted(by: { $0.lastName < $1.lastName })
            success(sortedResults)
        } catch let error as NSError {
            print("Core Data Error: \(error.debugDescription)")
            failure(error)
        }
    }
    
    func delete(_ contactId: String) {
        print("Deleting contact with id: \(contactId)")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: App.contactEntityName)
        fetchRequest.predicate = NSPredicate(format: "contactId = %@", contactId)
        
        do {
            let test = try context.fetch(fetchRequest)
            let objectToDelete = test[0] as! NSManagedObject
            context.delete(objectToDelete)
            try context.save()
        } catch let error as NSError {
            print("Core Data Error: \(error.debugDescription)")
        }
    }
}
