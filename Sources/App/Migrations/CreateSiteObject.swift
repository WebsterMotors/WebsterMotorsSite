//
//  CreateSiteObject.swift
//  
//
//  Created by Craig Grantham on 9/14/21.
//

import Fluent


struct CreateSiteObject: Migration {
	
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		
		database.schema("siteobjects")
			
			.id()
			
			.field("siteObjectID", .string, .required)
			.field("webCatogoryID", .string, .required)
			.field("objectModelID", .string, .required)
			.field("objectTypeID", .string, .required)
			.field("makeID", .string, .required)
			.field("featureInfo", .string, .required)
			.field("vinNumber", .string)
			.field("modelYear", .int32)
			.field("numDoors", .int32)
			.field("mileage", .string)
			.field("listPrice", .string)
			.field("reducedPrice", .string)
			.field("objectDescription", .string)
			.field("hideListing", .bool, .required)
			.field("showInSpecials", .bool, .required)
			.field("exteriorColorID", .string)
			.field("interiorColorID", .string)
			.field("nextPhotoNdx", .int32)
			.field("changeToken", .int32, .required)
			.field("objectImages", .array(of: .string))
			.field("modelName", .string, .required)
			.field("typeName", .string, .required)
			.field("exteriorColor", .string)
			.field("interiorColor", .string)

			.unique(on: "siteObjectID")

			.create()
	}
	
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("siteobjects").delete()
	}
}
