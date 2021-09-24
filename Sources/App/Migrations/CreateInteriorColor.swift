//
//  CreateInteriorColor.swift
//  
//
//  Created by Craig Grantham on 8/30/21.
//

import Fluent


struct CreateInteriorColor: Migration {
	
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		
		database.schema("interiorcolors")
			
			.id()
			
			.field("name", .string, .required)
			.field("interiorColorID", .string, .required)
			.field("changeToken", .int32, .required)
			
			.field("optionImageID", .string)

			.unique(on: "interiorColorID")

			.create()
	}
	
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("interiorcolors").delete()
	}
}
