//
//  DecodableInstance.swift
//  
//
//  Created by Ian Sampson on 2021-11-14.
//

extension LinkedData {
    struct Instance: Decodable {
        let identifiers: [Link]?
        let responsibilityStatements: [Value]?
        
        enum CodingKeys: String, CodingKey {
            case identifiers = "http://id.loc.gov/ontologies/bibframe/identifiedBy"
            case responsibilityStatements = "http://id.loc.gov/ontologies/bibframe/responsibilityStatement"
        }
    }
}
