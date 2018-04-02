//
//  ContactsViewController.swift
//  SQLite Swift
//
//  Created by Marcos Torres on 3/30/18.
//  Copyright © 2018 HSoft Mobile. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var contactsTableView: UITableView!
	
	var contacts: [DBContactData]!
	var selectedContactId: Int64!
	var userDefaults: UserDefaults!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		let appVersionKey = "app_version_name"
		userDefaults = UserDefaults.standard
		let savedVersion = userDefaults.string(forKey: appVersionKey) ?? ""
		let currentVersion = HSUtils.getAppVersionName()
		if currentVersion != savedVersion {
			dbManager.createContactsTable()
			userDefaults.set(currentVersion, forKey: appVersionKey)
		}
		
		contactsTableView.delegate = self
		contactsTableView.dataSource = self

		contacts = []
		selectedContactId = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		contacts = dbManager.getAllContacts()
		contactsTableView.reloadData()
	}
	
	// MARK: - Navigation
	
	@IBAction func unwindToContacts(_ segue: UIStoryboardSegue) {
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let target = segue.destination as? ContactFormViewController {
			target.contactId = selectedContactId
		}
	}

	// MARK: - IB Actions
	
	@IBAction func tapAddContact(_ sender: Any) {
		selectedContactId = 0
		performSegue(withIdentifier: "showContactForm", sender: self)
	}
	
	// MARK: - Table view
	
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		selectedContactId = contacts[indexPath.row].rowId
		return indexPath
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "showContactForm", sender: self)
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			if dbManager.deleteContact(byId: contacts[indexPath.row].rowId) {
				contacts.remove(at: indexPath.row)
				tableView.deleteRows(at: [indexPath], with: .fade)
			}
		}
	}
	
	// MARK: - Table view data source
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contacts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
		
		let contact = contacts[indexPath.row]
		
		cell.textLabel?.text = contact.name
		cell.detailTextLabel?.text = contact.email
		
		return cell
	}
}
