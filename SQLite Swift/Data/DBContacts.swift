//
//  DBContacts.swift
//  SQLite Swift
//
//  Created by Marcos Torres on 3/30/18.
//  Copyright © 2018 HSoft Mobile. All rights reserved.
//

import Foundation
import SQLite

extension DBManager {
	
	func createContactsTable() -> Bool {
		let table = Table(TableNames.Contacts)
		// create table
		guard initTable(table) else {
			print("Error creating table: " + TableNames.Contacts)
			return false
		}
		let name = ColumnDefinition("name", .text)
		let email = ColumnDefinition("email", .text)
		let age = ColumnDefinition("age", .integer)
		let columns: [ColumnDefinition] = [
			name,
			email,
			age
		]
		// complete table
		guard completeTable(table, withColumns: columns) else {
			print("Error completing table: " + TableNames.Contacts)
			return false
		}
		// add indexes
		if !addIndexToTable(table, forColumn: name) {
			print("Error adding index for column \(name.name) to table " + TableNames.Contacts)
		}
		return true
	}
	
}
