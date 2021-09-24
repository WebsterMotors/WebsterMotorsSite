//
//  ObjectMakeController.swift
//  
//
//  Created by Craig Grantham on 9/13/21.
//

import Vapor
import Fluent


struct ObjectMakeController: RouteCollection
{
	func boot(routes: RoutesBuilder) throws {
		
		let mfgRoute = routes.grouped("api", "object-make")
		mfgRoute.get(use: getAllHandler)
		mfgRoute.get(":mfgID", use: getHandler)
		mfgRoute.get("makeID", ":makeID", use: getMakeIDHandler)
		mfgRoute.get("search", use: searchHandler)

		//		categoriesRoute.get(":categoryID", "acronyms", use: getAcronymsHandler)
		
		let tokenAuthMiddleware = Token.authenticator()
		let guardAuthMiddleware = User.guardMiddleware()
		let tokenAuthGroup = mfgRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		tokenAuthGroup.post(use: createHandler)
		tokenAuthGroup.delete(":mfgID", use: deleteHandler)
		tokenAuthGroup.put(":mfgID", use: updateHandler)
	}
	
	func createHandler(_ req: Request) throws -> EventLoopFuture<ObjectMake> {
		let make = try req.content.decode(ObjectMake.self)
		return make.save(on: req.db).map { make }
	}

	func deleteHandler(_ req: Request)
	-> EventLoopFuture<HTTPStatus> {
		ObjectMake.find(req.parameters.get("mfgID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { make in
				make.delete(on: req.db)
					.transform(to: .noContent)
			}
	}
	
	func updateHandler(_ req: Request) throws -> EventLoopFuture<ObjectMake> {
		let updateData = try req.content.decode(ObjectMakeData.self)
		
		return ObjectMake.find(req.parameters.get("mfgID"), on: req.db)
			.unwrap(or: Abort(.notFound)).flatMap { make in
				make.makeID = updateData.makeID
				make.makeSiteURL = updateData.makeSiteURL
				make.name = updateData.name
				make.optionImageID = updateData.optionImageID
				make.tagLine = updateData.tagLine
				make.logoImageURL = updateData.logoImageURL
				make.pageName = updateData.pageName
				make.changeToken = updateData.changeToken
				return make.save(on: req.db).map {
					make
				}
			}
	}

	
	func getAllHandler(_ req: Request) -> EventLoopFuture<[ObjectMake]> {
		ObjectMake.query(on: req.db).all()
	}
	
	func getHandler(_ req: Request) -> EventLoopFuture<ObjectMake> {
		ObjectMake.find(req.parameters.get("mfgID"), on: req.db).unwrap(or: Abort(.notFound))
	}
	
	
	func getMakeIDHandler(_ req: Request) throws -> EventLoopFuture<ObjectMake>
	{
		guard let searchTerm = req.parameters.get("makeID") else {
			throw Abort(.badRequest)
		}
		
		print("MakeID:  \(searchTerm)")
		
		return ObjectMake.query(on: req.db).group(.or) { or in
			or.filter(\.$makeID == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}

	func searchHandler(_ req: Request) throws -> EventLoopFuture<ObjectMake>
	{
		guard let searchTerm = req
				.query[String.self, at: "name"] else {
			throw Abort(.badRequest)
		}
		return ObjectMake.query(on: req.db).group(.or) { or in
			or.filter(\.$name == searchTerm)
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



struct ObjectMakeData: Content
{
	let makeID: String
	let name: String
	
	let pageName: String?
	let makeSiteURL: String?
	let tagLine: String?
	let optionImageID: String?
	let logoImageURL: String?
	
	let changeToken: Int32
}
