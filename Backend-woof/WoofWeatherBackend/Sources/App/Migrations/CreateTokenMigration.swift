//
//  CreateTokenMigration.swift
//  WoofWeatherBackend
//
//  Created by Lucy Bellott on 11/5/24.
//

import Fluent

struct CreateTokenMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tokens")
            .id()
            .field("value", .string, .required)
            .field("userID", .uuid, .required, .references("users", "id"))
            .unique(on: "value")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tokens").delete()
    }
}
