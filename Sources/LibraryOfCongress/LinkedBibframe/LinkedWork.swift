//
//  LinkedWork.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

extension LinkedData {
    struct Work: Decodable {
        let contributions: [Link]?
        // let languages: [Link]?
        
        enum CodingKeys: String, CodingKey {
            // case languages = "http://id.loc.gov/ontologies/bibframe/language"
            case contributions = "http://id.loc.gov/ontologies/bibframe/contribution"
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
        let names: [Property]
        let isIdentifiedByAuthorities: [Property]
        
        enum CodingKeys: String, CodingKey {
            case names = "http://www.w3.org/2000/01/rdf-schema#label"
            case isIdentifiedByAuthorities = "http://www.loc.gov/mads/rdf/v1#isIdentifiedByAuthority"
        }
    }
}
