//
//  BibframeInstance.swift
//  
//
//  Created by Ian Sampson on 2021-11-13.
//

import Foundation

extension Bibframe {
    public struct Instance {
        public let instanceOf: URL?
        public let responsibilityStatement: String?
        
        init?(container: KeyedDecodingContainer<Bibframe.CodingKeys>) throws {
            let types = try container.decode([Bibframe.Class].self, forKey: .rdf(.type))
            guard types.contains(.instance) else {
                return nil
            }
            
            responsibilityStatement = try container
                .decodeIfPresent(.value, forProperty: .responsibilityStatement)
            
            instanceOf = try container
                .decodeIfPresent(.value, forProperty: .instanceOf)
                .flatMap(URL.init(string:))
        }
    }
}

extension KeyedDecodingContainer where Key == Bibframe.CodingKeys {
    // _ type: RDF.Content.CodingKeys = .value, _
    func decodeIfPresent(_ type: RDF.Content.CodingKeys, forProperty property: Bibframe.Property) throws -> String? {
        let content = try decodeIfPresent([RDF.Content].self, forKey: .bibframe(property))?.first
        switch type {
        case .id:
            return content?.id
        case .value:
            return content?.value
        case .type:
            return content?.type
        }
    }
    
    func decodeMultiple(_ type: RDF.Content.CodingKeys, forProperty property: Bibframe.Property) throws -> [String] {
        try decodeIfPresent([RDF.Content].self, forKey: .bibframe(property))?
            .compactMap { content -> String? in
                switch type {
                case .id:
                    return content.id
                case .value:
                    return content.value
                case .type:
                    return content.type
                }
            } ?? []
    }
}
