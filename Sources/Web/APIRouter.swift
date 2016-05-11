import Router
import JSONMediaType
import ContentNegotiationMiddleware
import StandardOutputAppender
import S4
import App

let qubular = try! ApplicationController()

let accessMiddleware = AccessMiddleware()
let contentNegotiator = ContentNegotiationMiddleware(mediaTypes: [JSONMediaType()])

let apiRouter = Router(middleware: accessMiddleware, contentNegotiator) { route in
	route.get("/entries") { request in
		print("here")
		let vocabulary = try qubular.getAllEntries()
		return Response(content: vocabulary)
	}
	route.post("/entry") { request in
		print("here")
		guard let content = request.content else {
			return Response(status: .badRequest)
		}
		try qubular.addEntry(content)
		return Response(body: "Thanks, we appreciate that (for now)")
	}
	route.get("/entries/:id") { request in
		guard let stringId = request.pathParameters["id"], id = Int(stringId) else {
			return Response(status: .badRequest)
		}
		let entry = try qubular.getEntry(forID: id)
		return Response(content: entry)
	}
}
