//import NIOSSL
//import Fluent
//import FluentSQLiteDriver
//import Vapor

//// configures your application
//public func configure(_ app: Application) async throws {
//    // uncomment to serve files from /Public folder
//    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
//
//    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)
//
//
//
//  ///  app.migrations.add(CreateTodo())
//    // register routes
//    try routes(app)
//}
import Vapor
import Fluent
import FluentSQLiteDriver

public func configure(_ app: Application) throws {
    // MARK: - Database Configuration

    // Use SQLite database
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    
    // Add migrations
    app.migrations.add(CreateUserMigration())
    app.migrations.add(CreateTokenMigration())
    
    // MARK: - Middleware

    // Serve files from the Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // CORS Configuration
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    app.middleware.use(cors)
    
    // MARK: - Routes

    // Register routes
    try routes(app)
}
