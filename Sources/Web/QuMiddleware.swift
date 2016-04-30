import S4

let secretBoardAPIKey = "Pi6o7c3hQp483fP1yXPJtA8oNh1rg07b"

struct AccessMiddleware: Middleware {
	func respond(to request: Request, chainingTo chain: Responder) throws -> Response {
		let deniedResponse = Response(status: .forbidden)
		switch request.method {
		case .get:
			return try chain.respond(to: request)
		default:
			guard let boardApiKey = request.headers["access-key"].first else {
				return deniedResponse
			}
			if boardApiKey == secretBoardAPIKey {
				return try chain.respond(to: request)
			} else {
				return deniedResponse
			}
		}
	}
}
