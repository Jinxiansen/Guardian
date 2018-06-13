import FluentSQLite
import Vapor
import Guardian
import Leaf

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentSQLiteProvider())

    // Leaf
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    
    
    
    // After running, you can check the effect by visiting http://localhost:8080/guardian and refreshing it twice.
    // 运行后，你可以通过访问 http://localhost:8080/guardian  并刷新2次查看效果。
    
    // Example 1:
    middlewares.use(GuardianMiddleware.init(rate: Rate.init(limit: 2, interval: .minute), closure: { (req) -> EventLoopFuture<Response>? in
        return try req.view().render("leaf/loader").encode(for: req)
    }))
    
    //Example 2:
    //middlewares.use(GuardianMiddleware.init(rate: Rate.init(limit: 2, interval: .minute), closure: { (req) -> EventLoopFuture<Response>? in
    //  return try ["error":"999","message":"Too many visits! 🤪🤪🤪"].encode(for: req)
    //}))

    
    // or other ...😁😁😁
    
    
    services.register(middlewares)

    // Configure a SQLite database
    let sqlite = try SQLiteDatabase(storage: .memory)

    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Todo.self, database: .sqlite)
    services.register(migrations)

}
