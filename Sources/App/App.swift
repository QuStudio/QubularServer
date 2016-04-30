import VocabulaireLib
import Persistence
import JSON

public class ApplicationController {

    let persistenceController = try! PersistenceController()
    let serializer = JSONStructuredDataSerializer()
    
    public init() { }
    
    public func addEntry(_ entry: Vocabulaire.Entry) throws {
        try persistenceController.insertEntry(entry)
    }
    
    public func getAllEntries() throws -> StructuredData {
        let vocabulary = try persistenceController.findAllEntries()
        return StructuredData.from(vocabulary.map({ $0.structuredData }))
    }
    
    public func getEntry(for id: Int) throws -> StructuredData {
        let entry = try persistenceController.findEntry(for: id)
        return entry.structuredData
    }
    
    public func removeEntry(for id: Int) throws {
        try persistenceController.removeEntry(for: id)
    }
    
}
