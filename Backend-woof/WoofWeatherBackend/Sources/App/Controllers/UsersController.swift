
import Vapor
import Fluent

struct UsersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("signup", use: signup)
        routes.post("login", use: login)
        routes.get("users", use: getAllUsers)
    }

    func signup(req: Request) throws -> EventLoopFuture<User.Public> {
        let createUser = try req.content.decode(CreateUser.self)
        guard createUser.password == createUser.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords do not match.")
        }
        let passwordHash = try Bcrypt.hash(createUser.password)
        let user = User(email: createUser.email, passwordHash: passwordHash)
        return user.save(on: req.db).map {
            user.convertToPublic()
        }
    }

    func login(req: Request) throws -> EventLoopFuture<Token> {
        let userLogin = try req.content.decode(UserLogin.self)
        return User.query(on: req.db)
            .filter(\.$email == userLogin.email)
            .first()
            .unwrap(or: Abort(.unauthorized))
            .flatMap { user in
                do {
                    if try Bcrypt.verify(userLogin.password, created: user.passwordHash) {
                        let token = try user.generateToken()
                        return token.save(on: req.db).map { token }
                    } else {
                        return req.eventLoop.makeFailedFuture(Abort(.unauthorized))
                    }
                } catch {
                    return req.eventLoop.makeFailedFuture(error)
                }
            }
    }
    
    func getAllUsers(req: Request) throws -> EventLoopFuture<[User.Public]> {
        return User.query(on: req.db).all().map { users in
            users.map { $0.convertToPublic() }
        }
    }

}

// Request DTOs
struct CreateUser: Content {
    var email: String
    var password: String
    var confirmPassword: String
}

struct UserLogin: Content {
    var email: String
    var password: String
}
