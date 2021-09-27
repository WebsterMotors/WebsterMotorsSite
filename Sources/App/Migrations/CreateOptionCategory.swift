//
//  CreateOptionCategory.swift
//  
//
//  Created by Craig Grantham on 9/14/21.
//

import Fluent


struct CreateOptionCategory: Migration {
	
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		
		database.schema("optioncategories")
			
			.id()
			
			.field("categoryName", .string, .required)
			.field("optionCategoryID", .string, .required)
			.field("displayNdx", .int32, .required)
			.field("changeToken", .int32, .required)
	
			.field("nextDisplayNdx", .int32)

			.unique(on: "optionCategoryID")

			.create()
	}
	
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("optioncategories").delete()
	}
}
