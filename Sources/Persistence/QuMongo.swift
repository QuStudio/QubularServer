import MongoKitten
import C7
import VocabulaireLib

public class PersistenceController {
    
    let server: Server
    let database: Database
    let entries: MongoKitten.Collection
    
    public init() throws {
        server = try Server("mongodb://username:password@localhost:27017", automatically: true)
        database = server["qubular"]
        entries = database["entries"]
    }
    
    public func insertEntry(_ entry: Entry) throws {
        let document = entry.document
        _ = try entries.insert(document)
    }
    
    public func findAllEntries() throws -> Vocabulary {
        let entriesDocs = try entries.find()
        return entriesDocs.flatMap({ try? Entry(document: $0) })
    }
    
    public func findEntry(for id: Int) throws -> Entry {
        if let matching = try entries.findOne(matching: "id" == id) {
            return try Entry(document: matching)
        } else {
            throw Error.noEntryForGivenID
        }
    }
    
    public func removeEntry(for id: Int) throws {
        try entries.remove(matching: "id" == id)
    }
    
    public enum Error: ErrorProtocol {
        case noEntryForGivenID
    }
    
}
