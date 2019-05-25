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
    private let entity = "Contact"
    private let context: NSManagedObjectContext
    private let contactEntity: NSEntityDescription?
    private static let config = Config()
    
    // Singleton shared object
    static let shared: ContactsDB = {
        let instance = ContactsDB()
        return instance
    }()
    
    // Configuration subclass
    private class Config {
        var context: NSManagedObjectContext?
    }
    
    // Public configuration func
    class func setup(context: NSManagedObjectContext) {
        ContactsDB.config.context = context
    }
    
    private init() {
        guard let checkContext = ContactsDB.config.context else {
            fatalError("Error: you must call setup method before using ContacDB.shared")
        }
        
        context = checkContext
        contactEntity = NSEntityDescription.entity(forEntityName: "Contact", in: context)
        
        if (checkContactsIsEmpty()) {
            createStandardContacts()
        }
    }
    
    private func checkContactsIsEmpty() -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        do {
            let results: NSArray? = try context.fetch(request) as NSArray
            if (results?.count == 0) {
                return true
            }
        } catch let error as NSError {
            print("Core Data Error: \(error.debugDescription)")
            return true
        }
        return false
    }
    
    private func createStandardContacts() {
        // Get the Json data, decode into entities and add them to Core Data
        if let data = DataHelper.getJsonData() {
            let decoder = JSONDecoder()
            do {
                let contacts = try decoder.decode([ElevenContact].self, from: data)
                contacts.forEach { (contact) in
                    add(contact: contact)
                }
            } catch let error as NSError {
                print("Core Data Error: \(error.debugDescription)")
            }
        }
    }
    
    func add(contact: ElevenContact) {
        
    }
}
