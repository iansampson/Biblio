//
//  Agent.swift
//  
//
//  Created by Ian Sampson on 2021-11-13.
//

/// Entity having a role in a resource, such as a person or organization.
/// - URI: http://id.loc.gov/ontologies/bibframe/Agent
public struct Agent {
    public let type: AgentType
    public let name: Name
    // TODO: Distinguish names of persons from names of organizations
}

public enum AgentType {
    case person
    case family
    case organization
    case jurisdiction
    case meeting
}
