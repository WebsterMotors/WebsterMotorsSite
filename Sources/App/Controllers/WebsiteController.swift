//
//  WebsiteController.swift
//  
//
//  Created by Craig Grantham on 8/27/21.
//

import Vapor
import Fluent
import Leaf
import Foundation
//import CryptoKit


struct WebsiteController: RouteCollection
{
	
	func boot(routes: RoutesBuilder) throws {
		
		routes.get(use: indexHandler)
		routes.get("siteObjectID", ":siteObjectID", use: getSiteObjectIDHandler)	}


	func indexHandler(_ req: Request) -> EventLoopFuture<View> {

		SiteObject.query(on: req.db).all().flatMap { siteObjs in

			let siteObjects = siteObjs.isEmpty ? nil : siteObjs
			
			for car in siteObjects!
			{
				car.objectDescription = car.objectImages![0]
			}
			
			let context = IndexContext(
				title: "WebsterMotors",
				vehicles: siteObjects)
			
			return req.view.render("index", context)
		}
	}
	
	
	func getSiteObjectIDHandler(_ req: Request) -> EventLoopFuture<View>
	{
		SiteObject.find(req.parameters.get("siteObjectID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap() { siteObject in
				
				siteObject.objectDescription = siteObject.objectImages![0]
				
				let context = SiteObjectContext(
					title: siteObject.modelName,
					vehicle: siteObject)
				
				return req.view.render("detail", context)
		}
	}

	
}

struct IndexContext: Encodable {
	let title: String

	let vehicles: [SiteObject]?
}


struct SiteObjectContext: Encodable {
	let title: String
	let vehicle: SiteObject
}
