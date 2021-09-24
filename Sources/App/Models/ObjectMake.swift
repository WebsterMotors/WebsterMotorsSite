//
//  ObjectMake.swift
//  
//
//  Created by Craig Grantham on 8/30/21.
//

import Vapor
import Fluent


final class ObjectMake: Model, Content {
	
	static let schema = "makes"
	
	
	@ID
	var id: UUID?
	
	@Field(key: "name")
	var name: String
	
	@Field(key: "makeID")
	var makeID: String

	@OptionalField(key: "pageName")
	var pageName: String?

	@OptionalField(key: "optionImageID")
	var optionImageID: String?
	
	@OptionalField(key: "tagLine")
	var tagLine: String?

	@OptionalField(key: "makeSiteURL")
	var makeSiteURL: String?

	@OptionalField(key: "logoImageURL")
	var logoImageURL: String?

	@Field(key: "changeToken")
	var changeToken: Int32
	
	
	init() {}
	
	
	init(id: UUID? = nil, name: String, makeID: String) {
		self.id = id
		self.name = name
		self.makeID = makeID
		
		self.changeToken = 0
	}
}
