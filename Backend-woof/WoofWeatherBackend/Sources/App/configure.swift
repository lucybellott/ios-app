
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
    app.migrations.add(CreateFavoriteCityMigration())


    
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
