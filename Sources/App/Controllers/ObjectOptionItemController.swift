//
//  ObjectOptionItemController.swift
//  
//
//  Created by Craig Grantham on 9/14/21.
//

import Vapor
import Fluent


struct ObjectOptionItemController: RouteCollection
{
	func boot(routes: RoutesBuilder) throws {
		
		let optionRoute = routes.grouped("api", "object-option")
		optionRoute.get(use: getAllHandler)
		optionRoute.get(":optionID", use: getHandler)
		optionRoute.get("search", use: searchHandler)
		optionRoute.get("objectOptionID", ":objectOptionID", use: getObjectOptionIDHandler)
		optionRoute.get("objectOptionFor", use: findObjectOptionHandler)

		//		categoriesRoute.get(":categoryID", "acronyms", use: getAcronymsHandler)
		
		let tokenAuthMiddleware = Token.authenticator()
		let guardAuthMiddleware = User.guardMiddleware()
		let tokenAuthGroup = optionRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		tokenAuthGroup.post(use: createHandler)
		tokenAuthGroup.delete(":optionID", use: deleteHandler)
		tokenAuthGroup.put(":optionID", use: updateHandler)
	}
	
	func createHandler(_ req: Request) throws -> EventLoopFuture<ObjectOptionItem> {
		let objOption = try req.content.decode(ObjectOptionItem.self)
		return objOption.save(on: req.db).map { objOption }
	}
	
	func deleteHandler(_ req: Request)
	-> EventLoopFuture<HTTPStatus> {
		ObjectOptionItem.find(req.parameters.get("optionID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { objOption in
				objOption.delete(on: req.db)
					.transform(to: .noContent)
			}
	}
	
	func updateHandler(_ req: Request) throws -> EventLoopFuture<ObjectOptionItem> {
		let updateData = try req.content.decode(ObjectOptionData.self)
		
		return ObjectOptionItem.find(req.parameters.get("optionID"), on: req.db)
			.unwrap(or: Abort(.notFound)).flatMap { objOption in
				
				objOption.objectOptionID = updateData.objectOptionID
				objOption.optionItemID = updateData.optionItemID
				objOption.optionCategoryID = updateData.optionCategoryID
				objOption.optionName = updateData.optionName
				
				objOption.siteObjectID = updateData.siteObjectID
				
				objOption.objectTemplateID = updateData.objectTemplateID
				
				objOption.changeToken = updateData.changeToken
				return objOption.save(on: req.db).map {
					objOption
				}
			}
	}
	
	
	func getAllHandler(_ req: Request) -> EventLoopFuture<[ObjectOptionItem]> {
		ObjectOptionItem.query(on: req.db).all()
	}
	
	func getHandler(_ req: Request) -> EventLoopFuture<ObjectOptionItem> {
		ObjectOptionItem.find(req.parameters.get("optionID"), on: req.db).unwrap(or: Abort(.notFound))
	}
	
	
	func searchHandler(_ req: Request) throws -> EventLoopFuture<ObjectOptionItem>
	{
		guard let searchTerm = req
				.query[String.self, at: "name"] else {
					throw Abort(.badRequest)
				}
		
		return ObjectOptionItem.query(on: req.db).group(.or) { or in
			or.filter(\.$optionName == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}
	
	
	func getObjectOptionIDHandler(_ req: Request) throws -> EventLoopFuture<ObjectOptionItem>
	{
		guard let searchTerm = req.parameters.get("objectOptionID") else {
			throw Abort(.badRequest)
		}
		
		return ObjectOptionItem.query(on: req.db).group(.or) { or in
			or.filter(\.$objectOptionID == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}
	
	
	
	func findObjectOptionHandler(_ req: Request) throws -> EventLoopFuture<[ObjectOptionItem]>
	{
		guard let objectID = req
				.query[String.self, at: "object"] else {
					throw Abort(.badRequest)
				}
		
		guard let optionID = req
				.query[String.self, at: "option"] else {
					throw Abort(.badRequest)
				}
		
		guard let categoryID = req
				.query[String.self, at: "category"] else {
					throw Abort(.badRequest)
				}

		return ObjectOptionItem.query(on: req.db).group(.and) { group in
			group.filter(\.$siteObjectID == objectID)
			group.filter(\.$optionCategoryID == categoryID)
			group.filter(\.$optionItemID == optionID)
		}.all()
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
	let objectOptionID: String
	
	let siteObjectID: String

	let optionItemID: String
	let optionName: String
	
	let optionCategoryID: String

	let objectTemplateID: String?

	let changeToken: Int32
}
