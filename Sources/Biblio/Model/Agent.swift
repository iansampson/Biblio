//
//  Agent.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

import LibraryOfCongress

struct Agent {
    let type: LibraryOfCongress.AgentType
    let identifiers: [Identifier]
    let name: LibraryOfCongress.Name
    let role: LibraryOfCongress.Relator
    
    struct Identifier {
        let type: IdentifierType
        let value: String
    }
    
    enum IdentifierType {
        case orcid
        case libraryOfCongressNameIdentifier
    }
}
