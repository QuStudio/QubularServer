import HTTPServer
import Router
import LogMiddleware
import ContentNegotiationMiddleware
import JSONMediaType
import StandardOutputAppender

import App

assert(Process.arguments.count == 2)
let secretBoardAPIKey = Process.arguments.last!

let logger = Logger(name: "Main", appender: StandardOutputAppender())
let logMiddleware = LogMiddleware(logger: logger)

let router = Router { route in
    route.get("/hello") { _ in
        return Response(body: "hello world")
    }
    route.get("/test/:string") { request in
        guard let string = request.pathParameters["string"] else {
            return Response(status: .internalServerError)
        }
        return Response(body: string.uppercased())
    }
    route.compose(path: "/api", router: apiRouter)
}

try Server(middleware: logMiddleware, responder: router).start()
