//
//  ContributorSection.swift
//  
//
//  Created by Ian Sampson on 2021-11-14.
//

public struct ContributorSection {
    var roles: [Contributor.Role]
    var agents: [Agent]
    var etAlia: Bool
}

extension ContributorSection {
    static func parse(_ input: ArraySlice<Contributors.Token>) -> (ArraySlice<Contributors.Token>, ContributorSection)? {
        guard !input.isEmpty else {
            return nil
        }
        
        var remainingInput = input
        var contributorSection = ContributorSection(roles: [],
                                                    agents: [],
                                                    etAlia: false)
        var roles: Set<Contributor.Role> = []
        
        func appendAuthorIfNeeded() {
            if contributorSection.roles.isEmpty {
                contributorSection.roles.append(.author)
            }
        }
        
        while let token = remainingInput.first {
            switch token.tag {
            case .contributorRole(let role):
                if !roles.contains(role) {
                    roles.insert(role)
                    contributorSection.roles.append(role)
                }
                remainingInput = remainingInput.dropFirst()
                
            case .personalName:
                let agent = Agent(type: .person, name: .init(string: String(token.substring)))
                contributorSection.agents.append(agent)
                remainingInput = remainingInput.dropFirst()
                
            case .semicolon:
                appendAuthorIfNeeded()
                remainingInput = remainingInput.dropFirst()
                return (remainingInput, contributorSection)
                
            case .other:
                if let (nextInput, _) = EtAlia.parse(remainingInput) {
                    remainingInput = nextInput
                    contributorSection.etAlia = true
                } else {
                    remainingInput = remainingInput.dropFirst()
                }

            case .otherPunctuation:
                remainingInput = remainingInput.dropFirst()
            }
        }
        
        appendAuthorIfNeeded()
        return (remainingInput, contributorSection)
    }
}
