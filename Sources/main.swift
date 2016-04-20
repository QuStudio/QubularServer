import HTTPServer
import Router
import LogMiddleware
import ContentNegotiationMiddleware
import JSONMediaType
import VocabulaireLib

//let logger = Logger(name: "Main", appender: StandartOutputAppender)

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
}

try Server(responder: router).start()
