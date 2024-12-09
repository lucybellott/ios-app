import Vapor
import Fluent

struct FavoritesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tokenProtected = routes.grouped(Token.authenticator(), Token.guardMiddleware())
        // POST /favorites to add a new favorite city
        tokenProtected.post("favorites", use: addFavorite)
        // GET /favorites to list all favorite cities
        tokenProtected.get("favorites", use: listFavorites)
    }

    func addFavorite(req: Request) throws -> EventLoopFuture<FavoriteCity> {
        let user = try req.auth.require(User.self) // Authenticated user
        let data = try req.content.decode(AddFavoriteData.self)
        let favorite = FavoriteCity(cityName: data.cityName, userID: try user.requireID())
        return favorite.save(on: req.db).map { favorite }
    }


    func listFavorites(req: Request) throws -> EventLoopFuture<[FavoriteCity]> {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID() // Get the ID
        return FavoriteCity.query(on: req.db)
            .filter(\.$user.$id == userID) //use userID
            .all()
    }

}

struct AddFavoriteData: Content {
    let cityName: String
}

