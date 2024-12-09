
import Vapor

func routes(_ app: Application) throws {
    let usersController = UsersController()
    try app.register(collection: usersController)
    
    let favoritesController = FavoritesController()
    try app.register(collection: favoritesController)
}
