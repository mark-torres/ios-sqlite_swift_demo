//
//  ViewController.swift
//  SQLite Swift
//
//  Created by Marcos Torres on 3/26/18.
//  Copyright © 2018 HSoft Mobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		dbManager.createContactsTable()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

