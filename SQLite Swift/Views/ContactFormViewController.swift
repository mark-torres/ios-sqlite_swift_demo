//
//  ContactFormViewController.swift
//  SQLite Swift
//
//  Created by Marcos Torres on 4/2/18.
//  Copyright © 2018 HSoft Mobile. All rights reserved.
//

import UIKit

class ContactFormViewController: UITableViewController, UITextFieldDelegate {
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var ageTextField: UITextField!
	
	@IBOutlet weak var errorLabel: UILabel!
	
	@IBOutlet weak var contactsNavigationItem: UINavigationItem!
	
	var contactId: Int64 = 0
	
	var contactData: DBContactData!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		contactData = DBContactData()
		// Set title
		contactsNavigationItem.title = "New contact"
		if contactId > 0 {
			contactsNavigationItem.title = "Edit contact"
			// load contact information
			contactData = dbManager.getContact(byId: contactId)
			if contactData == nil {
				print("Error getting contact data")
				contactData = DBContactData()
			}
		}
		
		nameTextField.delegate = self
		emailTextField.delegate = self
		ageTextField.delegate = self
		
		nameTextField.text = contactData.name
		emailTextField.text = contactData.email
		ageTextField.text = (contactData.age > 0) ? String(contactData.age) : ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - Text field delegate
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		if textField == nameTextField {
			emailTextField.becomeFirstResponder()
		} else if textField == emailTextField {
			ageTextField.becomeFirstResponder()
		}
		return false
	}
	
	// MARK: - IB Actions
	
	@IBAction func tapSaveContact(_ sender: Any) {
		contactData.name = nameTextField.text ?? ""
		contactData.email = emailTextField.text ?? ""
		contactData.age = Int64(ageTextField.text ?? "0") ?? 0
		if dbManager.saveContact(contactData) == 0 {
			print("Error saving contact")
		} else {
			performSegue(withIdentifier: "unwindToContacts", sender: self)
		}
	}
	
}
