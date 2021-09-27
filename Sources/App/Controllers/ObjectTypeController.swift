//
//  ObjectTypeController.swift
//  
//
//  Created by Craig Grantham on 9/14/21.
//

import Vapor
import Fluent


struct ObjectTypeController: RouteCollection
{
	func boot(routes: RoutesBuilder) throws {
		
		let mfgRoute = routes.grouped("api", "object-type")
		mfgRoute.get(use: getAllHandler)
		mfgRoute.get(":typeID", "", use: getHandler)
		mfgRoute.get("objectTypeID", ":objectTypeID", use: getObjectTypeIDHandler)
		mfgRoute.get("search", use: searchHandler)
		
		//		categoriesRoute.get(":categoryID", "acronyms", use: getAcronymsHandler)
		
		let tokenAuthMiddleware = Token.authenticator()
		let guardAuthMiddleware = User.guardMiddleware()
		let tokenAuthGroup = mfgRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		tokenAuthGroup.post(use: createHandler)
		tokenAuthGroup.delete(":typeID", use: deleteHandler)
		tokenAuthGroup.put(":typeID", use: updateHandler)
	}
	
	func createHandler(_ req: Request) throws -> EventLoopFuture<ObjectType> {
		let objType = try req.content.decode(ObjectType.self)
		return objType.save(on: req.db).map { objType }
	}
	
	func deleteHandler(_ req: Request)
	-> EventLoopFuture<HTTPStatus> {
		ObjectType.find(req.parameters.get("typeID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { objType in
				objType.delete(on: req.db)
					.transform(to: .noContent)
			}
	}
	
	func updateHandler(_ req: Request) throws -> EventLoopFuture<ObjectType> {
		let updateData = try req.content.decode(ObjectTypeData.self)
		
		return ObjectType.find(req.parameters.get("typeID"), on: req.db)
			.unwrap(or: Abort(.notFound)).flatMap { objType in
				objType.objectTypeID = updateData.objectTypeID
				objType.name = updateData.name
				objType.changeToken = updateData.changeToken
				return objType.save(on: req.db).map {
					objType
				}
			}
	}
	
	
	func getAllHandler(_ req: Request) -> EventLoopFuture<[ObjectType]> {
		ObjectType.query(on: req.db).all()
	}
	
	func getHandler(_ req: Request) -> EventLoopFuture<ObjectType> {
		ObjectType.find(req.parameters.get("typeID"), on: req.db).unwrap(or: Abort(.notFound))
	}
	
	
	func getObjectTypeIDHandler(_ req: Request) throws -> EventLoopFuture<ObjectType>
	{
		guard let searchTerm = req.parameters.get("objectTypeID") else {
			throw Abort(.badRequest)
		}
		
		return ObjectType.query(on: req.db).group(.or) { or in
			or.filter(\.$objectTypeID == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}

	
	func searchHandler(_ req: Request) throws -> EventLoopFuture<ObjectType>
	{
		guard let searchTerm = req
				.query[String.self, at: "name"] else {
			throw Abort(.badRequest)
		}
		return ObjectType.query(on: req.db).group(.or) { or in
			or.filter(\.$name == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}
	
	
}


struct ObjectTypeData: Content
{
	let name: String
	let objectTypeID: String

	let changeToken: Int32
}
