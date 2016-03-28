import HTTPServer
import Router
import LogMiddleware
import ContentNegotiationMiddleware
import JSONMediaType
import VocabulaireLinux
// import Topo

let log = Log()
let logger = LogMiddleware(log: log)

let vocabulary: Vocabulary = []

let contentNegotiator = ContentNegotiationMiddleware(mediaTypes: JSONMediaType())

let router = Router(middleware: contentNegotiator) { route in
    route.get("/hello") { _ in
        return Response(body: "hello world")
    }
    route.post("/user") { request in
    	if let content = request.content, user = User.from(content) {
    		print(user)
    		return Response(body: String(content))
    	}
    	return Response(body: "Fuck off")
    }
    route.post("/entry") { request in
    	if let content = request.content, entry = Entry.from(content) {
    		print(entry)
    		vocabulary.append(entry)
    		return Response(body: String(content))
    	}
    	return Response(body: "Fuck off")
    }
}

try Server(middleware: logger, responder: router).start()