//
//  Instance.swift
//  
//
//  Created by Ian Sampson on 2021-11-13.
//

import Foundation

public struct Instance: Decodable {
    public let identifiers: [Bibframe.IdentifierType: String]
    
    public init(from decoder: Decoder) throws {
        var identifiers: [Bibframe.IdentifierType: String] = [:]
        
        var container = try decoder.unkeyedContainer()
        
        while let nestedContainer = try? container.nestedContainer(keyedBy: RDF.Property.self) {
            guard let identifier = try Bibframe.Identifier(container: nestedContainer) else {
                continue
            }
            identifiers[identifier.type] = identifier.definition
        }
        
        self.identifiers = identifiers
    }
}
