//
//  ViewController.swift
//  Eleven Contacts
//
//  Created by Fabio Luiz on 23/05/19.
//  Copyright © 2019 Jobsity. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var contacts: [ElevenContact] = []
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "contactCell")
        
        viewModel.delegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        viewModel.retireveContacts(context: context)
    }

    @IBAction func addContact(_ sender: Any) {
    }
    
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let contact = contacts[indexPath.row] as ElevenContact
        cell.textLabel?.text = contact.firstName
        return cell
    }
}

extension ViewController: ViewModelDelegate {
    func didUpdateState() {
        switch viewModel.state {
        case .idle:
            contacts = viewModel.contacts!
        case .working:
            print("Interacting with Core Data")
            // trigger activity widget
        }
    }
}

