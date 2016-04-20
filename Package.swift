import PackageDescription

let package = Package(
    name: "QubularServer",
    dependencies: [
    	.Package(url: "https://github.com/QuStudio/VocabulaireLib.git", majorVersion: 0, minor: 2),
    	.Package(url: "https://github.com/Zewo/HTTPServer.git", majorVersion: 0, minor: 5),
    	.Package(url: "https://github.com/Zewo/Router.git", majorVersion: 0, minor: 5),
    	.Package(url: "https://github.com/Zewo/LogMiddleware.git", majorVersion: 0, minor: 5),
    	.Package(url: "https://github.com/Zewo/ContentNegotiationMiddleware.git", majorVersion: 0, minor: 5),
    	.Package(url: "https://github.com/Zewo/JSONMediaType.git", majorVersion: 0, minor: 5),
    ]
)