//
//  PageMakerPivot.swift
//  
//
//  Created by Craig Grantham on 11/4/21.
//

import Vapor
import Fluent


final class PageMakerPivot: Model {
	
	static let schema = "page-maker-pivot"
	
	@ID
	var id: UUID?
	
	@Parent(key: "pageID")
	var sitePage: SitePage
	
	@Parent(key: "makeID")
	var objectMake: ObjectMake
	
	init() {}
	
	init(id: UUID? = nil, sitePage: SitePage, objectMake: ObjectMake) throws {
		self.id = id
		self.$sitePage.id = try sitePage.requireID()
		self.$objectMake.id = try objectMake.requireID()
	}
}
