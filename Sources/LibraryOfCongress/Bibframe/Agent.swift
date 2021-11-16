//
//  Agent.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

import Foundation

public struct Agent {
    public let type: AgentType
    public let name: Name
    public let authority: URL?
}

extension Agent {
    init?<L>(expanding agents: [L]?, in document: Document) throws where L: Linkable {
        guard let firstAgent = try document.expand(agents, into: LinkedData.Agent.self).first,
              let name = firstAgent.names.first?.value
        else {
            return nil
        }
        
        let authority = firstAgent.isIdentifiedByAuthorities?
            .first?.id.flatMap(URL.init(string:))
        
        self.type = firstAgent.types
            .compactMap(AgentType.init(rawValue:))
            .filter { $0 != .agent }
            .first ?? .agent
        
        self.name = Name(agentName: name)
        self.authority = authority
    }
}
