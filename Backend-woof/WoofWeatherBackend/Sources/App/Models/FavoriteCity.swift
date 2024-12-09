import Vapor
import Fluent

final class FavoriteCity: Model, Content {
    static let schema = "favorite_cities"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "cityName")
    var cityName: String

    @Parent(key: "userID")
    var user: User

    init() {}

    init(id: UUID? = nil, cityName: String, userID: UUID) {
        self.id = id
        self.cityName = cityName
        self.$user.id = userID
    }
}

