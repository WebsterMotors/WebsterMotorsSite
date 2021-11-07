//
//  CreateSitePage.swift
//  
//
//  Created by Craig Grantham on 11/4/21.
//

import Fluent


struct CreateSitePage: Migration {
	
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		
		database.schema("site-pages")
		
			.id()
		
			.field("pageTitle", .string, .required)
		
			.field("pageName", .string, .required)
		
			.field("pageID", .string, .required)
		
			.field("pageNavNames", .array(of: .string))

			.unique(on: "pageID")
		
			.create()
	}
	
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("site-pages").delete()
	}
}
