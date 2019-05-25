//
//  Contact.swift
//  Eleven Contacts
//
//  Created by Fabio Luiz on 24/05/19.
//  Copyright © 2019 Jobsity. All rights reserved.
//

import Foundation

class ElevenContact: Codable {
    var contactId: String
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var streetAddress1: String
    var streetAddress2: String
    var city: String
    var state: String
    var zipCode: String
    
    init(id: String, firstName: String, lastName: String, phoneNumber: String, streetAddress1: String, streetAddress2: String, city: String, state: String, zipCode: String) {
        self.contactId = id
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.streetAddress1 = streetAddress1
        self.streetAddress2 = streetAddress2
        self.city = city
        self.state = state
        self.zipCode = zipCode
    }
}
