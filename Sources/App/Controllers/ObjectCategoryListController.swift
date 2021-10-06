//
//  ObjectCategoryListController.swift
//  
//
//  Created by Craig Grantham on 9/27/21.
//

import Vapor
import Fluent


struct ObjectCategoryListController: RouteCollection
{
	func boot(routes: RoutesBuilder) throws {
		
		let listRoute = routes.grouped("api", "category-list")
		listRoute.get(use: getAllHandler)
		listRoute.get(":modelID", use: getHandler)
		listRoute.get("siteObjectID", ":siteObjectID", use: getSiteObjectListIDHandler)
		listRoute.get("categoryListID", ":categoryListID", use: getCategoryListIDHandler)
		listRoute.get("search", use: searchHandler)
		listRoute.get("listCategoryObject", use: findCategoryObjectHandler)

		//		categoriesRoute.get(":categoryID", "acronyms", use: getAcronymsHandler)
		
		let tokenAuthMiddleware = Token.authenticator()
		let guardAuthMiddleware = User.guardMiddleware()
		let tokenAuthGroup = listRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		tokenAuthGroup.post(use: createHandler)
		tokenAuthGroup.delete(":modelID", use: deleteHandler)
		tokenAuthGroup.put(":modelID", use: updateHandler)
	}
	
	
	func createHandler(_ req: Request) throws -> EventLoopFuture<ObjectCategoryList> {
		let objModel = try req.content.decode(ObjectCategoryList.self)
		return objModel.save(on: req.db).map { objModel }
	}
	
	func deleteHandler(_ req: Request)
	-> EventLoopFuture<HTTPStatus> {
		ObjectCategoryList.find(req.parameters.get("modelID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { objModel in
				objModel.delete(on: req.db)
					.transform(to: .noContent)
			}
	}
	
	func updateHandler(_ req: Request) throws -> EventLoopFuture<ObjectCategoryList> {
		let updateData = try req.content.decode(ObjectCategoryListData.self)
		
		return ObjectCategoryList.find(req.parameters.get("modelID"), on: req.db)
			.unwrap(or: Abort(.notFound)).flatMap { objectModel in
				
				objectModel.categoryName = updateData.categoryName
				objectModel.optionCategoryID = updateData.optionCategoryID
				objectModel.siteObjectID = updateData.siteObjectID
				
				objectModel.categoryListID = updateData.categoryListID
				objectModel.itemsList = updateData.itemsList
				
				objectModel.displayNdx = updateData.displayNdx

				return objectModel.save(on: req.db).map {
					objectModel
				}
			}
	}
	
	
	func getAllHandler(_ req: Request) -> EventLoopFuture<[ObjectCategoryList]> {
		ObjectCategoryList.query(on: req.db).all()
	}
	
	func getHandler(_ req: Request) -> EventLoopFuture<ObjectCategoryList> {
		ObjectCategoryList.find(req.parameters.get("modelID"), on: req.db).unwrap(or: Abort(.notFound))
	}
	
	
	func getSiteObjectListIDHandler(_ req: Request) throws -> EventLoopFuture<[ObjectCategoryList]>
	{
		guard let searchTerm = req.parameters.get("siteObjectID") else {
			throw Abort(.badRequest)
		}
		
		return ObjectCategoryList.query(on: req.db).group(.or) { or in
			or.filter(\.$siteObjectID == searchTerm)
		}.sort(\.$displayNdx).all()
	}

	
	func getCategoryListIDHandler(_ req: Request) throws -> EventLoopFuture<ObjectCategoryList>
	{
		guard let searchTerm = req.parameters.get("categoryListID") else {
			throw Abort(.badRequest)
		}
		
		return ObjectCategoryList.query(on: req.db).group(.or) { or in
			or.filter(\.$categoryListID == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}
	
	func searchHandler(_ req: Request) throws -> EventLoopFuture<[ObjectCategoryList]>
	{
		guard let searchTerm = req
				.query[String.self, at: "name"] else {
					throw Abort(.badRequest)
				}
		return ObjectCategoryList.query(on: req.db).group(.or) { or in
			or.filter(\.$categoryName == searchTerm)
		}.all()
	}
	
	
	
	func findCategoryObjectHandler(_ req: Request) throws -> EventLoopFuture<ObjectCategoryList>
	{
		guard let objectID = req
				.query[String.self, at: "object"] else {
					throw Abort(.badRequest)
				}
		
		guard let categoryID = req
				.query[String.self, at: "category"] else {
					throw Abort(.badRequest)
				}
		
		return ObjectCategoryList.query(on: req.db).group(.and) { group in
			group.filter(\.$siteObjectID == objectID)
			group.filter(\.$optionCategoryID == categoryID)
		}.first().unwrap(or: Abort(.notFound))
	}

}



struct ObjectCategoryListData: Content
{
	let categoryName: String
	let optionCategoryID: String
	let siteObjectID: String
	
	let categoryListID: String
	let itemsList: String
	
	let displayNdx: Int32?
}
