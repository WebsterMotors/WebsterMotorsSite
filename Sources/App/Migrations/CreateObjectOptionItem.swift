//
//  CreateObjectOptionItem.swift
//  
//
//  Created by Craig Grantham on 9/14/21.
//

import Fluent


struct CreateObjectOptionItem: Migration {
	
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		
		database.schema("objectoptions")
			
			.id()
			
			.field("objectOptionID", .string, .required)
			.field("optionItemID", .string, .required)
			.field("siteObjectID", .string, .required)
			.field("optionName", .string, .required)
			.field("optionCategoryID", .string, .required)
		
			.field("objectTemplateID", .string)
			.field("changeToken", .int32, .required)

			.unique(on: "objectOptionID")

			.create()
	}
	
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("objectoptions").delete()
	}
}
