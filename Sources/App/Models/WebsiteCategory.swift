//
//  WebsiteCategory.swift
//  
//
//  Created by Craig Grantham on 8/30/21.
//

import Fluent
import Vapor
import FluentPostgresDriver

final class WebsiteCategory: Model, Content {
	static let schema = "sitecategory"
	
	@ID
	var id: UUID?
	
	@Field(key: "headerDescription")
	var headerDescription: String
	
	@Field(key: "navButtonName")
	var navButtonName: String
	
	@Field(key: "webCatogoryID")
	var webCatogoryID: String
	
	@OptionalField(key: "webCategoryName")
	var webCategoryName: String?

	@Field(key: "navigationOrderNdx")
	var navigationOrderNdx: Int32
	
	@Field(key: "showCategory")
	var showCategory: Bool
	
	@Field(key: "changeToken")
	var changeToken: Int32
	
	
	init() {}
	
	init(id: UUID? = nil, navButtonName: String, webCatogoryID: String, headerDescription: String, navigationOrderNdx: Int32)
	{
		self.navButtonName = navButtonName
		self.webCatogoryID = webCatogoryID
		self.headerDescription = headerDescription
		self.navigationOrderNdx = navigationOrderNdx
		
		self.showCategory = true
		self.changeToken = 0
	}
}
