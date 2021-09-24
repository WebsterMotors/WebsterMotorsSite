//
//  SiteObject.swift
//  
//
//  Created by Craig Grantham on 8/30/21.
//

import Vapor
import Fluent


final class SiteObject: Model, Content {
	
	static let schema = "siteobjects"
	
	
	@ID
	var id: UUID?
	
	
	@Field(key: "siteObjectID")
	var siteObjectID: String
	
	@Field(key: "webCatogoryID")
	var webCatogoryID: String
	
	@Field(key: "objectModelID")
	var objectModelID: String
	
	@Field(key: "modelName")
	var modelName: String

	@Field(key: "objectTypeID")
	var objectTypeID: String
	
	@Field(key: "typeName")
	var typeName: String

	@Field(key: "makeID")
	var makeID: String

	@Field(key: "featureInfo")
	var featureInfo: String
	
	@OptionalField(key: "vinNumber")
	var vinNumber: String?

	@OptionalField(key: "modelYear")
	var modelYear: Int32?

	@OptionalField(key: "numDoors")
	var numDoors: Int32?

	@OptionalField(key: "mileage")
	var mileage: String?

	@OptionalField(key: "listPrice")
	var listPrice: String?
	
	@OptionalField(key: "reducedPrice")
	var reducedPrice: String?

	@OptionalField(key: "objectDescription")
	var objectDescription: String?

	@Field(key: "hideListing")
	var hideListing: Bool

	@Field(key: "showInSpecials")
	var showInSpecials: Bool
	
	@OptionalField(key: "exteriorColorID")
	var exteriorColorID: String?
	
	@OptionalField(key: "exteriorColor")
	var exteriorColor: String?

	@OptionalField(key: "interiorColorID")
	var interiorColorID: String?

	@OptionalField(key: "interiorColor")
	var interiorColor: String?

	@OptionalField(key: "nextPhotoNdx")
	var nextPhotoNdx: Int32?

	@Field(key: "changeToken")
	var changeToken: Int32

	@OptionalField(key: "objectImages")
	var objectImages: [String]?

	
	init() {}
	
	
	init(id: UUID? = nil, featureInfo: String, siteObjectID: String, webCatogoryID: String, objectModelID: String) {
		self.id = id
		
		self.siteObjectID = siteObjectID
		self.featureInfo = featureInfo
		self.webCatogoryID = webCatogoryID
		self.objectModelID = objectModelID
		
		self.hideListing = false
		self.showInSpecials = false
		self.changeToken = 0
	}
}
