//
//  RWOAgent.swift
//  
//
//  Created by Ian Sampson on 2021-11-14.
//

public enum RealWorldObject { }

extension RealWorldObject {
    public struct Agent: Decodable {
        let name: String
        // TODO: Consider using a property wrapper instead
        
        public init(from decoder: Decoder) throws {
            // TODO: Rename type to rootType
            let container = try JSONLD.Container(type: Bibframe.Class.person,
                                                 from: decoder)
            guard let name = try container.decode(String.self, forProperty: RDF.Property.label).first else {
                // TODO: Simplify error propagation
                throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath,
                                                        debugDescription: "",
                                                        underlyingError: nil))
            }
            self.name = name
        }
        
        enum CodingKeys: String, CodingKey {
            case name = "http://www.w3.org/2000/01/rdf-schema#label"
        }
    }
}
