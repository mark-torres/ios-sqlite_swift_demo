//
//  HSUtils.swift
//  SQLite Swift
//
//  Created by Marcos Torres on 3/30/18.
//  Copyright © 2018 HSoft Mobile. All rights reserved.
//

import Foundation

class HSUtils {
	
	/**
	This functions returns the path to the *Documents* directory
	*/
	static func getDocumentsPath() -> String {
		var docsPath:String!
		let urls = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
		if urls.count > 0 {
			docsPath = urls.first!.path
		}
		return docsPath
	}
	
	static func getAppVersionName() -> String {
		let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "V"
		let build = Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? "B"
		return version + "_" + build
	}
}
