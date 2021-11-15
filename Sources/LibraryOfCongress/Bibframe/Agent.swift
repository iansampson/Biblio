//
//  Agent.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

import Foundation

struct Agent {
    let name: String
    let authority: URL
}

extension Agent {
    init?<L>(expanding agents: [L]?, in document: Document) throws where L: Linkable {
        guard let firstAgent = try document.expand(agents, into: LinkedData.Agent.self).first,
              let name = firstAgent.names.first?.value,
              let authority = firstAgent.isIdentifiedByAuthorities.first?.id.flatMap(URL.init(string:))
        else {
            return nil
        }
        
        self.name = name
        self.authority = authority
    }
}