//
//  CreateObjectOptionNdx.swift
//  
//
//  Created by Craig Grantham on 9/14/21.
//

import Fluent


struct CreateObjectOptionNdx: Migration {
	
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		
		database.schema("optionindexs")
			
			.id()
			
			.field("objectOptionID", .int32, .required)
			.field("siteObjectID", .string, .required)
			.field("objectOptionNdxID", .string, .required)
			.field("objectTemplateID", .string)
			.field("optionCategoryID", .string)
			.field("changeToken", .int32, .required)

			.unique(on: "objectOptionNdxID")

			.create()
	}
	
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("optionindexs").delete()
	}
}
