//
//  ExteriorColor.swift
//  
//
//  Created by Craig Grantham on 8/24/21.
//

import Vapor
import Fluent


final class ExteriorColor: Model, Content {

	static let schema = "exteriorcolors"
	

	@ID
	var id: UUID?
	

	@Field(key: "name")
	var name: String
	
	@Field(key: "exteriorColorID")
	var exteriorColorID: String
	
	@OptionalField(key: "optionImageID")
	var optionImageID: String?
	
	@Field(key: "changeToken")
	var changeToken: Int32


	init() {}
	

	init(id: UUID? = nil, name: String, exteriorColorID: String) {
		self.id = id
		self.name = name
		self.exteriorColorID = exteriorColorID
		
		self.changeToken = 0
	}
}
