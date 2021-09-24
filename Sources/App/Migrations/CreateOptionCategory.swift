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
			.field("nextOptionID", .int32, .required)
			.field("displayNdx", .int32, .required)
			.field("changeToken", .int32, .required)
	
			.unique(on: "optionCategoryID")

			.create()
	}
	
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("optioncategories").delete()
	}
}
