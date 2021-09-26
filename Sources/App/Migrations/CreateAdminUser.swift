//
//  CreateAdminUser.swift
//
//
//  Created by Craig Grantham on 8/30/21.
//

import Fluent
import Vapor

struct CreateAdminUser: Migration
{
	func prepare(on database: Database) -> EventLoopFuture<Void>
	{
		let passwordHash: String
		
		guard let adminName = Environment.get("WMS_ADMIN_USER") else
		{
			fatalError("Failed to load initial username!")
		}
		
		guard let adminPassword = Environment.get("WMS_ADMIN_PASSWORD") else
		{
			fatalError("Failed to load initial user password!")
		}

		do
		{
			passwordHash = try Bcrypt.hash(adminPassword)
		}
		catch
		{
			return database.eventLoop.future(error: error)
		}
		
		let user = User(name: "Admin", username: adminName, password: passwordHash)
		
		user.isAdmin = true
		
		return user.save(on: database)
	}
	
	func revert(on database: Database) -> EventLoopFuture<Void>
	{
		User.query(on: database).filter(\.$name == "Admin").delete()
	}
	
}
