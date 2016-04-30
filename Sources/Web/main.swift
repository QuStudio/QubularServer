import HTTPServer
import Router
import LogMiddleware
import ContentNegotiationMiddleware
import JSONMediaType
import StandardOutputAppender

import App

let logger = Logger(name: "Main", appender: StandardOutputAppender())
let logMiddleware = LogMiddleware(logger: logger)

let qubular = ApplicationController()

let contentNegotiator = ContentNegotiationMiddleware(mediaTypes: [JSONMediaType()])

let router = Router(middleware: contentNegotiator) { route in
    route.get("/hello") { _ in
        return Response(body: "hello world")
    }
    route.get("/test/:string") { request in
        guard let string = request.pathParameters["string"] else {
            return Response(status: .internalServerError)
        }
        return Response(body: string.uppercased())
    }
}

try Server(middleware: logMiddleware, responder: router).start()
