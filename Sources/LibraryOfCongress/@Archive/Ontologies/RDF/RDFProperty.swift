//
//  RDFProperty.swift
//  
//
//  Created by Ian Sampson on 2021-11-13.
//

// TODO: Consider renaming to JSONLD
public enum RDF {
    public enum Property: String, CodingKey {
        case id = "@id"
        case type = "@type"
        case label = "http://www.w3.org/2000/01/rdf-schema#label"
        case value = "http://www.w3.org/1999/02/22-rdf-syntax-ns#value"
    }
    
    public struct Content: Decodable {
        let id: String?
        let type: String?
        let value: String?
        
        public enum CodingKeys: String, CodingKey {
            case id = "@id"
            case type = "@type"
            case value = "@value"
        }
    }
}
