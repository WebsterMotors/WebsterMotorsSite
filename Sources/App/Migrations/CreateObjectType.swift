//
//  CreateObjectType.swift
//  
//
//  Created by Craig Grantham on 9/14/21.
//

import Fluent


struct CreateObjectType: Migration {
	
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		
		database.schema("objecttypes")
			
			.id()
			
			.field("name", .string, .required)
			.field("objectTypeID", .string, .required)
			.field("changeToken", .int32, .required)

			.unique(on: "objectTypeID")

			.create()
	}
	
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("objecttypes").delete()
	}
}
