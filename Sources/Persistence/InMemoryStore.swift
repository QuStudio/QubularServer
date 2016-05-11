import VocabulaireLib
import File
import JSONMediaType

public class InMemoryPersistenceController: PersistenceController {
    
    let file: File
    let parser = JSONStructuredDataParser()
    let serializer = JSONStructuredDataSerializer()
    
    private var vocabulary: Vocabulary
    
    public init(loadFrom file: File) throws {
        self.file = file
        let rawData = try file.readAllBytes()
        let structures = try parser.parse(rawData)
        if let vocabulary = structures.array.map({ $0.flatMap({ try? Entry(structuredData: $0) }) }) {
            self.vocabulary = vocabulary
        } else {
            throw Error.invalidJSON
        }
    }
//    
//    deinit {
//        do { try self.save() } catch { }
//    }
    
    public func save() throws {
        let data = shareVocabulary(vocabulary: vocabulary, with: VocabularyVersion.develop)
        let rawData = try serializer.serialize(data)
        try file.write(rawData, flushing: true)
    }
    
    public func insertEntry(_ entry: Entry) throws {
        vocabulary.append(entry)
        try self.save()
    }
    
    public func findAllEntries() throws -> Vocabulary {
        return vocabulary
    }
    
    public func findEntry(forID id: Int) throws -> Entry {
        return try vocabulary.filter({ $0.id == id }).first.tryUnwrap()
    }
    
    public func removeEntry(forID id: Int) throws {
        let index = try vocabulary.index(where: ({ $0.id == id })).tryUnwrap()
        vocabulary.remove(at: index)
    }
    
}

extension InMemoryPersistenceController {
    public enum Error: ErrorProtocol {
        case invalidJSON
    }
}

extension Optional {
    func tryUnwrap() throws -> Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            throw UnwrapError.nilValue
        }
    }
}

public enum UnwrapError: ErrorProtocol {
    case nilValue
}
