//
//  ObjectOptionItem.swift
//  
//
//  Created by Craig Grantham on 8/30/21.
//

import Vapor
import Fluent


final class ObjectOptionItem: Model, Content {
	
	static let schema = "objectoptions"
	
	
	@ID
	var id: UUID?
	
	
	@Field(key: "objectOptionID")
	var objectOptionID: String

	@Field(key: "siteObjectID")
	var siteObjectID: String

	@Field(key: "optionItemID")
	var optionItemID: String
	
	@Field(key: "optionName")
	var optionName: String
	
	@Field(key: "optionCategoryID")
	var optionCategoryID: String
	
	@OptionalField(key: "objectTemplateID")
	var objectTemplateID: String?

	@Field(key: "changeToken")
	var changeToken: Int32
	
	
	init() {}
	
	
	init(id: UUID? = nil, objectOptionID: String, siteObjectID: String, optionItemID: String, optionName: String, optionCategoryID: String) {
		
		self.id = id
		self.objectOptionID = objectOptionID
		self.siteObjectID = siteObjectID
		self.optionItemID = optionItemID
		self.optionName = optionName
		self.optionCategoryID = optionCategoryID

		self.changeToken = 0
	}
}
