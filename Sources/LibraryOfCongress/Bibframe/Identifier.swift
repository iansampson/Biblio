//
//  Identifier.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

extension Dictionary where Key == IdentifierType, Value == String {
    init(expanding identifiers: [Link]?, in document: Document) throws {
        let identifiers: [(IdentifierType, String)] = try document.expand(identifiers, into: Node.self)
            .compactMap {
                guard let value = $0.values?.first?.value?.trimmingCharacters(in: .whitespacesAndNewlines),
                      let identifierTypeRawValue = $0.types?.first,
                      let identifierType = IdentifierType(rawValue: identifierTypeRawValue)
                else {
                    return nil
                }
                return (identifierType, value)
            }
        self.init(uniqueKeysWithValues: identifiers)
    }
}
