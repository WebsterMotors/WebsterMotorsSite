//
//  OptionCategory.swift
//  
//
//  Created by Craig Grantham on 8/30/21.
//

import Vapor
import Fluent


final class OptionCategory: Model, Content {
	
	static let schema = "optioncategories"
	
	
	@ID
	var id: UUID?
	
	
	@Field(key: "categoryName")
	var categoryName: String
	
	@Field(key: "optionCategoryID")
	var optionCategoryID: String

	@Field(key: "displayNdx")
	var displayNdx: Int32

	@OptionalField(key: "nextDisplayNdx")
	var nextDisplayNdx: Int32?

	@Field(key: "changeToken")
	var changeToken: Int32
	
	
	init() {}
	
	
	init(id: UUID? = nil, categoryName: String, optionCategoryID: String, displayNdx: Int32) {
		self.id = id
		self.categoryName = categoryName
		self.optionCategoryID = optionCategoryID
		self.displayNdx = displayNdx

		self.changeToken = 0
	}
}
