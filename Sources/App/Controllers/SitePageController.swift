//
//  SitePageController.swift
//  
//
//  Created by Craig Grantham on 11/4/21.
//

import Vapor
import Fluent


struct SitePageController: RouteCollection
{
	func boot(routes: RoutesBuilder) throws {
		
		let sitePageRoute = routes.grouped("api", "site-page")
		sitePageRoute.get(use: getAllHandler)
		sitePageRoute.get(":pageID", use: getHandler)
		sitePageRoute.get("search", use: searchHandler)
		sitePageRoute.get("pageName", ":pageName", use: getPageTitledHandler)
		
		sitePageRoute.get(":pageID", "objects", use: getPageObjectsHandler)
		sitePageRoute.get(":pageID", "makes", use: getObjectMakesHandler)

		let tokenAuthMiddleware = Token.authenticator()
		let guardAuthMiddleware = User.guardMiddleware()
		let tokenAuthGroup = sitePageRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		
		tokenAuthGroup.post(use: createHandler)
		
		tokenAuthGroup.post(":pageID", "objects", ":objectID", use: addSiteObjectsHandler)
		
		tokenAuthGroup.delete(":pageID", "objects", ":objectID", use: removeObjectsHandler)

		tokenAuthGroup.post(":pageID", "makes", ":makeID", use: addObjectMakesHandler)
		
		tokenAuthGroup.delete(":pageID", "makes", ":makeID", use: removeObjectMakesHandler)
		
		tokenAuthGroup.delete(":pageID", use: deleteHandler)
		tokenAuthGroup.put(":pageID", use: updateHandler)
	}
	
	
	func createHandler(_ req: Request) throws -> EventLoopFuture<SitePage> {
		let webPage = try req.content.decode(SitePage.self)
		return webPage.save(on: req.db).map { webPage }
	}
	
	
	func deleteHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
		SitePage.find(req.parameters.get("pageID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { webPage in
				webPage.delete(on: req.db)
					.transform(to: .noContent)
			}
	}

	
	func updateHandler(_ req: Request) throws -> EventLoopFuture<SitePage> {
		let updateData = try req.content.decode(SitePageData.self)
		
		return SitePage.find(req.parameters.get("pageID"), on: req.db)
			.unwrap(or: Abort(.notFound)).flatMap { webPage in
				
				webPage.pageTitle = updateData.pageTitle
				webPage.pageName = updateData.pageName
				
				return webPage.save(on: req.db).map {
					webPage
				}
			}
	}
	
	
	func getAllHandler(_ req: Request) -> EventLoopFuture<[SitePage]> {
		SitePage.query(on: req.db).all()
	}
	
	
	func getHandler(_ req: Request) -> EventLoopFuture<SitePage> {
		SitePage.find(req.parameters.get("pageID"), on: req.db).unwrap(or: Abort(.notFound))
	}
	
	func searchHandler(_ req: Request) throws -> EventLoopFuture<SitePage>
	{
		guard let searchTerm = req
				.query[String.self, at: "name"] else {
					throw Abort(.badRequest)
				}
		
		return SitePage.query(on: req.db).group(.or) { or in
			or.filter(\.$pageName == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}
	
	
	func getPageTitledHandler(_ req: Request) throws -> EventLoopFuture<SitePage>
	{
		guard let searchTerm = req.parameters.get("pageName") else {
			throw Abort(.badRequest)
		}
		
		return SitePage.query(on: req.db).group(.or) { or in
			or.filter(\.$pageName == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}
	
	
	func addSiteObjectsHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
		
		let pageQuery = SitePage.find(req.parameters.get("pageID"), on: req.db).unwrap(or: Abort(.notFound))
		
		let objectQuery = SiteObject.find(req.parameters.get("objectID"), on: req.db).unwrap(or: Abort(.notFound))
		
		return pageQuery.and(objectQuery).flatMap { page, object in
			
			page.$siteObjects.attach(object, on: req.db).transform(to: .created)
		}
	}


	func getPageObjectsHandler(_ req: Request) -> EventLoopFuture<[SiteObject]> {

		SitePage.find(req.parameters.get("pageID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { page in

				page.$siteObjects.query(on: req.db).all()
			}
	}
	

	func removeObjectsHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
		
		let pageQuery = SitePage.find(req.parameters.get("pageID"), on: req.db).unwrap(or: Abort(.notFound))
		
		let objectQuery = SiteObject.find(req.parameters.get("objectID"), on: req.db).unwrap(or: Abort(.notFound))
		
		return pageQuery.and(objectQuery).flatMap { page, object in
			
			page.$siteObjects.detach(object, on: req.db).transform(to: .noContent)
		}
	}
	
	
	func addObjectMakesHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
		
		let pageQuery = SitePage.find(req.parameters.get("pageID"), on: req.db).unwrap(or: Abort(.notFound))
		
		let makeQuery = ObjectMake.find(req.parameters.get("makeID"), on: req.db).unwrap(or: Abort(.notFound))
		
		return pageQuery.and(makeQuery).flatMap { page, make in
			
			page.$objectMakes.attach(make, on: req.db).transform(to: .created)
		}
	}
	
	
	func getObjectMakesHandler(_ req: Request) -> EventLoopFuture<[ObjectMake]> {
		
		SitePage.find(req.parameters.get("pageID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { page in
				
				page.$objectMakes.query(on: req.db).all()
			}
	}
	
	
	func removeObjectMakesHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
		
		let pageQuery = SitePage.find(req.parameters.get("pageID"), on: req.db).unwrap(or: Abort(.notFound))
		
		let makeQuery = ObjectMake.find(req.parameters.get("makeID"), on: req.db).unwrap(or: Abort(.notFound))
		
		return pageQuery.and(makeQuery).flatMap { page, make in
			
			page.$objectMakes.detach(make, on: req.db).transform(to: .noContent)
		}
	}

}



struct SitePageData: Content
{
	let pageTitle: String
	let pageID: String
	let pageName: String
}
