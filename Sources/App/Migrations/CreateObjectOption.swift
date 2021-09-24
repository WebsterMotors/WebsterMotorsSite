//
//  CreateObjectOption.swift
//  
//
//  Created by Craig Grantham on 9/13/21.
//

import Fluent


struct CreateObjectOption: Migration {
	
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		
		database.schema("modeloptions")
			
			.id()
			
			.field("optionDescription", .string, .required)
			.field("objectOptionID", .int32, .required)
			.field("optionCategoryID", .string, .required)
			.field("displayNdx", .int32)
			.field("optionImageID", .string)
			.field("changeToken", .int32, .required)
			
			.create()
	}
	
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("modeloptions").delete()
	}
}
