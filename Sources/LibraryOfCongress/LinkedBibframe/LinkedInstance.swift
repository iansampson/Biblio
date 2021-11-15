//
//  DecodableInstance.swift
//  
//
//  Created by Ian Sampson on 2021-11-14.
//

extension LinkedData {
    struct Instance: Decodable {
        let identifiers: [Link]?
        let works: [Link]? // isInstanceOf
        let responsibilityStatements: [Value]?
        
        enum CodingKeys: String, CodingKey {
            case identifiers = "http://id.loc.gov/ontologies/bibframe/identifiedBy"
            case works = "http://id.loc.gov/ontologies/bibframe/instanceOf"
            case responsibilityStatements = "http://id.loc.gov/ontologies/bibframe/responsibilityStatement"
        }
    }
}
