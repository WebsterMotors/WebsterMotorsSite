//
//  CreatePageMakerPivot.swift
//  
//
//  Created by Craig Grantham on 11/4/21.
//

import Fluent


struct CreatePageMakerPivot: Migration {
	
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		
		database.schema("page-maker-pivot")
		
			.id()
		
			.field("pageID", .uuid, .required,
				   .references("site-pages", "id", onDelete: .cascade))
			.field("makeID", .uuid, .required,
				   .references("makes", "id", onDelete: .cascade))
		
			.create()
	}
	
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("page-maker-pivot").delete()
	}
}
