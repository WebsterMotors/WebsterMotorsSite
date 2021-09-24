//
//  CreateSiteAdminGlobal.swift
//  
//
//  Created by Craig Grantham on 9/14/21.
//

import Fluent


struct CreateSiteAdminGlobal: Migration {
	
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		
		database.schema("appglobals")
			
			.id()
			
			.field("appID", .string, .required)
			.field("lastExteriorColorID", .int32, .required)
			.field("lastInteriorColorID", .int32, .required)
			.field("lastMakeID", .int32, .required)
			.field("lastObjectModelID", .int32, .required)
			.field("lastObjectOptionID", .int32, .required)
			.field("lastOptionImageID", .int32, .required)
			.field("lastObjectOptionNdxID", .int32, .required)
			.field("lastObjectTemplateID", .int32, .required)
			.field("lastObjectTypeID", .int32, .required)
			.field("lastSiteObjectID", .int32, .required)
			.field("lastSiteObjectImageID", .int32, .required)
			.field("lastOptionCategoryID", .int32, .required)
			.field("lastWebCatogoryID", .int32, .required)
			.field("changeToken", .int32, .required)
			
			.create()
	}
	
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("appglobals").delete()
	}
}
