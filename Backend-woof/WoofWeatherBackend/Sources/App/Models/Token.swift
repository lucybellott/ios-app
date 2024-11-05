//
//  Token.swift
//  WoofWeatherBackend
//
//  Created by Lucy Bellott on 11/5/24.
//

import Vapor
import Fluent

final class Token: Model, Content {
    static let schema = "tokens"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "value")
    var value: String

    @Parent(key: "userID")
    var user: User

    init() {}

    init(id: UUID? = nil, value: String, userID: UUID) {
        self.id = id
        self.value = value
        self.$user.id = userID
    }
}

// Extension to generate token
extension User {
    func generateToken() throws -> Token {
        let tokenValue = [UInt8].random(count: 16).base64
        return Token(value: tokenValue, userID: try requireID())
    }
}
