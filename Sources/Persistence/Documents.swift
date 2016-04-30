import VocabulaireLib
import MongoKitten

protocol DocumentRepresentable {
    var document: Document { get }
}

protocol DocumentInitializable {
    init(document: Document) throws
}

public enum MKError: ErrorProtocol {
    case somethingIsWrong
}

protocol DocumentConvertible: DocumentRepresentable, DocumentInitializable { }

extension Morpheme: DocumentConvertible {
    var document: Document {
        let document: Document = [
                                     "string": ~view,
                                     "type": ~type.rawValue
        ]
        return document
    }
    init(document: Document) throws {
        guard let string = document["string"].stringValue,
            type = document["type"].stringValue.flatMap({ Kind(rawValue: $0) }) else {
                throw MKError.somethingIsWrong
        }
        self.init(string, type: type)
    }
}

extension NativeLexeme: DocumentConvertible {
    var document: Document {
        let document: Document = [
                                     "lemma": ~lemma.document,
                                     "meaning": ~meaning,
                                     "usage": ~usage.rawValue
        ]
        return document
    }
    init(document: Document) throws {
        guard let lemma = document["lemma"].documentValue.flatMap({ try? Morpheme(document: $0) }),
            meaning = document["meaning"].stringValue,
            usage = document["usage"].stringValue.flatMap({ Usage(rawValue: $0) }) else {
                throw MKError.somethingIsWrong
        }
        self.lemma = lemma
        self.meaning = meaning
        self.usage = usage
    }
}

extension ForeignLexeme: DocumentConvertible {
    var document: Document {
        let document: Document = [
                                     "lemma": ~lemma.document,
                                     "forms": .array(Document(array: forms.map({ Value.document($0.document) }))),
                                     "origin": ~origin.document,
                                     "meaning": ~meaning,
                                     "permissibility": ~permissibility.rawValue
        ]
        return document
    }
    init(document: Document) throws {
        guard let lemma = document["lemma"].documentValue.flatMap({ try? Morpheme(document: $0) }),
            forms = document["forms"].documentValue?.arrayValue.flatMap({ $0.documentValue }).flatMap({ try? Morpheme(document: $0) }),
            origin = document["origin"].documentValue.flatMap({ try? Morpheme(document: $0) }),
            meaning = document["meaning"].stringValue,
            permissibility = document["permissibility"].stringValue.flatMap({ Permissibility(rawValue: $0) }) else {
                throw MKError.somethingIsWrong
        }
        self.lemma = lemma
        self.forms = forms
        self.origin = origin
        self.meaning = meaning
        self.permissibility = permissibility
    }
}

extension User: DocumentConvertible {
    var document: Document {
        let document: Document = [
                                     "id": .int64(Int64(id)),
                                     "username": ~username,
                                     "status": ~status.rawValue
        ]
        return document
    }
    init(document: Document) throws {
        guard let id = document["id"].int64Value,
            username = document["username"].stringValue,
            status = document["status"].stringValue.flatMap({ Status(rawValue: $0) }) else {
                throw MKError.somethingIsWrong
        }
        self.id = Int(id)
        self.username = username
        self.status = status
    }
}

extension Entry: DocumentConvertible {
    var document: Document {
        let document: Document = [
                                     "id": .int64(Int64(id)),
                                     "foreign": .document(foreign.document),
                                     "natives": .array(Document(array: natives.map({ Value.document($0.document) }))),
                                     "author": author?.document != nil ? .document(author!.document) : .nothing
        ]
        return document
    }
    init(document: Document) throws {
        guard let id = document["id"].int64Value,
            foreign = document["foreign"].documentValue.flatMap({ try? ForeignLexeme(document: $0) }),
            natives = document["natives"].documentValue?.arrayValue.flatMap({ $0.documentValue }).flatMap({ try? NativeLexeme(document: $0) }) else {
                throw MKError.somethingIsWrong
        }
        self.id = Int(id)
        self.foreign = foreign
        self.natives = Set(natives)
        self.author = document["author"].documentValue.flatMap({ try? User(document: $0) })
    }
}

