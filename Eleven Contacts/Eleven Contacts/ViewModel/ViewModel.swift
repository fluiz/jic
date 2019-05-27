//
//  ViewModel.swift
//  Eleven Contacts
//
//  Created by Fabio Luiz on 27/05/19.
//  Copyright © 2019 Jobsity. All rights reserved.
//

import Foundation
import CoreData

enum ViewModelState: Equatable {
    case working
    case idle
}

protocol ViewModelDelegate: class {
    func didUpdateState()
}

class ViewModel {
    weak var delegate: ViewModelDelegate?
    
    var contacts: [ElevenContact]?
    
    var state: ViewModelState = .idle {
        didSet {
            delegate?.didUpdateState()
        }
    }
    
    func retireveContacts(context: NSManagedObjectContext) {
        state = .working
        ContactsDB.setup(context: context)
        let contactsDB = ContactsDB.shared
        contactsDB.retrieveContacts({ [weak self] contacts in
            self?.contacts = contacts
            self?.state = .idle
            }, failure: { error in
                print("Core Data Error: \(error.debugDescription)")
        })
    }
    
    func upsertContact(context: NSManagedObjectContext, contact: ElevenContact) {
        state = .working
        ContactsDB.setup(context: context)
        let contactsDB = ContactsDB.shared
        contactsDB.createOrUpdate(contactStruct: contact.getElevenContactStruct())
        state = .idle
    }
}