//
//  CreatePageObjectPivot.swift
//  
//
//  Created by Craig Grantham on 11/4/21.
//

import Fluent


struct CreatePageObjectPivot: Migration {

	func prepare(on database: Database) -> EventLoopFuture<Void> {

		database.schema("page-object-pivot")

			.id()

			.field("pageID", .uuid, .required,
				   .references("site-pages", "id", onDelete: .cascade))
			.field("objectID", .uuid, .required,
				   .references("siteobjects", "id", onDelete: .cascade))
		
			.create()
	}
	

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("page-object-pivot").delete()
	}
}
