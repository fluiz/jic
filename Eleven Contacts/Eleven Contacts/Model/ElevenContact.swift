//
//  Contact.swift
//  Eleven Contacts
//
//  Created by Fabio Luiz on 24/05/19.
//  Copyright © 2019 Jobsity. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ElevenContact: NSManagedObject {
    
    // MARK: Core Data Managed Object
    @NSManaged var contactId: String
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var phoneNumber: String
    @NSManaged var streetAddress1: String
    @NSManaged var streetAddress2: String
    @NSManaged var city: String
    @NSManaged var state: String
    @NSManaged var zipCode: String
    
    // MARK: Convenience init
    convenience init(fromContactStruct contactStruct: ElevenContactStruct) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: App.contactEntityName, in: context) else {
            fatalError("Failed to decode Contact")
        }
        
        self.init(entity: entity, insertInto: context)
        
        if (contactStruct.contactId == "") {
            self.contactId = String(Int.random(in: 0 ..< 999999)) + contactStruct.firstName + String(Int.random(in: 0 ..< 999999))
        } else {
            self.contactId = contactStruct.contactId
        }
        
        self.firstName = contactStruct.firstName
        self.lastName = contactStruct.lastName
        self.phoneNumber = contactStruct.phoneNumber
        self.streetAddress1 = contactStruct.streetAddress1
        self.streetAddress2 = contactStruct.streetAddress2
        self.city = contactStruct.city
        self.state = contactStruct.state
        self.zipCode = contactStruct.zipCode
    }
    
    func getElevenContactStruct() -> ElevenContactStruct {
        return ElevenContactStruct(contactId: self.contactId,
                                   firstName: self.firstName,
                                   lastName: self.lastName,
                                   phoneNumber: self.phoneNumber,
                                   streetAddress1: self.streetAddress1,
                                   streetAddress2: self.streetAddress2,
                                   city: self.city,
                                   state: self.state,
                                   zipCode: self.zipCode)
    }
}

// MARK: Codable structs
public struct ContactListStruct: Codable {
    let contacts: [ElevenContactStruct]
    
    enum CodingKeys: String, CodingKey {
        case contacts
    }
}

public struct ElevenContactStruct: Codable {
    let contactId, firstName, lastName, phoneNumber, streetAddress1, streetAddress2, city, state, zipCode: String
    
    enum CodingKeys: String, CodingKey {
        case contactId = "contactID"
        case firstName
        case lastName
        case phoneNumber
        case streetAddress1
        case streetAddress2
        case city
        case state
        case zipCode
    }
}
