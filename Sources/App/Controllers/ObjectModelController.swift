//
//  ObjectModelController.swift
//  
//
//  Created by Craig Grantham on 9/13/21.
//

import Vapor
import Fluent


struct ObjectModelController: RouteCollection
{
	func boot(routes: RoutesBuilder) throws {
		
		let mfgRoute = routes.grouped("api", "site-model")
		mfgRoute.get(use: getAllHandler)
		mfgRoute.get("objectModelID", ":objectModelID", use: getObjectModelIDHandler)
		mfgRoute.get(":modelID", use: getHandler)
		mfgRoute.get("search", use: searchHandler)
		
		//		categoriesRoute.get(":categoryID", "acronyms", use: getAcronymsHandler)
		
		let tokenAuthMiddleware = Token.authenticator()
		let guardAuthMiddleware = User.guardMiddleware()
		let tokenAuthGroup = mfgRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		tokenAuthGroup.post(use: createHandler)
		tokenAuthGroup.delete(":modelID", use: deleteHandler)
		tokenAuthGroup.put(":modelID", use: updateHandler)
	}
	
	func createHandler(_ req: Request) throws -> EventLoopFuture<ObjectModel> {
		let objModel = try req.content.decode(ObjectModel.self)
		return objModel.save(on: req.db).map { objModel }
	}

	func deleteHandler(_ req: Request)
	-> EventLoopFuture<HTTPStatus> {
		ObjectModel.find(req.parameters.get("modelID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { objModel in
				objModel.delete(on: req.db)
					.transform(to: .noContent)
			}
	}
	
	func updateHandler(_ req: Request) throws -> EventLoopFuture<ObjectModel> {
		let updateData = try req.content.decode(ObjectModelData.self)
		
		return ObjectModel.find(req.parameters.get("modelID"), on: req.db)
			.unwrap(or: Abort(.notFound)).flatMap { objectModel in
				
				objectModel.name = updateData.name
				objectModel.objectModelID = updateData.objectModelID
				objectModel.makeID = updateData.makeID
				
				objectModel.changeToken = updateData.changeToken
				return objectModel.save(on: req.db).map {
					objectModel
				}
			}
	}
	

	func getAllHandler(_ req: Request) -> EventLoopFuture<[ObjectModel]> {
		ObjectModel.query(on: req.db).all()
	}
	
	func getHandler(_ req: Request) -> EventLoopFuture<ObjectModel> {
		ObjectModel.find(req.parameters.get("modelID"), on: req.db).unwrap(or: Abort(.notFound))
	}
	
	
	func getObjectModelIDHandler(_ req: Request) throws -> EventLoopFuture<ObjectModel>
	{
		guard let searchTerm = req.parameters.get("objectModelID") else {
			throw Abort(.badRequest)
		}
		
		print("objectModelID:  \(searchTerm)")
		
		return ObjectModel.query(on: req.db).group(.or) { or in
			or.filter(\.$objectModelID == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}

	func searchHandler(_ req: Request) throws -> EventLoopFuture<ObjectModel>
	{
		guard let searchTerm = req
				.query[String.self, at: "name"] else {
			throw Abort(.badRequest)
		}
		return ObjectModel.query(on: req.db).group(.or) { or in
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



struct ObjectModelData: Content
{
	let name: String
	let objectModelID: String
	let makeID: String

	let changeToken: Int32
}
