//
//  CreateObjectModel.swift
//  
//
//  Created by Craig Grantham on 9/13/21.
//

import Fluent


struct CreateObjectModel: Migration {
	
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		
		database.schema("sitemodels")
			
			.id()
			
			.field("name", .string, .required)
			.field("objectModelID", .string, .required)
			.field("makeID", .string, .required)
			.field("changeToken", .int32, .required)

			.unique(on: "objectModelID")

			.create()
	}
	
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("sitemodels").delete()
	}
}
