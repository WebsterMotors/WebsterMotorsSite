//
//  SiteObjectImageController.swift
//  
//
//  Created by Craig Grantham on 9/14/21.
//

import Vapor
import Fluent


struct SiteObjectImageController: RouteCollection
{
	func boot(routes: RoutesBuilder) throws {
		
		let imageRoutes = routes.grouped("api", "object-image")
		imageRoutes.get(use: getAllHandler)
		imageRoutes.get("siteObjectImageID", ":siteObjectImageID", use: getSiteObjectImageIDHandler)
		imageRoutes.get("siteObjectID", ":siteObjectID", use: getSiteObjectIDHandler)
		imageRoutes.get(":imageID", use: getHandler)
		imageRoutes.get("search", use: searchHandler)
		
		//		categoriesRoute.get(":imageID", "acronyms", use: getAcronymsHandler)
		
		let tokenAuthMiddleware = Token.authenticator()
		let guardAuthMiddleware = User.guardMiddleware()
		let tokenAuthGroup = imageRoutes.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		tokenAuthGroup.post(use: createHandler)
		tokenAuthGroup.delete(":imageID", use: deleteHandler)
		tokenAuthGroup.put(":imageID", use: updateHandler)
	}
	
	func createHandler(_ req: Request) throws -> EventLoopFuture<SiteObjectImage> {
		let objImage = try req.content.decode(SiteObjectImage.self)
		return objImage.save(on: req.db).map { objImage }
	}
	
	func deleteHandler(_ req: Request)
	-> EventLoopFuture<HTTPStatus> {
		SiteObjectImage.find(req.parameters.get("imageID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { objImage in
				objImage.delete(on: req.db)
					.transform(to: .noContent)
			}
	}
	
	func updateHandler(_ req: Request) throws -> EventLoopFuture<SiteObjectImage> {
		let updateData = try req.content.decode(SiteObjectImageData.self)
		
		return SiteObjectImage.find(req.parameters.get("imageID"), on: req.db)
			.unwrap(or: Abort(.notFound)).flatMap { objImage in
				
				objImage.siteObjectID = updateData.siteObjectID
				objImage.siteObjectImageID = updateData.siteObjectImageID
				objImage.photoNdx = updateData.photoNdx
				objImage.caption = updateData.caption

				objImage.fileName = updateData.fileName
				objImage.awsBucketURL = updateData.awsBucketURL

				objImage.awsKey = updateData.awsKey
				objImage.cloudServerID = updateData.cloudServerID

				objImage.changeToken = updateData.changeToken
				return objImage.save(on: req.db).map {
					objImage
				}
			}
	}
	
	
	func getAllHandler(_ req: Request) -> EventLoopFuture<[SiteObjectImage]> {
		SiteObjectImage.query(on: req.db).all()
	}
	
	func getHandler(_ req: Request) -> EventLoopFuture<SiteObjectImage> {
		SiteObjectImage.find(req.parameters.get("imageID"), on: req.db).unwrap(or: Abort(.notFound))
	}
	
	
	func getSiteObjectImageIDHandler(_ req: Request) throws -> EventLoopFuture<SiteObjectImage>
	{
		guard let searchTerm = req.parameters.get("siteObjectImageID") else {
			throw Abort(.badRequest)
		}
		
		print("siteObjectImageID:  \(searchTerm)")
		
		return SiteObjectImage.query(on: req.db).group(.or) { or in
			or.filter(\.$siteObjectImageID == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}
	
	
	func getSiteObjectIDHandler(_ req: Request) throws -> EventLoopFuture<[SiteObjectImage]>
	{
		guard let searchTerm = req.parameters.get("siteObjectID") else {
			throw Abort(.badRequest)
		}
		
		return SiteObjectImage.query(on: req.db).group(.or) { or in
			or.filter(\.$siteObjectID == searchTerm)
		}.all()
	}

	
	func searchHandler(_ req: Request) throws -> EventLoopFuture<SiteObjectImage>
	{
		guard let searchTerm = req
				.query[String.self, at: "parm"] else {
			throw Abort(.badRequest)
		}
		return SiteObjectImage.query(on: req.db).group(.or) { or in
			or.filter(\.$siteObjectImageID == searchTerm)
			or.filter(\.$fileName == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}
	
	/*
	func getAcronymsHandler(_ req: Request) -> EventLoopFuture<[Acronym]> {
	Category.find(req.parameters.get("imageID"), on: req.db)
	.unwrap(or: Abort(.notFound))
	.flatMap { category in
	category.$acronyms.get(on: req.db)
	}
	}
	*/
	
}


struct SiteObjectImageData: Content
{
	let siteObjectID: String
	let siteObjectImageID: String
	let photoNdx: Int32
	let caption: String?

	let fileName: String
	let awsBucketURL: String?

	let cloudServerID: Int32?
	let awsKey: String?

	let changeToken: Int32
}
