//
//  LibraryOfCongress.swift
//  
//
//  Created by Ian Sampson on 2021-11-19.
//

import LibraryOfCongress
import OpenGL

extension Agent {
    init(_ agent: LibraryOfCongress.Agent) {
        identifiers = agent.identifier.map {
            [Identifier(type: .lcnaf, value: $0.absoluteString)]
        } ?? []
        type = agent.type
        name = .init(components: agent.name.components)
    }
}

extension Provision {
    init(_ provision: LibraryOfCongress.ProvisionActivity) {
        type = .published // TODO: Parse Bibframe provision type
        agent = provision.agent.map(Agent.init)
        date = provision.date.flatMap(Int.init).flatMap {
            .init(day: nil, month: nil, season: nil, year: $0)
        }
        place = provision.place
    }
}

extension Instance {
    init(instance: LibraryOfCongress.Instance, work: LibraryOfCongress.Work) {
        identifiers = instance.identifiers.map {
            .init(type: $0.type, value: $0.value)
        }
        
        contributors = work.contributions.map {
            .init(agent: .init($0.agent), roles: $0.roles)
        }
        
        provisions = instance.provisionActivity
            .map(Provision.init)
            .map { [$0] } ?? []
        
        title = instance.title.map {
            .init(primaryTitle: $0.value,
                      subtitle: instance.variantTitle?.value,
                      abbreviatedTitle: nil)
        }
        
        languages = work.languages
        
        container = nil
        // TODO: Parse Bibframe isPartOf
    }
}
