//
//  LinkedWork.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

extension LinkedData {
    struct Work: Decodable {
        let types: [String]
        let contributions: [Link]?
        let languages: [Link]?
        
        enum CodingKeys: String, CodingKey {
            case types = "@type"
            case contributions = "http://id.loc.gov/ontologies/bibframe/contribution"
            case languages = "http://id.loc.gov/ontologies/bibframe/language"
        }
    }
    
    struct Contribution: Decodable {
        let agents: [Property]
        let roles: [Property]
        
        enum CodingKeys: String, CodingKey {
            case agents = "http://id.loc.gov/ontologies/bibframe/agent"
            case roles = "http://id.loc.gov/ontologies/bibframe/role"
        }
    }
    
    struct Agent: Decodable {
        let types: [String]
        let names: [Property]
        let isIdentifiedByAuthorities: [Property]?
        // TODO: Consider making one or both of these properties optional
        
        enum CodingKeys: String, CodingKey {
            case types = "@type"
            case names = "http://www.w3.org/2000/01/rdf-schema#label"
            case isIdentifiedByAuthorities = "http://www.loc.gov/mads/rdf/v1#isIdentifiedByAuthority"
        }
    }
}
