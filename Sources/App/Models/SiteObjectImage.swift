//
//  SiteObjectImage.swift
//  
//
//  Created by Craig Grantham on 8/30/21.
//

import Vapor
import Fluent


final class SiteObjectImage: Model, Content {
	
	static let schema = "objectimages"
	
	
	@ID
	var id: UUID?
	

	@Field(key: "siteObjectID")
	var siteObjectID: String
	
	@Field(key: "siteObjectImageID")
	var siteObjectImageID: String
	
	@Field(key: "fileName")
	var fileName: String

	@Field(key: "photoNdx")
	var photoNdx: Int32
	
	@OptionalField(key: "caption")
	var caption: String?
	
	@OptionalField(key: "awsBucketURL")
	var awsBucketURL: String?
	
	@OptionalField(key: "cloudServerID")
	var cloudServerID: Int32?
	
	@OptionalField(key: "awsKey")
	var awsKey: String?

	@Field(key: "changeToken")
	var changeToken: Int32
	
	
	init() {}
	
	
	init(id: UUID? = nil, siteObjectID: String, siteObjectImageID: String, fileName: String, photoNdx: Int32) {
		self.id = id
		self.siteObjectID = siteObjectID
		self.siteObjectImageID = siteObjectImageID
		self.fileName = fileName
		self.photoNdx = photoNdx
		
		self.changeToken = 0
	}
}
