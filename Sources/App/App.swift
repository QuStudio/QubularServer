import VocabulaireLib
import Persistence
import JSON
import File

public class ApplicationController {
    
    let persistenceController: PersistenceController
    let serializer = JSONStructuredDataSerializer()
    let version: VocabularyVersion = .develop

    public init() throws {
        let pwd = try File.workingDirectory()
        let entriesFilePath = pwd + "/Resources/entries.json"
        print(entriesFilePath)
        let file = try File(path: entriesFilePath, mode: .readWrite)
        print(file)
        persistenceController = try InMemoryPersistenceController(loadFrom: file)
    }
    
    public func addEntry(_ data: StructuredData) throws {
        let entry = try Entry(structuredData: data)
        try persistenceController.insertEntry(entry)
    }
    
    public func getAllEntries() throws -> StructuredData {
        let vocabulary = try persistenceController.findAllEntries()
        return shareVocabulary(vocabulary: vocabulary, with: version)
    }
    
    public func getEntry(forID id: Int) throws -> StructuredData {
        let entry = try persistenceController.findEntry(forID: id)
        return entry.structuredData
    }
    
    public func removeEntry(forID id: Int) throws {
        try persistenceController.removeEntry(forID: id)
    }
    
    public func getVersion() -> StructuredData {
        return version.structuredData
    }
    
}
