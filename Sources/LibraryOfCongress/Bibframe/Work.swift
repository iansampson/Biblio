//
//  Work.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

import Foundation

public struct Work {
    public let type: WorkType
    public let contributions: [Contribution]
    public let languages: [Language]
    public let genreForms: [GenreForm]
}

extension Work: Decodable {
    public init(from decoder: Decoder) throws {
        let document = try Document(from: decoder)
        let work = try document.decode(LinkedData.Work.self,
                                       withTypeName: "http://id.loc.gov/ontologies/bibframe/Work",
                                       idPrefix: "http://id.loc.gov/resources/works")
        type = work.types.compactMap(WorkType.init(rawValue:))
            .filter { $0 != .work }
            .first ?? .work
        
        // TODO: Abstract into its own initializer
        self.contributions = try document
            .expand(work.contributions, into: LinkedData.Contribution.self)
            .compactMap {
                guard let agent = try Agent(expanding: $0.agents, in: document) else {
                    return nil
                }
                
                let roles = $0.roles.compactMap({ $0.id })
                    .compactMap(Relator.init(rawValue:))
                return Contribution(agent: agent, roles: roles)
            }
        
        languages = .init(expanding: work.languages)
        
        genreForms = try .init(expanding: work.genreForms, in: document)
        
        
        // TODO: Expand using names
    }
}
