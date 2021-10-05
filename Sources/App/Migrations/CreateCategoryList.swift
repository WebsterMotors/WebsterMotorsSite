//
//  CreateCategoryList.swift
//  
//
//  Created by Craig Grantham on 9/27/21.
//

import Fluent

struct CreateCategoryList: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("categorylists")
			.id()
		
			.field("optionCategoryID", .string, .required)
			.field("categoryName", .string, .required)
			.field("siteObjectID", .string, .required)
			.field("categoryListID", .string, .required)
			.field("itemsList", .string, .required)
		
			.field("displayNdx", .int32)

			.unique(on: "categoryListID")
		
			.create()
	}
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("categorylists").delete()
	}
}
