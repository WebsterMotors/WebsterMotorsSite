//
//  ObjectOption.swift
//  
//
//  Created by Craig Grantham on 8/30/21.
//

import Vapor
import Fluent


final class ObjectOption: Model, Content {
	
	static let schema = "modeloptions"
	
	
	@ID
	var id: UUID?
	
	
	@Field(key: "objectOptionID")
	var objectOptionID: Int32
	
	@Field(key: "optionCategoryID")
	var optionCategoryID: String
	
	@Field(key: "optionDescription")
	var optionDescription: String
	
	@OptionalField(key: "displayNdx")
	var displayNdx: Int32?
	
	@OptionalField(key: "optionImageID")
	var optionImageID: String?
	
	@Field(key: "changeToken")
	var changeToken: Int32
	
	
	init() {}
	
	
	init(id: UUID? = nil, optionDescription: String, objectOptionID: Int32, optionCategoryID: String) {
		self.id = id
		self.optionDescription = optionDescription
		self.objectOptionID = objectOptionID
		self.optionCategoryID = optionCategoryID

		self.displayNdx = 0
		self.changeToken = 0
	}
}
