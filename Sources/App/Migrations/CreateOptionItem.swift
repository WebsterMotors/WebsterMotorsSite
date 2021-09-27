//
//  CreateObjectOption.swift
//  
//
//  Created by Craig Grantham on 9/13/21.
//

import Fluent


struct CreateOptionItem: Migration {
	
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		
		database.schema("optionitems")
			
			.id()
			
			.field("optionName", .string, .required)
			.field("optionItemID", .string, .required)
			.field("optionCategoryID", .string, .required)

			.field("optionImageID", .string)
			.field("changeToken", .int32, .required)
			
			.unique(on: "optionItemID")
		
			.create()
	}
	
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("optionitems").delete()
	}
}
