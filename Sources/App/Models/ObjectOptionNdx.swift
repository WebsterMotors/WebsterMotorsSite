//
//  ObjectOptionNdx.swift
//  
//
//  Created by Craig Grantham on 8/30/21.
//

import Vapor
import Fluent


final class ObjectOptionNdx: Model, Content {
	
	static let schema = "optionindexs"
	
	
	@ID
	var id: UUID?
	
	
	@Field(key: "siteObjectID")
	var siteObjectID: String

	@Field(key: "objectOptionID")
	var objectOptionID: Int32
	
	@Field(key: "objectOptionNdxID")
	var objectOptionNdxID: String
	
	@OptionalField(key: "objectTemplateID")
	var objectTemplateID: String?
	
	@OptionalField(key: "optionCategoryID")
	var optionCategoryID: String?
	
	@Field(key: "changeToken")
	var changeToken: Int32
	
	
	init() {}
	
	
	init(id: UUID? = nil, siteObjectID: String, objectOptionID: Int32, objectOptionNdxID: String) {
		self.id = id
		self.siteObjectID = siteObjectID
		self.objectOptionID = objectOptionID
		self.objectOptionNdxID = objectOptionNdxID

		self.changeToken = 0
	}
}
