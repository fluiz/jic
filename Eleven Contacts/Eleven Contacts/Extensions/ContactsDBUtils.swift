//
//  ContactsDBUtils.swift
//  Eleven Contacts
//
//  Created by Fabio Luiz on 26/05/19.
//  Copyright © 2019 Jobsity. All rights reserved.
//

import Foundation
import CoreData

// MARK: ContactsDB Extensions
extension ContactsDB {
    func getJsonData() -> Data? {
        if let path = Bundle.main.path(forResource: "contacts", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                //let data = try Data(contentsOf: URL(fileURLWithPath: path))
                
                return data
            } catch let error as NSError {
                print("JSON parsing Error: \(error.debugDescription)")
            }
        }
        return nil
    }
    
    func entityAlreadyExists(contact: ElevenContact) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: App.contactEntityName)
        fetchRequest.predicate = NSPredicate(format: "contactId = %@", contact.contactId)
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                return true
            }
        } catch let error as NSError {
            print("Core Data Error: \(error.debugDescription)")
            return false
        }
        
        return false
    }
    
    func checkContactsIsEmpty() -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
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
    
    func createStandardContacts() {
        // Get the Json data, decode into entities and add them to Core Data
        if let data = getJsonData() {
            let decoder = JSONDecoder()
            do {
                let contactList = try decoder.decode(ContactListStruct.self, from: data)
                
                contactList.contacts.forEach { (contact) in
                    createOrUpdate(contactStruct: contact)
                }
            } catch let error as NSError {
                print("Standard Contact Creation Error: \(error.debugDescription)")
            }
        }
    }
    
    
}
