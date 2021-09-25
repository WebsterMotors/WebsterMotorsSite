//
//  CreateToken.swift
//
//
//  Created by Craig Grantham on 8/30/21.
//

import Fluent

struct CreateToken: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema("tokens")
      .id()
      .field("value", .string, .required)
		.field("userUUID", .string, .required)
      .field("userID", .uuid, .required, .references("users", "id", onDelete: .cascade))
      .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("tokens").delete()
  }
}
