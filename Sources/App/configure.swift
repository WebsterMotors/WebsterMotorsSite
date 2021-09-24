import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
     app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
	
	let databaseName: String
	let databasePort: Int
	
	if (app.environment == .testing)
	{
		databaseName = "vapor-test"
		if let testPort = Environment.get("DATABASE_PORT")
		{
			databasePort = Int(testPort) ?? 5433
		}
		else
		{
			databasePort = 5433
		}
	}
	else
	{
		databaseName = "vapor_database"
		databasePort = 5432
	}
	
	app.databases.use(.postgres(
		hostname: Environment.get("DATABASE_HOST") ?? "localhost",
		port: databasePort,
		username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
		password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
		database: Environment.get("DATABASE_NAME") ?? databaseName
	), as: .psql)

	app.migrations.add(CreateUser())
	app.migrations.add(CreateExteriorColor())
	app.migrations.add(CreateInteriorColor())
	app.migrations.add(CreateObjectMake())
	app.migrations.add(CreateObjectModel())
	app.migrations.add(CreateObjectOption())
	app.migrations.add(CreateObjectOptionNdx())
	app.migrations.add(CreateToken())
	app.migrations.add(CreateObjectType())
	app.migrations.add(CreateOptionCategory())
	app.migrations.add(CreateSiteObjectImage())
	app.migrations.add(CreateSiteObject())
	app.migrations.add(CreateWebsiteCategory())
	app.migrations.add(CreateSiteAdminGlobal())
	app.migrations.add(CreateAdminUser())

	app.logger.logLevel = .info
	
	try app.autoMigrate().wait()
	
	app.views.use(.leaf)
	
    // register routes
	//
    try routes(app)
}
