//
//  ObjectOption.swift
//  
//
//  Created by Craig Grantham on 8/30/21.
//

import Vapor
import Fluent


final class OptionItem: Model, Content {
	
	static let schema = "optionitems"
	
	
	@ID
	var id: UUID?
	
	
	@Field(key: "optionItemID")
	var optionItemID: String
	
	@Field(key: "optionCategoryID")
	var optionCategoryID: String
	
	@Field(key: "optionName")
	var optionName: String
	
	@OptionalField(key: "optionImageID")
	var optionImageID: String?
	
	@Field(key: "changeToken")
	var changeToken: Int32
	
	
	init() {}
	
	
	init(id: UUID? = nil, optionName: String, optionItemID: String, optionCategoryID: String) {
		self.id = id
		self.optionName = optionName
		self.optionItemID = optionItemID
		self.optionCategoryID = optionCategoryID

		self.changeToken = 0
	}
}
