//
//  WebsiteCategoryController.swift
//  
//
//  Created by Craig Grantham on 9/11/21.
//

import Vapor
import Fluent


struct WebsiteCategoryController: RouteCollection
{
	func boot(routes: RoutesBuilder) throws {
		
		let categoriesRoute = routes.grouped("api", "site-category")
		categoriesRoute.get(use: getAllHandler)
		categoriesRoute.get("siteCategoryID", ":siteCategoryID", use: getSiteCategoryIDHandler)
		categoriesRoute.get(":categoryID", use: getHandler)
		categoriesRoute.get("search", use: searchHandler)

		//		categoriesRoute.get(":categoryID", "acronyms", use: getAcronymsHandler)
		
		let tokenAuthMiddleware = Token.authenticator()
		let guardAuthMiddleware = User.guardMiddleware()
		let tokenAuthGroup = categoriesRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		tokenAuthGroup.post(use: createHandler)
		tokenAuthGroup.delete(":categoryID", use: deleteHandler)
		tokenAuthGroup.put(":categoryID", use: updateHandler)
	}
	
	
	func createHandler(_ req: Request) throws -> EventLoopFuture<WebsiteCategory> {
		let category = try req.content.decode(WebsiteCategory.self)
		return category.save(on: req.db).map { category }
	}

	
	func deleteHandler(_ req: Request)
	-> EventLoopFuture<HTTPStatus> {
		WebsiteCategory.find(req.parameters.get("categoryID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { category in
				category.delete(on: req.db)
					.transform(to: .noContent)
			}
	}
	
	
	func updateHandler(_ req: Request) throws -> EventLoopFuture<WebsiteCategory> {
		let updateData = try req.content.decode(WebsiteCategoryData.self)
		
		return WebsiteCategory.find(req.parameters.get("categoryID"), on: req.db)
			.unwrap(or: Abort(.notFound)).flatMap { websiteCategory in
				
				websiteCategory.webCatogoryID = updateData.webCatogoryID
				websiteCategory.headerDescription = updateData.headerDescription
				websiteCategory.navButtonName = updateData.navButtonName
				websiteCategory.webCategoryName = updateData.webCategoryName
				
				websiteCategory.navigationOrderNdx = updateData.navigationOrderNdx
				websiteCategory.showCategory = updateData.showCategory
				
				websiteCategory.changeToken = updateData.changeToken
				
				return websiteCategory.save(on: req.db).map {
					websiteCategory
				}
			}
	}
	

	func getAllHandler(_ req: Request) -> EventLoopFuture<[WebsiteCategory]> {
		WebsiteCategory.query(on: req.db).sort(\.$navigationOrderNdx).all()
	}
	
	
	func getHandler(_ req: Request) -> EventLoopFuture<WebsiteCategory> {
		WebsiteCategory.find(req.parameters.get("categoryID"), on: req.db).unwrap(or: Abort(.notFound))
	}
	
	
	func getSiteCategoryIDHandler(_ req: Request) throws -> EventLoopFuture<WebsiteCategory>
	{
		guard let searchTerm = req.parameters.get("siteCategoryID") else {
			throw Abort(.badRequest)
		}
		
		return WebsiteCategory.query(on: req.db).group(.or) { or in
			or.filter(\.$webCatogoryID == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}

	
	func searchHandler(_ req: Request) throws -> EventLoopFuture<WebsiteCategory>
	{
		guard let searchTerm = req
				.query[String.self, at: "parm"] else {
			throw Abort(.badRequest)
		}
		
		return WebsiteCategory.query(on: req.db).group(.or) { or in
			or.filter(\.$navButtonName == searchTerm)
			or.filter(\.$webCatogoryID == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}

	
}



struct WebsiteCategoryData: Content
{
	let headerDescription: String
	let navButtonName: String
	let webCategoryName: String?
	let webCatogoryID: String
	
	let navigationOrderNdx: Int32
	let showCategory: Bool

	let changeToken: Int32
}
