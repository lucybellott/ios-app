//
//  User.swift
//  WoofWeatherBackend
//
//  Created by Lucy Bellott on 11/5/24.
//

import Vapor
import Fluent

final class User: Model, Content {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "email")
    var email: String

    @Field(key: "passwordHash")
    var passwordHash: String

    init() {}

    init(id: UUID? = nil, email: String, passwordHash: String) {
        self.id = id
        self.email = email
        self.passwordHash = passwordHash
    }
}

// Extension for public representation
extension User {
    struct Public: Content {
        var id: UUID?
        var email: String
    }

    func convertToPublic() -> Public {
        return Public(id: id, email: email)
    }
}
