//
//  OptionCategoryController.swift
//  
//
//  Created by Craig Grantham on 9/14/21.
//

import Vapor
import Fluent


struct OptionCategoryController: RouteCollection
{
	func boot(routes: RoutesBuilder) throws {
		
		let optCategory = routes.grouped("api", "option-category")
		optCategory.get(use: getAllHandler)
		optCategory.get(":categoryID", use: getHandler)
		optCategory.get("search", use: searchHandler)
		optCategory.get("optionCategoryID", ":optionCategoryID", use: getOptionCategoryIDHandler)

		//		categoriesRoute.get(":categoryID", "acronyms", use: getAcronymsHandler)
		
		let tokenAuthMiddleware = Token.authenticator()
		let guardAuthMiddleware = User.guardMiddleware()
		let tokenAuthGroup = optCategory.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		tokenAuthGroup.post(use: createHandler)
		tokenAuthGroup.delete(":categoryID", use: deleteHandler)
		tokenAuthGroup.put(":categoryID", use: updateHandler)
	}
	
	func createHandler(_ req: Request) throws -> EventLoopFuture<OptionCategory> {
		let optCategory = try req.content.decode(OptionCategory.self)
		return optCategory.save(on: req.db).map { optCategory }
	}
	
	func deleteHandler(_ req: Request)
	-> EventLoopFuture<HTTPStatus> {
		OptionCategory.find(req.parameters.get("categoryID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { optCategory in
				optCategory.delete(on: req.db)
					.transform(to: .noContent)
			}
	}
	
	func updateHandler(_ req: Request) throws -> EventLoopFuture<OptionCategory> {
		let updateData = try req.content.decode(OptionCategoryData.self)
		
		return OptionCategory.find(req.parameters.get("categoryID"), on: req.db)
			.unwrap(or: Abort(.notFound)).flatMap { optCategory in
				optCategory.optionCategoryID = updateData.optionCategoryID
				optCategory.categoryName = updateData.categoryName
				optCategory.displayNdx = updateData.displayNdx
				
				optCategory.changeToken = updateData.changeToken
				return optCategory.save(on: req.db).map {
					optCategory
				}
			}
	}
	
	
	func getAllHandler(_ req: Request) -> EventLoopFuture<[OptionCategory]> {
		OptionCategory.query(on: req.db).all()
	}
	
	func getHandler(_ req: Request) -> EventLoopFuture<OptionCategory> {
		OptionCategory.find(req.parameters.get("categoryID"), on: req.db).unwrap(or: Abort(.notFound))
	}
	
	func searchHandler(_ req: Request) throws -> EventLoopFuture<OptionCategory>
	{
		guard let searchTerm = req
				.query[String.self, at: "name"] else {
			throw Abort(.badRequest)
		}
		return OptionCategory.query(on: req.db).group(.or) { or in
			or.filter(\.$categoryName == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}
	
	
	func getOptionCategoryIDHandler(_ req: Request) throws -> EventLoopFuture<OptionCategory>
	{
		guard let searchTerm = req.parameters.get("optionCategoryID") else {
			throw Abort(.badRequest)
		}
		
		return OptionCategory.query(on: req.db).group(.or) { or in
			or.filter(\.$optionCategoryID == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}

		
}


struct OptionCategoryData: Content
{
	let categoryName: String
	let optionCategoryID: String
	let nextOptionID: Int32
	
	let displayNdx: Int32
	
	let changeToken: Int32
}
