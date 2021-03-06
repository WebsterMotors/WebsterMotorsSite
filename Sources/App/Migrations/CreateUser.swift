//
//  CreateUser.swift
//
//
//  Created by Craig Grantham on 8/30/21.
//

import Fluent

struct CreateUser: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("users")
			.id()
			
			.field("name", .string, .required)
			.field("username", .string, .required)
			.field("password", .string, .required)
			.field("isAdmin", .bool, .required)
			
			.unique(on: "username")
			.create()
	}
	
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("users").delete()
  }
}
