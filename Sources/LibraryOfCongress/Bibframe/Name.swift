//
//  Name.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

// TODO: Consider renaming to ProperName or PersonalName
public struct Name {
    public let components: [String]
    // First section and second section
    // Not everyone has a first and last name
}

extension Name {
    init(agentName: String) {
        let components = agentName
            .split(separator: ",")
            .lazy
            .prefix(2)
            .reversed()
            .map(String.init)
            .map {
                $0.removingParantheticalClauses
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }
        self.components = Array(components)
        // TODO: Remove anything in parantheses
    }
}

extension StringProtocol where SubSequence == Substring {
    var removingParantheticalClauses: String {
        var remainingInput = self[...]
        var string = ""
        while let character = remainingInput.popFirst() {
            if let result = ParentheticalClause().parse(remainingInput) {
                remainingInput = result
            }
            string.append(character)
        }
        return string
    }
}

struct ParentheticalClause {
    func parse(_ input: Substring) -> Substring? {
        var remainingInput = input
        guard let characterA = remainingInput.popFirst(),
              characterA == "("
        else {
            return nil
        }
        
        while let characterB = remainingInput.popFirst() {
            if characterB == ")" {
                return remainingInput
            }
        }
        
        return nil
    }
}
