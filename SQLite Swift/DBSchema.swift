//
//  DBSchema.swift
//  SQLite Swift
//
//  Created by Marcos Torres on 3/26/18.
//  Copyright © 2018 HSoft Mobile. All rights reserved.
//

import Foundation

// table names
struct DBTables {
	static let Users = "users"
}

// table columns names
struct UsersSchema {
	static let name = "name"
	static let age = "age"
}

struct TableColumnDefinition {
	var name: String
	var type: String
	var indexed: Bool
	var primary: Bool
	
	init() {
		name = ""
		type = ""
		indexed = false
		primary = false
	}
}

// data model class
class UserData {
	var rowId: Int64
	var name: String
	var age: Int
	var weight: Double
	
	init() {
		rowId = 0
		name = ""
		age = 0
		weight = 0
	}
}
