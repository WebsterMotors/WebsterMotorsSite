import Fluent
import FluentPostgresDriver
import Leaf
import LeafErrorMiddleware
import Vapor

// configures your application
public func configure(_ app: Application) throws {
 
//	let leafMiddleware = LeafErrorMiddleware() { status, error, req -> EventLoopFuture<SomeContext> in
//		return req.eventLoop.future(SomeContext())
//	}
	
	app.middleware.use(LeafErrorMiddlewareDefaultGenerator.build())
	
	// uncomment to serve files from /Public folder
	//
	app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
	
	let corsConfiguration = CORSMiddleware.Configuration(
		allowedOrigin: .all,
		allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
		allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
	)
	
	let corsMiddleware = CORSMiddleware(configuration: corsConfiguration)
	
	app.middleware.use(corsMiddleware)

	if (app.environment == .testing)
	{
		var databaseName: String = "vapor-test"
		var databasePort: Int = 5432
		
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
		if let runEnv = Environment.get("ENV_TYPE")
		{
			let databaseName: String = "vapor-test"
			var databasePort: Int = 5432
			
			if runEnv ==  "Debug"
			{
				if let portNum: String = Environment.get("DATABASE_PORT")
				{
					databasePort = portNum.codingKey.intValue ?? 5432
				}
				
				app.databases.use(.postgres(
					hostname: Environment.get("DATABASE_HOST") ?? "localhost",
					port: databasePort,
					username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
					password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
					database: Environment.get("DATABASE_NAME") ?? databaseName
				), as: .psql)
			}
			
		}
		else
		{
			if let databaseURL = Environment.get("DATABASE_URL"), var postgresConfig = PostgresConfiguration(url: databaseURL) {
				postgresConfig.tlsConfiguration = .forClient(certificateVerification: .none)
				app.databases.use(.postgres(
					configuration: postgresConfig
				), as: .psql)
			}
			else
			{
				fatalError("DATABASE_URL not configured")
			}
		}
	}
		

	app.migrations.add(CreateUser())
	app.migrations.add(CreateExteriorColor())
	app.migrations.add(CreateInteriorColor())
	app.migrations.add(CreateObjectMake())
	app.migrations.add(CreateObjectModel())
	app.migrations.add(CreateOptionItem())
	app.migrations.add(CreateObjectOptionItem())
	app.migrations.add(CreateToken())
	app.migrations.add(CreateObjectType())
	app.migrations.add(CreateOptionCategory())
	app.migrations.add(CreateSiteObjectImage())
	app.migrations.add(CreateSiteObject())
	app.migrations.add(CreateWebsiteCategory())
	app.migrations.add(CreateCategoryList())
	app.migrations.add(CreateSiteAdminGlobal())
	app.migrations.add(CreateAdminUser())
	
	app.migrations.add(CreateSitePage())
	app.migrations.add(CreatePageObjectPivot())
	app.migrations.add(CreatePageMakerPivot())

	app.logger.logLevel = .info
	
	try app.autoMigrate().wait()
	
	app.views.use(.leaf)
	
    // register routes
	//
    try routes(app)
}
