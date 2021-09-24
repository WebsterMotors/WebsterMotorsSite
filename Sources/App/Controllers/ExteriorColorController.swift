//
//  ExteriorColorController.swift
//  
//
//  Created by Craig Grantham on 9/13/21.
//

import Vapor
import Fluent


struct ExteriorColorController: RouteCollection
{
	func boot(routes: RoutesBuilder) throws {
		
		let colorsRoute = routes.grouped("api", "exterior-color")
		colorsRoute.get(use: getAllHandler)
		colorsRoute.get("search", use: searchHandler)
		colorsRoute.get(":colorID", use: getHandler)
		colorsRoute.get("exteriorColorID", ":exteriorColorID", use: getColorDHandler)

		
		let tokenAuthMiddleware = Token.authenticator()
		let guardAuthMiddleware = User.guardMiddleware()
		let tokenAuthGroup = colorsRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		tokenAuthGroup.post(use: createHandler)
		tokenAuthGroup.delete(":colorID", use: deleteHandler)
		tokenAuthGroup.put(":colorID", use: updateHandler)
	}
	
	func createHandler(_ req: Request) throws -> EventLoopFuture<ExteriorColor> {
		let extColor = try req.content.decode(ExteriorColor.self)
		return extColor.save(on: req.db).map { extColor }
	}

	func deleteHandler(_ req: Request)
	-> EventLoopFuture<HTTPStatus> {
		ExteriorColor.find(req.parameters.get("colorID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { extColor in
				extColor.delete(on: req.db)
					.transform(to: .noContent)
			}
	}

	func updateHandler(_ req: Request) throws -> EventLoopFuture<ExteriorColor> {
		let updateData = try req.content.decode(ExteriorColorData.self)
//		let user = try req.auth.require(User.self)
//		let userID = try user.requireID()
		
		return ExteriorColor.find(req.parameters.get("colorID"), on: req.db)
			.unwrap(or: Abort(.notFound)).flatMap { extColor in
				extColor.exteriorColorID = updateData.exteriorColorID
				extColor.name = updateData.name
				extColor.optionImageID = updateData.optionImageID
				extColor.changeToken = updateData.changeToken
				return extColor.save(on: req.db).map {
					extColor
				}
			}
	}

	func getAllHandler(_ req: Request) -> EventLoopFuture<[ExteriorColor]> {
		ExteriorColor.query(on: req.db).all()
	}
	
	func getHandler(_ req: Request) -> EventLoopFuture<ExteriorColor> {
		ExteriorColor.find(req.parameters.get("colorID"), on: req.db).unwrap(or: Abort(.notFound))
	}

	func searchHandler(_ req: Request) throws -> EventLoopFuture<ExteriorColor>
	{
		guard let searchTerm = req
				.query[String.self, at: "name"] else {
			throw Abort(.badRequest)
		}
		return ExteriorColor.query(on: req.db).group(.or) { or in
			or.filter(\.$name == searchTerm)
			or.filter(\.$exteriorColorID == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}

	
	
	func getColorDHandler(_ req: Request) throws -> EventLoopFuture<ExteriorColor>
	{
		guard let searchTerm = req.parameters.get("exteriorColorID") else {
			throw Abort(.badRequest)
		}
		
		print("exteriorColorID:  \(searchTerm)")
		
		return ExteriorColor.query(on: req.db).group(.or) { or in
			or.filter(\.$exteriorColorID == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}

}



struct ExteriorColorData: Content
{
	let exteriorColorID: String
	let name: String
	
	let optionImageID: String?
	let changeToken: Int32
}
