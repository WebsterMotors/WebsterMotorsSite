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
import CryptoKit


struct WebsiteController: RouteCollection
{
	
	func boot(routes: RoutesBuilder) throws {
		
		routes.get(use: indexHandler)
	}


	func indexHandler(_ req: Request) -> EventLoopFuture<View> {

		SiteObject.query(on: req.db).all().flatMap { siteObjs in

			let siteObjects = siteObjs.isEmpty ? nil : siteObjs
			
			let context = IndexContext(
				title: "WebsterMotors",
				vehicles: siteObjects)
			
			return req.view.render("index", context)
		}
	}
	
	
}

struct IndexContext: Encodable {
	let title: String

	let vehicles: [SiteObject]?
}
