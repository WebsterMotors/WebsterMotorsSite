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
	
	@Field(key: "nextOptionID")
	var nextOptionID: Int32

	@Field(key: "displayNdx")
	var displayNdx: Int32

	@Field(key: "changeToken")
	var changeToken: Int32
	
	
	init() {}
	
	
	init(id: UUID? = nil, categoryName: String, optionCategoryID: String, nextOptionID: Int32, displayNdx: Int32) {
		self.id = id
		self.categoryName = categoryName
		self.optionCategoryID = optionCategoryID
		self.nextOptionID = nextOptionID
		self.displayNdx = displayNdx

		self.changeToken = 0
	}
}
