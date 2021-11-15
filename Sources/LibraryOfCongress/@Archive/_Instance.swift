//
//  Instance.swift
//  
//
//  Created by Ian Sampson on 2021-11-13.
//

/*import Foundation

public struct Instance {
    public let identifiers: [Bibframe.IdentifierType: String]
    public let contributors: Contributors
}

extension Instance: Decodable {
    public init(from decoder: Decoder) throws {
        var identifiers: [Bibframe.IdentifierType: String] = [:]
        
        var container = try decoder.unkeyedContainer()
        var contributors = Contributors()
        
        while let nestedContainer = try? container.nestedContainer(keyedBy: Bibframe.CodingKeys.self) {
            guard let types = try? nestedContainer.decode([Bibframe.Class].self, forKey: .rdf(.type)) else {
                continue
            }
            
            for type in types {
                switch type {
                case .instance:
                    if let instance = try Bibframe.Instance(container: nestedContainer) {
                        if let responsibilityStatement = instance.responsibilityStatement {
                            contributors = Contributors(responsibilityStatement: responsibilityStatement)
                        }
                    }
                default:
                    if let identifier = try Bibframe.Identifier(container: nestedContainer) {
                        identifiers[identifier.type] = identifier.definition
                    }
                }
            }
        }
        
        self.identifiers = identifiers
        self.contributors = contributors
    }
}*/

extension Bibframe {
    enum CodingKeys: CodingKey {
        case rdf(RDF.Property)
        case bibframe(Bibframe.Property)
        
        var stringValue: String {
            switch self {
            case let .rdf(property):
                return property.stringValue
            case let .bibframe(property):
                return property.stringValue
            }
        }
        
        init?(stringValue: String) {
            if let property = RDF.Property(stringValue: stringValue) {
                self = .rdf(property)
            } else if let property = Bibframe.Property(stringValue: stringValue) {
                self = .bibframe(property)
            } else {
                return nil
            }
        }
        
        var intValue: Int? {
            switch self {
            case let .rdf(property):
                return property.intValue
            case let .bibframe(property):
                return property.intValue
            }
        }
        
        init?(intValue: Int) {
            if let property = RDF.Property(intValue: intValue) {
                self = .rdf(property)
            } else if let property = Bibframe.Property(intValue: intValue) {
                self = .bibframe(property)
            } else {
                return nil
            }
        }
    }
}

/*public struct Contributors {
    public let editors: String?
    public let translators: String?
    
    init() {
        self.editors = nil
        self.translators = nil
    }
    
    init(responsibilityStatement string: String) {
        let substrings = string.split(separator: ";")
        
        var translators: String?
        var editors: String?
        
        substrings.forEach {
            let trimmed = $0.trimmingCharacters(in: .whitespacesAndNewlines)
            let string = (trimmed.first?.lowercased() ?? "") + trimmed.dropFirst()
            
            if let range = string.range(of: "edited by") {
                let editor = string[range.upperBound...].trimmingCharacters(in: .whitespacesAndNewlines)
                editors = editor
            }
            
            if let range = string.range(of: "translated by") {
                let translator = string[range.upperBound...].trimmingCharacters(in: .whitespacesAndNewlines)
                translators = translator
                
            }
        }
        
        // TODO: Handle multiple contributors
        // TODO: Handle other languages
        // TODO: Split names into given and family
        // TODO: Test with more examples
        
        self.translators = translators
        self.editors = editors
    }
}*/
