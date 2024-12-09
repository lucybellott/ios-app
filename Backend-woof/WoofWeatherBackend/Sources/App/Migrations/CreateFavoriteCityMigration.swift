import Fluent

struct CreateFavoriteCityMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("favorite_cities")
            .id()
            .field("cityName", .string, .required)
            .field("userID", .uuid, .required, .references("users", "id"))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("favorite_cities").delete()
    }
}

