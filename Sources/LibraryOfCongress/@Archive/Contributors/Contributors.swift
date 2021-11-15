//
//  Contributors.swift
//  
//
//  Created by Ian Sampson on 2021-11-13.
//

import NaturalLanguage

public struct Contributors {
    let responsibilityStatement: String
    let sections: [ContributorSection]
}

extension Contributors {
    init() {
        responsibilityStatement = ""
        sections = []
    }
}

extension Contributors {
    public func filter(byRole role: Contributor.Role) -> [Contributor] {
        // TODO: Merge duplicates
        sections.lazy
            .filter {
                $0.roles.contains(role)
            }
            .flatMap { section -> [Contributor] in
                section.agents.map { agent in
                    Contributor(agent: agent, roles: section.roles)
                }
            }
    }
}

extension Contributors {
    init(responsibilityStatement string: String) {
        var tokens = Contributors.tokenize(responsibilityStatement: string)[...]
        var sections: [ContributorSection] = []
        
        while let (remainingTokens, section) = ContributorSection.parse(tokens) {
            tokens = remainingTokens
            if section.agents.isEmpty || section.roles.isEmpty {
                continue
            }
            sections.append(section)
        }
        
        self.init(responsibilityStatement: string, sections: sections)
    }
}

extension Contributors {
    struct Token {
        let substring: Substring
        let tag: Tag
       
        enum Tag: Equatable {
            case personalName
            case semicolon
            case otherPunctuation
            case contributorRole(Contributor.Role)
            case other
        }
    }
    
    private static func tokenize(responsibilityStatement string: String) -> [Token] {
        // Configure tagger
        let tagger = NLTagger(tagSchemes: [.nameType])
        tagger.string = string
        
        var tokens: [Token] = []
        tagger.enumerateTags(in: string.startIndex..<string.endIndex,
                             unit: .word,
                             scheme: .nameType,
                             options: [.joinNames])
        { (tag, range) -> Bool in
            let substring = string[range]
            
            guard let tag = tag else {
                return true
            }
            
            let tokenTag: Token.Tag
            switch tag {
            case .personalName:
                tokenTag = .personalName
            case .punctuation:
                if string[range].first == ";" {
                    tokenTag = .semicolon
                } else {
                    tokenTag = .otherPunctuation
                }
            case .whitespace:
                return true
            default:
                if let role = Contributor.Role(word: substring) {
                    tokenTag = .contributorRole(role)
                } else {
                    tokenTag = .other
                }
            }
            
            let token = Token(substring: substring, tag: tokenTag)
            tokens.append(token)
            
            return true
        }
        
        return tokens
    }
}

// Christie V. McDonald doesn’t work
// How to fix that?
