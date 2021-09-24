//
//  ObjectModel.swift
//  
//
//  Created by Craig Grantham on 8/30/21.
//

import Vapor
import Fluent


final class ObjectModel: Model, Content {
	
	static let schema = "sitemodels"
		
	@ID
	var id: UUID?
	
	@Field(key: "name")
	var name: String
	
	@Field(key: "objectModelID")
	var objectModelID: String
	
	@Field(key: "makeID")
	var makeID: String
	
	@Field(key: "changeToken")
	var changeToken: Int32
	
	
	init() {}
	
	
	init(id: UUID? = nil, name: String, objectModelID: String, makeID: String) {
		self.id = id
		self.name = name
		self.objectModelID = objectModelID
		self.makeID = makeID

		self.changeToken = 0
	}
}
