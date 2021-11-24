//
//  Identifier.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

public struct Identifier {
    public let type: IdentifierType
    public let value: String
    public let qualifier: String?
}

extension Array where Element == Identifier {
    init(expanding identifiers: [Link]?, in document: Document) throws {
        self = try document.expand(identifiers, into: LinkedData.Identifier.self)
            .compactMap {
                guard let value = $0.values?.first?.value?.trimmingCharacters(in: .whitespacesAndNewlines),
                      let identifierTypeRawValue = $0.types?.first,
                      let identifierType = IdentifierType(rawValue: identifierTypeRawValue),
                      let qualifier = $0.values?.compactMap({ $0.value }).first
                        // TODO: Test for multiple qualifiers
                else {
                    return nil
                }
                
                return Identifier(type: identifierType,
                                  value: value,
                                  qualifier: qualifier)
            }
    }
}

/*extension Dictionary where Key == IdentifierType, Value == String {
    init(expanding identifiers: [Link]?, in document: Document) throws {
        let identifiers: [(IdentifierType, String)] = try document.expand(identifiers, into: LinkedData.Identifier.self)
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
}*/
