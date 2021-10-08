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


struct WebsiteController: RouteCollection
{
	
	func boot(routes: RoutesBuilder) throws {
		
		routes.get(use: indexHandler)
		routes.get("index", use: indexHandler)
		routes.get("about-us", use: aboutHandler)
		routes.get("contact-us", use: contactHandler)
		routes.get("Cars", use: carsHandler)
		routes.get("SUVs", use: suvsHandler)
		routes.get("Trucks", use: trucksHandler)
		routes.get("siteObjectID", use: getSiteObjectIDHandler)
		
	}

	
	
	func getTopNavigation(_ req: Request) -> EventLoopFuture<[WebsiteCategory]> {
		WebsiteCategory.query(on: req.db).sort(\.$navigationOrderNdx).all()
	}

	
	func aboutHandler(_ req: Request) -> EventLoopFuture<View> {
		
		WebsiteCategory.query(on: req.db).sort(\.$navigationOrderNdx).all().flatMap { navItems in
			
			SiteObject.query(on: req.db).sort(\.$makeName).sort(\.$modelYear, .descending).all().flatMap { siteObjs in
				
				let siteObjects = siteObjs.isEmpty ? nil : siteObjs
				
				let context = IndexContext(
					title: "WebsterMotors",
					vehicles: siteObjects,
					top_nav: navItems)
				
				return req.view.render("about-us", context)
			}
		}
	}

	
	func contactHandler(_ req: Request) -> EventLoopFuture<View> {
		
		WebsiteCategory.query(on: req.db).sort(\.$navigationOrderNdx).all().flatMap { navItems in
			
			SiteObject.query(on: req.db).sort(\.$makeName).sort(\.$modelYear, .descending).all().flatMap { siteObjs in
				
				let siteObjects = siteObjs.isEmpty ? nil : siteObjs
				
				let context = IndexContext(
					title: "WebsterMotors",
					vehicles: siteObjects,
					top_nav: navItems)
				
				return req.view.render("contact-us", context)
			}
		}
	}

	
	func getObjectsFor(_ req: Request, categoryID: String ) -> EventLoopFuture<[SiteObject]>
	{
		return SiteObject.query(on: req.db).group(.or) { group in
			group.filter(\.$webCatogoryID == categoryID)}.sort(\.$makeName).sort(\.$modelYear, .descending).all()
	}

	
	func indexHandler(_ req: Request) -> EventLoopFuture<View> {
		
		WebsiteCategory.query(on: req.db).sort(\.$navigationOrderNdx).all().flatMap { navItems in
			
			SiteObject.query(on: req.db).sort(\.$makeName).sort(\.$modelYear, .descending).all().flatMap { siteObjs in
				
				let siteObjects = siteObjs.isEmpty ? nil : siteObjs
				
				var pageNav: [String : Int] = [:]
				var makeNav: [String] = []
				var navNdx = 0
				
				for siteObj in siteObjs
				{
					if let _ = pageNav[siteObj.makeName]
					{
						
					}
					else
					{
						pageNav[siteObj.makeName] = navNdx
						navNdx += 1
						
						makeNav.append(siteObj.makeName)
					}
				}
				

				let context = PageNavContext(
					title: "WebsterMotors",
					vehicles: siteObjects,
					top_nav: navItems,
					page_nav: makeNav)

				return req.view.render("index", context)
			}
		}
	}

	
	func carsHandler(_ req: Request) -> EventLoopFuture<View> {
		
		WebsiteCategory.query(on: req.db).group(.or) { group in
			
			group.filter(\.$navButtonName == "Cars")}.first().flatMap { navItem in
				
				SiteObject.query(on: req.db).group(.or) { group in
					group.filter(\.$webCatogoryID == navItem!.webCatogoryID)}.sort(\.$makeName).sort(\.$modelYear, .descending).all().flatMap { siteObjs in
						
						let siteObjects = siteObjs.isEmpty ? nil : siteObjs
						
						var pageNav: [String : Int] = [:]
						var makeNav: [String] = []
						var navNdx = 0
						
						for siteObj in siteObjs
						{
							if let _ = pageNav[siteObj.makeName]
							{
								
							}
							else
							{
								pageNav[siteObj.makeName] = navNdx
								navNdx += 1
								
								makeNav.append(siteObj.makeName)
							}
						}
						
						return WebsiteCategory.query(on: req.db).sort(\.$navigationOrderNdx).all().flatMap() { navItems -> EventLoopFuture<View> in
							
							let context = CollectionContext(
								title: "WebsterMotors",
								vehicles: siteObjects,
								top_nav: navItems,
								page_nav: makeNav)
							
							return req.view.render("cars", context)
						}
					}
			}
	}

	
	
	
	func suvsHandler(_ req: Request) -> EventLoopFuture<View> {
		
		WebsiteCategory.query(on: req.db).sort(\.$navigationOrderNdx).all().flatMap { navItems in
			
			SiteObject.query(on: req.db).sort(\.$makeID).sort(\.$modelYear, .descending).all().flatMap { siteObjs in
				
				let siteObjects = siteObjs.isEmpty ? nil : siteObjs
				
				var pageNav: [String : Int] = [:]
				var makeNav: [String] = []
				var navNdx = 0
				
				for siteObj in siteObjs
				{
					if let _ = pageNav[siteObj.makeName]
					{
						
					}
					else
					{
						pageNav[siteObj.makeName] = navNdx
						navNdx += 1
						
						makeNav.append(siteObj.makeName)
					}
				}
				
				let context = CollectionContext(
					title: "WebsterMotors",
					vehicles: siteObjects,
					top_nav: navItems,
					page_nav: makeNav)

				return req.view.render("about-us", context)
			}
		}
	}
	
	
	func trucksHandler(_ req: Request) -> EventLoopFuture<View> {
		
		WebsiteCategory.query(on: req.db).sort(\.$navigationOrderNdx).all().flatMap { navItems in
			
			SiteObject.query(on: req.db).sort(\.$makeID).sort(\.$modelYear, .descending).all().flatMap { siteObjs in
				
				let siteObjects = siteObjs.isEmpty ? nil : siteObjs
				
				let context = IndexContext(
					title: "WebsterMotors",
					vehicles: siteObjects,
					top_nav: navItems)
				
				return req.view.render("about-us", context)
			}
		}
	}

	
	func getSiteObjectIDHandler(_ req: Request) -> EventLoopFuture<View>
	{
		guard let objectID = req
				.query[String.self, at: "object"] else {
					_ = Abort(.badRequest)
					
					return req.view.render("car-detail")
				}

		return WebsiteCategory.query(on: req.db).sort(\.$navigationOrderNdx).all().flatMap { navItems -> EventLoopFuture<View> in
			
			SiteObject.query(on: req.db).group(.or) { or in
				or.filter(\.$siteObjectID == objectID)
			}.first().flatMap() { siteObject in
				
				var car: SiteObject!
				
				if let obj = siteObject
				{
					car = obj
				}
				
				return ObjectCategoryList.query(on: req.db).group(.or) { or in
					or.filter(\.$siteObjectID == car.siteObjectID)}.sort(\.$displayNdx).all().flatMap { carFeatures -> EventLoopFuture<View> in
						
						let context = SiteObjectContext(
							title: car.modelName,
							vehicle: car,
							features: carFeatures,
							top_nav: navItems)
						
						return req.view.render("car-detail", context)
					}
				}
		}
	}
	
	
}

struct IndexContext: Encodable {
	let title: String

	let vehicles: [SiteObject]?
	let top_nav: [WebsiteCategory]?
}

struct PageNavContext: Encodable {
	let title: String
	
	let vehicles: [SiteObject]?
	let top_nav: [WebsiteCategory]?
	let page_nav: [String]
}


struct SiteObjectContext: Encodable {
	let title: String
	let vehicle: SiteObject
	let features: [ObjectCategoryList]
	let top_nav: [WebsiteCategory]?
}

struct CollectionContext: Encodable {
	let title: String
	
	let vehicles: [SiteObject]?
	let top_nav: [WebsiteCategory]?
	let page_nav: [String]
}


