//
//  CreateSiteObjectImage.swift
//  
//
//  Created by Craig Grantham on 9/14/21.
//

import Fluent


struct CreateSiteObjectImage: Migration {
	
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		
		database.schema("objectimages")
			
			.id()
			
			.field("siteObjectID", .string, .required)
			.field("siteObjectImageID", .string, .required)
			.field("photoNdx", .int32, .required)
			.field("fileName", .string, .required)
			
			.field("caption", .string)
			.field("awsBucketURL", .string)
			.field("awsKey", .string)

			.field("cloudServerID", .int32)
			
			.field("changeToken", .int32, .required)

			.unique(on: "siteObjectImageID")

			.create()
	}
	
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("objectimages").delete()
	}
}
