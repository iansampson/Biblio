//
//  Agent.swift
//  
//
//  Created by Ian Sampson on 2021-11-19.
//

import LibraryOfCongress

struct Agent {
    let type: AgentType
    let identifiers: [Identifier]
    let name: Name
}

extension Agent {
    typealias AgentType = LibraryOfCongress.AgentType
    
    struct Identifier {
        let type: IdentifierType
        let value: String
    }
    
    enum IdentifierType {
        case orcid
        case lcnaf
    }
}
