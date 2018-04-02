//
//  DBContacts.swift
//  SQLite Swift
//
//  Created by Marcos Torres on 3/30/18.
//  Copyright © 2018 HSoft Mobile. All rights reserved.
//

import Foundation
import SQLite

class DBContactData {
	var rowId: Int64
	var name: String
	var email: String
	var age: Int64
	
	init() {
		rowId = 0
		name = ""
		email = ""
		age = 0
	}
}

struct DBContactSchema {
	static let table = Table(TableNames.Contacts)
	static let rowId = Expression<Int64>(primaryColumnName)
	static let name = Expression<String>("name")
	static let email = Expression<String>("email")
	static let age = Expression<Int64>("age")
}

extension DBManager {
	
	/**
	Create the table Contacts with columns and indexes
	*/
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
		guard completeTable(TableNames.Contacts, withColumns: columns) else {
			print("Error completing table: " + TableNames.Contacts)
			return false
		}
		// add indexes
		if !addIndexToTable(table, forColumn: name) {
			print("Error adding index for column \(name.name) to table " + TableNames.Contacts)
		}
		return true
	}
	
	/**
	Get all Contacts
	*/
	func getAllContacts() -> [DBContactData] {
		var contacts = [DBContactData]()
		for row in try! db.prepare(DBContactSchema.table) {
			let contact = DBContactData()
			contact.rowId = row[DBContactSchema.rowId]
			contact.name = row[DBContactSchema.name]
			contact.email = row[DBContactSchema.email]
			contact.age = row[DBContactSchema.age]
			contacts.append(contact)
		}
		return contacts
	}
	
	func getContact(byId rowId: Int64) -> DBContactData {
		var contact: DBContactData!
		for row in try! db.prepare(DBContactSchema.table.filter(DBContactSchema.rowId == rowId).limit(1)) {
			contact = DBContactData()
			contact.rowId = row[DBContactSchema.rowId]
			contact.name = row[DBContactSchema.name]
			contact.email = row[DBContactSchema.email]
			contact.age = row[DBContactSchema.age]
		}
		return contact
	}
	
	func saveContact(_ contact: DBContactData) -> Int64 {
		if contact.rowId == 0 {
			// insert
			let insert = DBContactSchema.table.insert(
				DBContactSchema.name <- contact.name,
				DBContactSchema.email <- contact.email,
				DBContactSchema.age <- contact.age
			)
			return try! db.run(insert)
		} else {
			// update
			let update = DBContactSchema.table.where(DBContactSchema.rowId == contact.rowId).update(
				DBContactSchema.name <- contact.name,
				DBContactSchema.email <- contact.email,
				DBContactSchema.age <- contact.age
			)
			try! db.run(update)
			return (db.changes > 0) ? contact.rowId : 0
		}
	}
	
	func deleteContact(byId rowId: Int64) -> Bool {
		let delete = DBContactSchema.table.where(DBContactSchema.rowId == rowId).delete()
		try! db.run(delete)
		return db.changes > 0
	}
}
