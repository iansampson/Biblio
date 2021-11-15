//
//  DecodableInstance.swift
//  
//
//  Created by Ian Sampson on 2021-11-14.
//

extension LinkedData {
    struct Instance: Decodable {
        let types: [String]
        let identifiers: [Link]?
        let works: [Link]? // isInstanceOf
        let titles: [Link]?
        let responsibilityStatements: [Value]?
        let provisionActivity: [Link]?
        let issuance: [Link]?
        let extent: [Link]?
        let carrier: [Link]?
        
        enum CodingKeys: String, CodingKey {
            case types = "@type"
            case identifiers = "http://id.loc.gov/ontologies/bibframe/identifiedBy"
            case works = "http://id.loc.gov/ontologies/bibframe/instanceOf"
            case titles = "http://id.loc.gov/ontologies/bibframe/title"
            case responsibilityStatements = "http://id.loc.gov/ontologies/bibframe/responsibilityStatement"
            case provisionActivity = "http://id.loc.gov/ontologies/bibframe/provisionActivity"
            case issuance = "http://id.loc.gov/ontologies/bibframe/issuance"
            case extent = "http://id.loc.gov/ontologies/bibframe/extent"
            case carrier = "http://id.loc.gov/ontologies/bibframe/carrier"
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
    
    struct Title: Decodable {
        let type: [String]?
        let labels: [Value]?
        let mainTitles: [Value]?
        let subtitles: [Value]?
        
        enum CodingKeys: String, CodingKey {
            case type = "@type"
            case labels = "http://www.w3.org/2000/01/rdf-schema#label"
            case mainTitles = "http://id.loc.gov/ontologies/bibframe/mainTitle"
            case subtitles = "http://id.loc.gov/ontologies/bibframe/subtitle"
        }
    }
}
