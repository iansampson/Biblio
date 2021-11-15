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
        let provisionActivity: [Link]?
        
        enum CodingKeys: String, CodingKey {
            case identifiers = "http://id.loc.gov/ontologies/bibframe/identifiedBy"
            case works = "http://id.loc.gov/ontologies/bibframe/instanceOf"
            case responsibilityStatements = "http://id.loc.gov/ontologies/bibframe/responsibilityStatement"
            case provisionActivity = "http://id.loc.gov/ontologies/bibframe/provisionActivity"
        }
    }
    
    struct ProvisionActivity: Decodable {
        let places: [Link]?
        let agents: [Link]?
        let dates: [Value]?
        // TODO: Add ETDF scheme
        
        enum CodingKeys: String, CodingKey {
            case places = "http://id.loc.gov/ontologies/bibframe/place"
            case agents = "http://id.loc.gov/ontologies/bibframe/agent"
            case dates = "http://id.loc.gov/ontologies/bibframe/date"
        }
    }
}
