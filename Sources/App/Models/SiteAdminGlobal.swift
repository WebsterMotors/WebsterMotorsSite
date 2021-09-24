//
//  SiteAdminGlobal.swift
//  
//
//  Created by Craig Grantham on 8/30/21.
//

import Vapor
import Fluent


final class SiteAdminGlobal: Model, Content {
	
	static let schema = "appglobals"
	
	
	@ID
	var id: UUID?
	
	
	@Field(key: "appID")
	var appID: String
	
	@Field(key: "lastExteriorColorID")
	var lastExteriorColorID: Int32
	
	@Field(key: "lastInteriorColorID")
	var lastInteriorColorID: Int32
	
	@Field(key: "lastMakeID")
	var lastMakeID: Int32
	
	@Field(key: "lastObjectModelID")
	var lastObjectModelID: Int32
	
	@Field(key: "lastObjectOptionID")
	var lastObjectOptionID: Int32
	
	@Field(key: "lastOptionImageID")
	var lastOptionImageID: Int32
	
	@Field(key: "lastObjectOptionNdxID")
	var lastObjectOptionNdxID: Int32
	
	@Field(key: "lastObjectTemplateID")
	var lastObjectTemplateID: Int32
	
	@Field(key: "lastObjectTypeID")
	var lastObjectTypeID: Int32
	
	@Field(key: "lastOptionCategoryID")
	var lastOptionCategoryID: Int32
	
	@Field(key: "lastSiteObjectID")
	var lastSiteObjectID: Int32
	
	@Field(key: "lastSiteObjectImageID")
	var lastSiteObjectImageID: Int32
	
	@Field(key: "lastWebCatogoryID")
	var lastWebCatogoryID: Int32

	@Field(key: "changeToken")
	var changeToken: Int32
	
	
	init() {}
	
	
	init(id: UUID? = nil, appID: String) {
		self.id = id
		
		self.appID = appID
		
		self.lastExteriorColorID = 0
		self.lastInteriorColorID = 0
		self.lastMakeID = 0
		self.lastObjectModelID = 0
		self.lastObjectOptionID = 0
		self.lastOptionImageID = 0
		self.lastObjectOptionNdxID = 0
		self.lastObjectTemplateID = 0
		self.lastObjectTypeID = 0
		self.lastOptionCategoryID = 0
		self.lastSiteObjectID = 0
		self.lastSiteObjectImageID = 0

		self.lastWebCatogoryID = 0
		
	self.changeToken = 0
	}
}
