import HTTPServer
import Router
import LogMiddleware
import ContentNegotiationMiddleware
import JSONMediaType
import VocabulaireLib
import StandardOutputAppender

let logger = Logger(name: "Main", appender: StandardOutputAppender())
let logMiddleware = LogMiddleware(logger: logger)

var vocabulary: Vocabulary = []

let contentNegotiator = ContentNegotiationMiddleware(mediaTypes: [JSONMediaType()])

let router = Router(middleware: contentNegotiator) { route in
    route.get("/hello") { _ in
        return Response(body: "hello world")
    }
    route.post("/user") { request in
    	if let content = request.content, user = User.makeWith(structuredData: content) {
    		print(user)
    		return Response(body: String(content))
    	}
    	return Response(body: "Fuck off")
    }
    route.post("/entry") { request in
    	if let content = request.content, entry = Entry.makeWith(structuredData: content) {
    		print(entry)
    		vocabulary.append(entry)
    		return Response(body: String(content))
    	}
    	return Response(body: "Fuck off")
    }
    route.post("/debugEntry") { request in
        guard let content = request.content else {
            return Response(body: "No content")
        }
        let map = Mapper(structuredData: content)
        let entry = try! Entry(mapper: map)
        print(entry)
        vocabulary.append(entry)
        return Response(body: String(entry))
    }
    route.post("/morpheme") { request in
        guard let content = request.content, morpheme = Morpheme.makeWith(structuredData: content) else {
            return Response(body: "No")
        }
        print(morpheme)
        return Response(body: "Yes")
    }
    route.get("/test/:string") { request in
        guard let string = request.pathParameters["string"] else {
            return Response(status: .internalServerError)
        }
        return Response(body: string.uppercased())
    }
}

try Server(middleware: logMiddleware, responder: router).start()
