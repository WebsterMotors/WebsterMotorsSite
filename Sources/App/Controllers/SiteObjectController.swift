//
//  SiteObjectController.swift
//  
//
//  Created by Craig Grantham on 9/14/21.
//

import Vapor
import Fluent


struct SiteObjectController: RouteCollection
{
	func boot(routes: RoutesBuilder) throws {
		
		let objectRoutes = routes.grouped("api", "site-object")
		objectRoutes.get(use: getAllHandler)
		objectRoutes.get(":objectID", use: getHandler)
		objectRoutes.get("siteObjectID", ":siteObjectID", use: getSiteObjectIDHandler)
		objectRoutes.get("search", use: searchHandler)

		objectRoutes.get("OptionItems", use: findOptionItemsHandler)

		//		categoriesRoute.get(":objectID", "acronyms", use: getAcronymsHandler)
		
		let tokenAuthMiddleware = Token.authenticator()
		let guardAuthMiddleware = User.guardMiddleware()
		let tokenAuthGroup = objectRoutes.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		tokenAuthGroup.post(use: createHandler)
		tokenAuthGroup.delete(":objectID", use: deleteHandler)
		tokenAuthGroup.put(":objectID", use: updateHandler)
	}
	
	func createHandler(_ req: Request) throws -> EventLoopFuture<SiteObject> {
		let siteObject = try req.content.decode(SiteObject.self)
		return siteObject.save(on: req.db).map { siteObject }
	}
	
	func deleteHandler(_ req: Request)
	-> EventLoopFuture<HTTPStatus> {
		SiteObject.find(req.parameters.get("objectID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { siteObject in
				siteObject.delete(on: req.db)
					.transform(to: .noContent)
			}
	}
	
	func updateHandler(_ req: Request) throws -> EventLoopFuture<SiteObject> {
		let updateData = try req.content.decode(SiteObjectData.self)
		
		return SiteObject.find(req.parameters.get("objectID"), on: req.db)
			.unwrap(or: Abort(.notFound)).flatMap { siteObject in
				
				siteObject.siteObjectID = updateData.siteObjectID
				siteObject.webCatogoryID = updateData.webCatogoryID
				siteObject.objectModelID = updateData.objectModelID
				siteObject.modelName = updateData.modelName
				
				siteObject.objectTypeID = updateData.objectTypeID
				siteObject.typeName = updateData.typeName
				
				siteObject.makeID = updateData.makeID

				siteObject.featureInfo = updateData.featureInfo
				
				siteObject.vinNumber = updateData.vinNumber
				siteObject.modelYear = updateData.modelYear
				siteObject.numDoors = updateData.numDoors
				siteObject.mileage = updateData.mileage

				siteObject.listPrice = updateData.listPrice
				siteObject.reducedPrice = updateData.reducedPrice
				siteObject.objectDescription = updateData.objectDescription
				
				siteObject.hideListing = updateData.hideListing
				siteObject.showInSpecials = updateData.showInSpecials
				
				siteObject.exteriorColorID = updateData.exteriorColorID
				siteObject.exteriorColor = updateData.exteriorColor
				siteObject.interiorColorID = updateData.interiorColorID
				siteObject.interiorColor = updateData.interiorColor
				siteObject.nextPhotoNdx = updateData.nextPhotoNdx
				
				siteObject.heroImage = updateData.heroImage
				siteObject.objectImages = updateData.objectImages

				siteObject.changeToken = updateData.changeToken
				return siteObject.save(on: req.db).map {
					siteObject
				}
			}
	}
	
	
	func getAllHandler(_ req: Request) -> EventLoopFuture<[SiteObject]> {
		SiteObject.query(on: req.db).all()
	}
	
	func getHandler(_ req: Request) -> EventLoopFuture<SiteObject> {
		SiteObject.find(req.parameters.get("objectID"), on: req.db).unwrap(or: Abort(.notFound))
	}
	
	
	func getSiteObjectIDHandler(_ req: Request) throws -> EventLoopFuture<SiteObject>
	{
		guard let searchTerm = req.parameters.get("siteObjectID") else {
			throw Abort(.badRequest)
		}
				
		return SiteObject.query(on: req.db).group(.or) { or in
			or.filter(\.$siteObjectID == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}

	func searchHandler(_ req: Request) throws -> EventLoopFuture<SiteObject>
	{
		guard let searchTerm = req
				.query[String.self, at: "vin"] else {
			throw Abort(.badRequest)
		}
		return SiteObject.query(on: req.db).group(.or) { or in
			or.filter(\.$vinNumber == searchTerm)
		}.first().unwrap(or: Abort(.notFound))
	}
	

	
	func findOptionItemsHandler(_ req: Request) throws -> EventLoopFuture<[ObjectOptionItem]>
	{
		guard let objectID = req
				.query[String.self, at: "object"] else {
					throw Abort(.badRequest)
				}
		
		guard let categoryID = req
				.query[String.self, at: "category"] else {
					throw Abort(.badRequest)
				}
		
		return ObjectOptionItem.query(on: req.db).group(.and) { group in
			group.filter(\.$siteObjectID == objectID)
			group.filter(\.$optionCategoryID == categoryID)
		}.all()
	}

}


struct SiteObjectData: Content
{
	let siteObjectID: String
	let webCatogoryID: String
	let objectModelID: String
	
	let modelName: String

	let objectTypeID: String
	let typeName: StringLiteralType
	
	let makeID: String

	let featureInfo: String

	let vinNumber: String?
	let modelYear: Int32?
	let numDoors: Int32?
	let mileage: String?

	let listPrice: String?
	let reducedPrice: String?
	let objectDescription: String?
	
	let hideListing: Bool
	let showInSpecials: Bool

	let exteriorColorID: String?
	let exteriorColor: String?
	
	let interiorColorID: String?
	let interiorColor: String?
	let nextPhotoNdx: Int32?
	
	let objectImages: [String]?
	let heroImage: String?

	let changeToken: Int32
}
