//
//  ObjectCategoryList.swift
//  
//
//  Created by Craig Grantham on 9/27/21.
//

import Vapor
import Fluent


final class ObjectCategoryList: Model, Content {
	
	static let schema = "categorylists"
	
	
	@ID
	var id: UUID?
	
	@Field(key: "optionCategoryID")
	var optionCategoryID: String
	
	@Field(key: "categoryName")
	var categoryName: String
	
	@Field(key: "siteObjectID")
	var siteObjectID: String
	
	@Field(key: "categoryListID")
	var categoryListID: String
	
	@Field(key: "itemsList")
	var itemsList: String

	@OptionalField(key: "displayNdx")
	var displayNdx: Int32?

	init() {}
	
	
	init(id: UUID? = nil, categoryName: String, optionCategoryID: String, siteObjectID: String, categoryListID: String, itemsList: String) {
		self.id = id
		self.categoryName = categoryName
		self.optionCategoryID = optionCategoryID
		self.siteObjectID = siteObjectID
		self.categoryListID = categoryListID
		self.itemsList = itemsList
	}
}
