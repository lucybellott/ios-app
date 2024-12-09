//import Vapor
//import Fluent
//
//struct FavoritesController: RouteCollection {
//    func boot(routes: RoutesBuilder) throws {
//        let tokenProtected = routes.grouped(Token.authenticator(), Token.guardMiddleware())
//        // POST /favorites to add a new favorite city
//        tokenProtected.post("favorites", use: addFavorite)
//        // GET /favorites to list all favorite cities
//        tokenProtected.get("favorites", use: listFavorites)
//    }
//
//    func addFavorite(req: Request) throws -> EventLoopFuture<FavoriteCity> {
//        let user = try req.auth.require(User.self) // Authenticated user
//        let data = try req.content.decode(AddFavoriteData.self)
//        let favorite = FavoriteCity(cityName: data.cityName, userID: try user.requireID())
//        return favorite.save(on: req.db).map { favorite }
//    }
//
//
//    func listFavorites(req: Request) throws -> EventLoopFuture<[FavoriteCity]> {
//        let user = try req.auth.require(User.self)
//        let userID = try user.requireID() // Get the ID
//        return FavoriteCity.query(on: req.db)
//            .filter(\.$user.$id == userID) //use userID
//            .all()
//    }
//
//}
//
//struct AddFavoriteData: Content {
//    let cityName: String
//}
//

import Vapor
import Fluent

struct FavoritesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        // POST /favorites to add a new favorite city
        routes.post("favorites", use: addFavorite)
        // GET /favorites to list all favorite cities for a user
        routes.get("favorites", use: listFavorites)
    }

    func addFavorite(req: Request) throws -> EventLoopFuture<FavoriteCity> {
        let data = try req.content.decode(AddFavoriteData.self)
        
        // Find user by email, if not found return error
        return User.query(on: req.db)
            .filter(\.$email == data.email)
            .first()
            .unwrap(or: Abort(.badRequest, reason: "User not found"))
            .flatMap { user in
                do {
                    let favorite = FavoriteCity(cityName: data.cityName, userID: try user.requireID())
                    return favorite.save(on: req.db).map { favorite }
                } catch {
                    return req.eventLoop.makeFailedFuture(error)
                }
            }
    }

    func listFavorites(req: Request) throws -> EventLoopFuture<[FavoriteCity]> {
        // Require email in query params
        guard let email = req.query[String.self, at: "email"] else {
            throw Abort(.badRequest, reason: "email query parameter required")
        }

        // Find user by email and return their favorites
        return User.query(on: req.db)
            .filter(\.$email == email)
            .first()
            .unwrap(or: Abort(.badRequest, reason: "User not found"))
            .flatMap { user in
                FavoriteCity.query(on: req.db)
                    .filter(\.$user.$id == user.id!)
                    .all()
            }
    }
}

struct AddFavoriteData: Content {
    let cityName: String
    let email: String
}

