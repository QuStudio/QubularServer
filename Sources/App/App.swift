import VocabulaireLib
import Persistence
import JSON

public class ApplicationController {

    let persistenceController = try! PersistenceController()
    let serializer = JSONStructuredDataSerializer()
    let version: VocabularyVersion = .develop

    public init() { }
    
    public func addEntry(_ data: StructuredData) throws {
        let entry = try Entry(structuredData: data)
        try persistenceController.insertEntry(entry)
    }
    
    public func getAllEntries() throws -> StructuredData {
        let vocabulary = try persistenceController.findAllEntries()
        return shareVocabulary(vocabulary: vocabulary, with: version)
    }
    
    public func getEntry(for id: Int) throws -> StructuredData {
        let entry = try persistenceController.findEntry(for: id)
        return entry.structuredData
    }
    
    public func removeEntry(for id: Int) throws {
        try persistenceController.removeEntry(for: id)
    }
    
}
