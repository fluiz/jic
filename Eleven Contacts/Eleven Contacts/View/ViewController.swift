//
//  ViewController.swift
//  Eleven Contacts
//
//  Created by Fabio Luiz on 23/05/19.
//  Copyright © 2019 Jobsity. All rights reserved.
//

import UIKit

// MARK: ViewController for TableView
class ViewController: UITableViewController {

    var contacts: [ElevenContact] = []
    var viewModel = ViewModel()
    
    // MARK: UITableViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        navigationItem.leftBarButtonItem = editButtonItem
        
        viewModel.delegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        viewModel.retireveContacts(context: context)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let contact = contacts[indexPath.row] as ElevenContact
        cell.textLabel?.text = "\(contact.firstName) \(contact.lastName)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let deleteContact = contacts[indexPath.row] as ElevenContact
            viewModel.delete(context: context, contactId: deleteContact.contactId)
            contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            viewModel.retireveContacts(context: context)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // MARK: Actions
    @IBAction func addContact(_ sender: Any) {
    }
    
    // MARK: Navigation
    @IBAction func unwindToContactsList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddContactDetailsViewController, let contact = sourceViewController.contact {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            viewModel.upsertContact(context: context, contact: contact)
            viewModel.retireveContacts(context: context)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "AddContact":
            Log.d(message: "Adding a new contact")
        case "ShowDetail":
            guard let contactDetailViewController = segue.destination as? AddContactDetailsViewController else {
                fatalError("Unexpected detination: \(segue.destination)")
            }
            guard let selectedContactCell = sender as? UITableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedContactCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedContact = contacts[indexPath.row]
            contactDetailViewController.contact = selectedContact.getElevenContactStruct()
        default:
            fatalError("Unexpected segue identifier: \(String(describing: segue.identifier))")
        }
    }
}

// MARK: ViewController Extentions
extension ViewController: ViewModelDelegate {
    func didUpdateState() {
        switch viewModel.state {
        case .idle:
            contacts = viewModel.contacts!
            tableView.reloadData()
        case .working:
            print("Interacting with Core Data")
            // trigger activity widget
        }
    }
}

