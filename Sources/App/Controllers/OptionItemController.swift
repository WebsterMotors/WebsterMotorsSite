//
//  OptionItemController.swift
//  
//
//  Created by Craig Grantham on 9/14/21.
//

import Vapor
import Fluent


struct OptionItemController: RouteCollection
{
	func boot(routes: RoutesBuilder) throws {
		
		let optionRoute = routes.grouped("api", "option-item")
		optionRoute.get(use: getAllHandler)
		optionRoute.get(":optionID", use: getHandler)
		optionRoute.get("search", use: searchHandler)
		optionRoute.get("optionItemID", ":optionItemID", use: getOptionItemIDHandler)

		//		categoriesRoute.get(":categoryID", "acronyms", use: getAcronymsHandler)
		
		let tokenAuthMiddleware = Token.authenticator()
		let guardAuthMiddleware = User.guardMiddleware()
		let tokenAuthGroup = optionRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		tokenAuthGroup.post(use: createHandler)
		tokenAuthGroup.delete(":optionID", use: deleteHandler)
		tokenAuthGroup.put(":optionID", use: updateHandler)
	}
	
	func createHandler(_ req: Request) throws -> EventLoopFuture<OptionItem> {
		let objOption = try req.content.decode(OptionItem.self)
		return objOption.save(on: req.db).map { objOption }
	}
	
	func deleteHandler(_ req: Request)
	-> EventLoopFuture<HTTPStatus> {
		OptionItem.find(req.parameters.get("optionID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { objOption in
				objOption.delete(on: req.db)
					.transform(to: .noContent)
			}
	}
	
	func updateHandler(_ req: Request) throws -> EventLoopFuture<OptionItem> {
		let updateData = try req.content.decode(OptionItemData.self)
		
		return OptionItem.find(req.parameters.get("optionID"), on: req.db)
			.unwrap(or: Abort(.notFound)).flatMap { objOption in
				
				objOption.optionItemID = updateData.optionItemID
				objOption.optionCategoryID = updateData.optionCategoryID
				objOption.optionName = updateData.optionName
				
				objOption.optionImageID = updateData.optionImageID
				
				objOption.changeToken = updateData.changeToken
				return objOption.save(on: req.db).map {
					objOption
				}
			}
	}
	
	
	func getAllHandler(_ req: Request) -> EventLoopFuture<[OptionItem]> {
		OptionItem.query(on: req.db).all()
	}
	
	func getHandler(_ req: Request) -> EventLoopFuture<OptionItem> {
		OptionItem.find(req.parameters.get("optionID"), on: req.db).unwrap(or: Abort(.notFound))
	}
	
	func searchHandler(_ req: Request) throws -> EventLoopFuture<OptionItem>
	{
		guard let searchTerm = req
				.query[String.self, at: "name"] else {
			throw Abort(.badRequest)
		}
		
		return OptionItem.query(on: req.db).group(.or) { or in
			or.filter(\.$optionName == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}
	
	
	func getOptionItemIDHandler(_ req: Request) throws -> EventLoopFuture<OptionItem>
	{
		guard let searchTerm = req.parameters.get("optionItemID") else {
			throw Abort(.badRequest)
		}
		
		return OptionItem.query(on: req.db).group(.or) { or in
			or.filter(\.$optionItemID == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}

}



struct OptionItemData: Content
{
	let optionItemID: String
	let optionCategoryID: String
	let optionName: String
	
	let optionImageID: String?

	let changeToken: Int32
}
