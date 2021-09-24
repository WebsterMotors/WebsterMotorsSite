//
//  InteriorColor.swift
//  
//
//  Created by Craig Grantham on 8/30/21.
//

import Vapor
import Fluent


final class InteriorColor: Model, Content {
	
	static let schema = "interiorcolors"
	
	
	@ID
	var id: UUID?
	
	
	@Field(key: "name")
	var name: String
	
	@Field(key: "interiorColorID")
	var interiorColorID: String
	
	@OptionalField(key: "optionImageID")
	var optionImageID: String?
	
	@Field(key: "changeToken")
	var changeToken: Int32
	
	
	init() {}
	
	
	init(id: UUID? = nil, name: String, interiorColorID: String) {
		self.id = id
		self.name = name
		self.interiorColorID = interiorColorID
		
		self.changeToken = 0
	}
}
