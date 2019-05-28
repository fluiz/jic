//
//  ContactDetailsViewController.swift
//  Eleven Contacts
//
//  Created by Fabio Luiz on 27/05/19.
//  Copyright © 2019 Jobsity. All rights reserved.
//

import Foundation
import UIKit

class AddContactDetailsViewController: UIViewController {
    
    // MARK: Properties
    public var contact: ElevenContactStruct?
    private var contactId: String?
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var address1: UITextField!
    @IBOutlet weak var address2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zip: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let contact = contact {
            contactId = contact.contactId
            name.text = contact.firstName
            lastName.text = contact.lastName
            phone.text = contact.phoneNumber
            address1.text = contact.streetAddress1
            address2.text = contact.streetAddress2
            city.text = contact.city
            state.text = contact.state
            zip.text = contact.zipCode
        }
    }
    
    // MARK: Actions
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindContactSaveSegue", sender: self)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddContactMode = presentingViewController is UINavigationController
        if (isPresentingInAddContactMode) {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem else {
            return
        }
        
        let newContact = ElevenContactStruct(contactId: contactId ?? "",
                                             firstName: name.text ?? "",
                                             lastName: lastName.text ?? "",
                                             phoneNumber: phone.text ?? "",
                                             streetAddress1: address1.text ?? "",
                                             streetAddress2: address2.text ?? "",
                                             city: city.text ?? "",
                                             state: state.text ?? "",
                                             zipCode: zip.text ?? "")
        contact = newContact
    }
}
