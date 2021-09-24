//
//  InteriorColorController.swift
//  
//
//  Created by Craig Grantham on 9/13/21.
//

import Vapor
import Fluent


struct InteriorColorController: RouteCollection
{
	func boot(routes: RoutesBuilder) throws {
		
		let colorsRoute = routes.grouped("api", "interior-color")
		colorsRoute.get(use: getAllHandler)
		colorsRoute.get(":colorID", use: getHandler)
		colorsRoute.get("search", use: searchHandler)
		colorsRoute.get("interiorColorID", ":interiorColorID", use: getColorDHandler)

		//		categoriesRoute.get(":categoryID", "acronyms", use: getAcronymsHandler)
		
		let tokenAuthMiddleware = Token.authenticator()
		let guardAuthMiddleware = User.guardMiddleware()
		let tokenAuthGroup = colorsRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		tokenAuthGroup.post(use: createHandler)
		tokenAuthGroup.delete(":colorID", use: deleteHandler)
		tokenAuthGroup.put(":colorID", use: updateHandler)
	}
	
	func createHandler(_ req: Request) throws -> EventLoopFuture<InteriorColor> {
		let intColor = try req.content.decode(InteriorColor.self)
		return intColor.save(on: req.db).map { intColor }
	}

	func deleteHandler(_ req: Request)
	-> EventLoopFuture<HTTPStatus> {
		InteriorColor.find(req.parameters.get("colorID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { intColor in
				intColor.delete(on: req.db)
					.transform(to: .noContent)
			}
	}
	
	func updateHandler(_ req: Request) throws -> EventLoopFuture<InteriorColor> {
		let updateData = try req.content.decode(InteriorColorData.self)
		//		let user = try req.auth.require(User.self)
		//		let userID = try user.requireID()
		
		return InteriorColor.find(req.parameters.get("colorID"), on: req.db)
			.unwrap(or: Abort(.notFound)).flatMap { intColor in
				intColor.interiorColorID = updateData.interiorColorID
				intColor.name = updateData.name
				intColor.optionImageID = updateData.optionImageID
				intColor.changeToken = updateData.changeToken
				return intColor.save(on: req.db).map {
					intColor
				}
			}
	}

	
	func getAllHandler(_ req: Request) -> EventLoopFuture<[InteriorColor]> {
		InteriorColor.query(on: req.db).all()
	}
	
	func getHandler(_ req: Request) -> EventLoopFuture<InteriorColor> {
		InteriorColor.find(req.parameters.get("colorID"), on: req.db).unwrap(or: Abort(.notFound))
	}
	
	
	func getColorDHandler(_ req: Request) throws -> EventLoopFuture<InteriorColor>
	{
		guard let searchTerm = req.parameters.get("interiorColorID") else {
			throw Abort(.badRequest)
		}
		
		print("interiorColorID:  \(searchTerm)")
		
		return InteriorColor.query(on: req.db).group(.or) { or in
			or.filter(\.$interiorColorID == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}

	func searchHandler(_ req: Request) throws -> EventLoopFuture<InteriorColor>
	{
		guard let searchTerm = req
				.query[String.self, at: "name"] else {
			throw Abort(.badRequest)
		}
		return InteriorColor.query(on: req.db).group(.or) { or in
			or.filter(\.$name == searchTerm)
			or.filter(\.$interiorColorID == searchTerm)
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



struct InteriorColorData: Content
{
	let interiorColorID: String
	let name: String
	
	let optionImageID: String?
	let changeToken: Int32
}
