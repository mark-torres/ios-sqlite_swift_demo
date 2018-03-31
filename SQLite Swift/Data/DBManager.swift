//
//  DBManager.swift
//  SQLite Swift
//
//  Created by Marcos Torres on 3/30/18.
//  Copyright © 2018 HSoft Mobile. All rights reserved.
//

import Foundation
import SQLite

struct TableNames {
	static let Contacts = "contacts"
}

class DBManager {
	
	var db: Connection
	
	enum ColumnType {
		case integer
		case text
		case real
	}
	
	struct ColumnDefinition {
		var name: String
		var type: ColumnType
		
		init(_ name: String, _ type: ColumnType) {
			self.name = name
			self.type = type
		}
	}
	
	init(dbPath path: String) {
		db = try! Connection(path)
	}
	
	/**
	This function creates a table with the primary column only
	*/
	func initTable(_ table: Table) -> Bool {
		let rowId = Expression<Int64>("row_id")
		do {
			try db.run(table.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (tb) in
				tb.column(rowId, primaryKey: PrimaryKey.autoincrement)
			}) )
		} catch (let error) {
			print(error.localizedDescription)
			return false
		}
		return true
	}
	
	/**
	This function adds columns to a table
	*/
	func completeTable(_ table: Table, withColumns columns: [ColumnDefinition]) -> Bool {
		var query = ""
		for col in columns {
			switch col.type {
			case ColumnType.integer:
				let c = Expression<Int64>(col.name)
				query = table.addColumn(c, defaultValue: 0)
				break
			case ColumnType.real:
				let c = Expression<Double>(col.name)
				query = table.addColumn(c, defaultValue: 0.0)
				break
			default:
				let c = Expression<String>(col.name)
				query = table.addColumn(c, defaultValue: " ")
			}
			do {
				try db.run(query)
			} catch (let error) {
				print(error.localizedDescription)
			}
		}
		return true
	}
	
	/**
	This function adds an index to a table
	*/
	func addIndexToTable(_ table: Table, forColumn column: ColumnDefinition) -> Bool {
		var query = ""
		switch column.type {
		case ColumnType.integer:
			let col = Expression<Int64>(column.name)
			query = table.createIndex(col, unique: false, ifNotExists: true)
		case ColumnType.real:
			let col = Expression<Double>(column.name)
			query = table.createIndex(col, unique: false, ifNotExists: true)
		default:
			let col = Expression<String>(column.name)
			query = table.createIndex(col, unique: false, ifNotExists: true)
		}
		do {
			try db.run(query)
		} catch (let error) {
			print(error.localizedDescription)
			return false
		}
		return true
	}
}
