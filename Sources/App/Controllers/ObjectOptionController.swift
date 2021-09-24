//
//  ObjectOptionController.swift
//  
//
//  Created by Craig Grantham on 9/14/21.
//

import Vapor
import Fluent


struct ObjectOptionController: RouteCollection
{
	func boot(routes: RoutesBuilder) throws {
		
		let optionRoute = routes.grouped("api", "modeloption")
		optionRoute.get(use: getAllHandler)
		optionRoute.get(":optionID", use: getHandler)
		optionRoute.get("search", use: searchHandler)
		
		//		categoriesRoute.get(":categoryID", "acronyms", use: getAcronymsHandler)
		
		let tokenAuthMiddleware = Token.authenticator()
		let guardAuthMiddleware = User.guardMiddleware()
		let tokenAuthGroup = optionRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		tokenAuthGroup.post(use: createHandler)
		tokenAuthGroup.delete(":optionID", use: deleteHandler)
		tokenAuthGroup.put(":optionID", use: updateHandler)
	}
	
	func createHandler(_ req: Request) throws -> EventLoopFuture<ObjectOption> {
		let objOption = try req.content.decode(ObjectOption.self)
		return objOption.save(on: req.db).map { objOption }
	}
	
	func deleteHandler(_ req: Request)
	-> EventLoopFuture<HTTPStatus> {
		ObjectOption.find(req.parameters.get("optionID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { objOption in
				objOption.delete(on: req.db)
					.transform(to: .noContent)
			}
	}
	
	func updateHandler(_ req: Request) throws -> EventLoopFuture<ObjectOption> {
		let updateData = try req.content.decode(ObjectOptionData.self)
		
		return ObjectOption.find(req.parameters.get("optionID"), on: req.db)
			.unwrap(or: Abort(.notFound)).flatMap { objOption in
				
				objOption.objectOptionID = updateData.objectOptionID
				objOption.optionCategoryID = updateData.optionCategoryID
				objOption.optionDescription = updateData.optionDescription
				
				objOption.displayNdx = updateData.displayNdx
				objOption.optionImageID = updateData.optionImageID
				
				objOption.changeToken = updateData.changeToken
				return objOption.save(on: req.db).map {
					objOption
				}
			}
	}
	
	
	func getAllHandler(_ req: Request) -> EventLoopFuture<[ObjectOption]> {
		ObjectOption.query(on: req.db).all()
	}
	
	func getHandler(_ req: Request) -> EventLoopFuture<ObjectOption> {
		ObjectOption.find(req.parameters.get("optionID"), on: req.db).unwrap(or: Abort(.notFound))
	}
	
	func searchHandler(_ req: Request) throws -> EventLoopFuture<ObjectOption>
	{
		guard let searchTerm = req
				.query[String.self, at: "parm"] else {
			throw Abort(.badRequest)
		}
		
		return ObjectOption.query(on: req.db).group(.or) { or in
			or.filter(\.$optionDescription == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}
	
	/*
	func getAcronymsHandler(_ req: Request) -> EventLoopFuture<[Acronym]> {
	Category.find(req.parameters.get("categoryID"), on: req.db)
	.unwrap(or: Abort(.notFound))
	.flatMap { category in
	category.$acronyms.get(on: req.db)
	}
	}
	*/
	
}



struct ObjectOptionData: Content
{
	let objectOptionID: Int32
	let optionCategoryID: String
	let optionDescription: String
	
	let displayNdx: Int32
	
	let optionImageID: String?

	let changeToken: Int32
}
