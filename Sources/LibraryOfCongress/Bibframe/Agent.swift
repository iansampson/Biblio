//
//  Agent.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

import Foundation

public struct Agent {
    public let name: Name
    public let authority: URL?
}
// TODO: Specify type of agent
// TODO: Make authority optional

extension Agent {
    init?<L>(expanding agents: [L]?, in document: Document) throws where L: Linkable {
        guard let firstAgent = try document.expand(agents, into: LinkedData.Agent.self).first,
              let name = firstAgent.names.first?.value
        else {
            return nil
        }
        
        let authority = firstAgent.isIdentifiedByAuthorities?
            .first?.id.flatMap(URL.init(string:))
        
        self.name = Name(agentName: name)
        self.authority = authority
    }
}
