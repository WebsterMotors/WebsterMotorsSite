//
//  ObjectOptionNdxController.swift
//  
//
//  Created by Craig Grantham on 9/14/21.
//

import Vapor
import Fluent


struct ObjectOptionNdxController: RouteCollection
{
	func boot(routes: RoutesBuilder) throws {
		
		let optionRoute = routes.grouped("api", "optionndx")
		optionRoute.get(use: getAllHandler)
		optionRoute.get(":optionNdxID", use: getHandler)
//		optionRoute.get("search", use: searchHandler)
		
		//		categoriesRoute.get(":categoryID", "acronyms", use: getAcronymsHandler)
		
		let tokenAuthMiddleware = Token.authenticator()
		let guardAuthMiddleware = User.guardMiddleware()
		let tokenAuthGroup = optionRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		tokenAuthGroup.post(use: createHandler)
		tokenAuthGroup.delete(":optionNdxID", use: deleteHandler)
		tokenAuthGroup.put(":optionNdxID", use: updateHandler)
	}
	
	func createHandler(_ req: Request) throws -> EventLoopFuture<ObjectOptionNdx> {
		let objOption = try req.content.decode(ObjectOptionNdx.self)
		return objOption.save(on: req.db).map { objOption }
	}
	
	func deleteHandler(_ req: Request)
	-> EventLoopFuture<HTTPStatus> {
		ObjectOptionNdx.find(req.parameters.get("optionNdxID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { objOption in
				objOption.delete(on: req.db)
					.transform(to: .noContent)
			}
	}
	
	func updateHandler(_ req: Request) throws -> EventLoopFuture<ObjectOptionNdx> {
		let updateData = try req.content.decode(OptionNdxData.self)
		
		return ObjectOptionNdx.find(req.parameters.get("optionNdxID"), on: req.db)
			.unwrap(or: Abort(.notFound)).flatMap { objOption in
				
				objOption.objectOptionID = updateData.objectOptionID
				objOption.optionCategoryID = updateData.optionCategoryID
				objOption.siteObjectID = updateData.siteObjectID
				
				objOption.objectOptionNdxID = updateData.objectOptionNdxID
				objOption.objectTemplateID = updateData.objectTemplateID
				
				objOption.changeToken = updateData.changeToken
				return objOption.save(on: req.db).map {
					objOption
				}
			}
	}
	
	
	func getAllHandler(_ req: Request) -> EventLoopFuture<[ObjectOptionNdx]> {
		ObjectOptionNdx.query(on: req.db).all()
	}
	
	func getHandler(_ req: Request) -> EventLoopFuture<ObjectOptionNdx> {
		ObjectOptionNdx.find(req.parameters.get("optionNdxID"), on: req.db).unwrap(or: Abort(.notFound))
	}
	
/*
	func searchHandler(_ req: Request) throws -> EventLoopFuture<ObjectOptionNdx>
	{
		guard let searchTerm = req
				.query[String.self, at: "objid"] else {
			throw Abort(.badRequest)
		}
		
		return ObjectOptionNdx.query(on: req.db).group(.or) { or in
			or.filter(\.$siteObjectID == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}
*/
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



struct OptionNdxData: Content
{
	let siteObjectID: String
	let objectOptionID: Int32
	let objectOptionNdxID: String
	
	let objectTemplateID: String?
	let optionCategoryID: String?

	let changeToken: Int32
}
