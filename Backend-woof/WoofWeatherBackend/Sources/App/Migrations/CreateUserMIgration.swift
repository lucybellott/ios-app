//
//  CreateUserMIgration.swift
//  WoofWeatherBackend
//
//  Created by Lucy Bellott on 11/5/24.
//

import Fluent

struct CreateUserMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("email", .string, .required)
            .field("passwordHash", .string, .required)
            .unique(on: "email")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
