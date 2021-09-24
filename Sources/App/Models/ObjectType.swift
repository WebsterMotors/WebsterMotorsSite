//
//  ObjectType.swift
//  
//
//  Created by Craig Grantham on 8/30/21.
//

import Vapor
import Fluent


final class ObjectType: Model, Content {
	
	static let schema = "objecttypes"
	
	
	@ID
	var id: UUID?
	
	
	@Field(key: "name")
	var name: String
	
	@Field(key: "objectTypeID")
	var objectTypeID: String
	
	@Field(key: "changeToken")
	var changeToken: Int32
	
	
	init() {}
	
	
	init(id: UUID? = nil, name: String, objectTypeID: String) {
	self.id = id
	self.name = name
	self.objectTypeID = objectTypeID
	
	self.changeToken = 0
	}
}
