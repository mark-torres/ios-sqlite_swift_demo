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

struct DBContactsSchema {
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
		guard let rows = try? db.prepare(DBContactsSchema.table) else {
			print("getAllContacts: Error getting data from table: " + TableNames.Contacts)
			return contacts
		}
		for row in rows {
			let contact = DBContactData()
			contact.rowId = row[DBContactsSchema.rowId]
			contact.name = row[DBContactsSchema.name]
			contact.email = row[DBContactsSchema.email]
			contact.age = row[DBContactsSchema.age]
			contacts.append(contact)
		}
		return contacts
	}
	
	func getContact(byId rowId: Int64) -> DBContactData {
		var contact = DBContactData()
		guard let rows = try? db.prepare(DBContactsSchema.table.filter(DBContactsSchema.rowId == rowId).limit(1)) else {
			print("getContact: Error getting data from table: " + TableNames.Contacts)
			return contact
		}
		for row in rows {
			contact.rowId = row[DBContactsSchema.rowId]
			contact.name = row[DBContactsSchema.name]
			contact.email = row[DBContactsSchema.email]
			contact.age = row[DBContactsSchema.age]
		}
		return contact
	}
	
	func saveContact(_ contact: DBContactData) -> Int64 {
		if contact.rowId == 0 {
			// insert
			let insert = DBContactsSchema.table.insert(
				DBContactsSchema.name <- contact.name,
				DBContactsSchema.email <- contact.email,
				DBContactsSchema.age <- contact.age
			)
			guard let newRowId = try? db.run(insert) else {
				print("saveContact: Error inserting row")
				return 0
			}
			return newRowId
		} else {
			// update
			let update = DBContactsSchema.table.where(DBContactsSchema.rowId == contact.rowId).update(
				DBContactsSchema.name <- contact.name,
				DBContactsSchema.email <- contact.email,
				DBContactsSchema.age <- contact.age
			)
			guard let updatedRows = try? db.run(update) else {
				print("saveContact: Error updating row")
				return 0
			}
			return (updatedRows > 0) ? contact.rowId : 0
		}
	}
	
	func deleteContact(byId rowId: Int64) -> Bool {
		let delete = DBContactsSchema.table.where(DBContactsSchema.rowId == rowId).delete()
		guard let deletedRows = try? db.run(delete) else {
			print("deleteContact: Error deleting row")
			return false
		}
		return deletedRows > 0
	}
}
