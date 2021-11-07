//
//  SitePage.swift
//  
//
//  Created by Craig Grantham on 11/4/21.
//

import Vapor
import Fluent


final class SitePage: Model, Content {
	
	static let schema = "site-pages"
	
	@ID
	var id: UUID?
	
	
	@Field(key: "pageTitle")
	var pageTitle: String				// The displayed page title
	
	@Field(key: "pageName")
	var pageName: String				// The name of the leaf template used for the page
	
	@Field(key: "pageID")
	var pageID: String					// Unique navigation page ID

	@OptionalField(key: "pageNavNames")
	var pageNavNames: [String]?

	// All site objects associated with this page
	//
	@Siblings(
		through: PageObjectPivot.self,
		from: \.$sitePage,
		to: \.$siteObject)
	var siteObjects: [SiteObject]
	
	@Siblings(
		through: PageMakerPivot.self,
		from: \.$sitePage,
		to: \.$objectMake)
	var objectMakes: [ObjectMake]
	
	init() {}
	
	
	init(id: UUID? = nil, pageTitle: String, pageName: String, pageID: String) {
		self.id = id
		
		self.pageTitle = pageTitle
		self.pageName = pageName
		self.pageID = pageID
	}
}
