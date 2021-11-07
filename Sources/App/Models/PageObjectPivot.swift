//
//  PageObjectPivot.swift
//  
//
//  Created by Craig Grantham on 11/4/21.
//

import Vapor
import Fluent


final class PageObjectPivot: Model {
	
	static let schema = "page-object-pivot"
	
	@ID
	var id: UUID?
	
	@Parent(key: "pageID")
	var sitePage: SitePage
	
	@Parent(key: "objectID")
	var siteObject: SiteObject
	
	init() {}
	
	init(id: UUID? = nil, sitePage: SitePage, siteObject: SiteObject) throws {
		self.id = id
		self.$sitePage.id = try sitePage.requireID()
		self.$siteObject.id = try siteObject.requireID()
	}
}
