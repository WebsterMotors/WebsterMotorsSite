//
//  CreateWebsiteCategory.swift
//  
//
//  Created by Craig Grantham on 8/31/21.
//

import Fluent

struct CreateWebsiteCategory: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("sitecategory")
			.id()
			
			.field("navButtonName", .string, .required)
			.field("headerDescription", .string, .required)
			.field("webCatogoryID", .string, .required)
			.field("webCategoryName", .string)
			.field("navigationOrderNdx", .int32, .required)
			.field("showCategory", .bool, .required)
			.field("changeToken", .int32, .required)

			.unique(on: "webCatogoryID")

			.create()
	}
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("sitecategory").delete()
	}
}
