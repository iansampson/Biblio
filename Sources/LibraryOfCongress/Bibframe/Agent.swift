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
    public let identifier: URL?
    // Identifier in the Library of Congress Name Authority File
}

extension Agent {
    init?<L>(expanding agents: [L]?, in document: Document) throws where L: Linkable {
        guard let firstAgent = try document.expand(agents, into: LinkedData.Agent.self).first,
              let name = firstAgent.names.first?.value
        else {
            return nil
        }
        
        let identifier = firstAgent.isIdentifiedByAuthorities?
            .first?.id.flatMap(URL.init(string:))
        
        self.type = firstAgent.types
            .compactMap(AgentType.init(rawValue:))
            .filter { $0 != .agent }
            .first ?? .agent
        
        self.name = Name(agentName: name)
        self.identifier = identifier
    }
}
