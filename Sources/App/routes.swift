import Fluent
import Vapor
import Leaf


func routes(_ app: Application) throws {
	
//    app.get { req in
//        return req.view.render("index", ["title": "Hello Vapor!"])
//    }

	let websiteController = WebsiteController()
	try app.register(collection: websiteController)
	
	let categoryController = WebsiteCategoryController()
	try app.register(collection: categoryController)
	
	let extColorController = ExteriorColorController()
	try app.register(collection: extColorController)
	
	let intColorController = InteriorColorController()
	try app.register(collection: intColorController)
	
	let mfgController = ObjectMakeController()
	try app.register(collection: mfgController)
	
	let objController = ObjectModelController()
	try app.register(collection: objController)
	
	let objOptionController = OptionItemController()
	try app.register(collection: objOptionController)
	
	let optionNdxController = ObjectOptionItemController()
	try app.register(collection: optionNdxController)
	
	let objTypeController = ObjectTypeController()
	try app.register(collection: objTypeController)
	
	let optCategoryController = OptionCategoryController()
	try app.register(collection: optCategoryController)
	
	let objImageController = SiteObjectImageController()
	try app.register(collection: objImageController)
	
	let objectController = SiteObjectController()
	try app.register(collection: objectController)
	
	let objectCatListController = ObjectCategoryListController()
	try app.register(collection: objectCatListController)

	let usersController = UsersController()
	try app.register(collection: usersController)

}
