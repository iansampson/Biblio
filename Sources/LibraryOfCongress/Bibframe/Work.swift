//
//  Work.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

import Foundation

struct Work {
    let contributions: [Contribution]
}

extension Work: Decodable {
    init(from decoder: Decoder) throws {
        let document = try Document(from: decoder)
        let work = try document.decode(LinkedData.Work.self,
                                       withTypeName: "http://id.loc.gov/ontologies/bibframe/Work",
                                       idPrefix: "http://id.loc.gov/resources/works")
        
        self.contributions = try document
            .expand(work.contributions, into: LinkedData.Contribution.self)
            .compactMap {
                guard let firstAgent = try document.expand($0.agents, into: LinkedData.Agent.self).first,
                      let name = firstAgent.names.first?.value,
                      let authority = firstAgent.isIdentifiedByAuthorities.first?.id.flatMap(URL.init(string:))
                else {
                    return nil
                }
                
                let roles = $0.roles.compactMap({ $0.id })
                    .compactMap(Relator.init(rawValue:))
                return Contribution(agent: .init(name: name, authority: authority),
                                    roles: roles)
            }
    }
}
