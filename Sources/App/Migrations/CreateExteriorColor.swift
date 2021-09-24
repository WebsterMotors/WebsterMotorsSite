//
//  CreateExteriorColor.swift
//  
//
//  Created by Craig Grantham on 8/24/21.
//

import Fluent


struct CreateExteriorColor: Migration {

	func prepare(on database: Database) -> EventLoopFuture<Void> {

		database.schema("exteriorcolors")

			.id()

			.field("name", .string, .required)
			.field("exteriorColorID", .string, .required)
			.field("changeToken", .int32, .required)
			
			.field("optionImageID", .string)

			.unique(on: "exteriorColorID")

			.create()
	}
	

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("exteriorcolors").delete()
	}
}
