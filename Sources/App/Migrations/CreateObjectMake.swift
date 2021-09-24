//
//  CreateObjectManufacturer.swift
//  
//
//  Created by Craig Grantham on 9/13/21.
//

import Fluent


struct CreateObjectMake: Migration {
	
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		
		database.schema("makes")
			
			.id()
			
			.field("name", .string, .required)
			.field("makeID", .string, .required)
			.field("changeToken", .int32, .required)
			
			.field("pageName", .string)
			.field("logoImageURL", .string)
			.field("optionImageID", .string)
			.field("tagLine", .string)
			.field("makeSiteURL", .string)

			.unique(on: "makeID")

			.create()
	}
	
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("makes").delete()
	}
}
