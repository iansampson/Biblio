//
//  Instance.swift
//  
//
//  Created by Ian Sampson on 2021-11-14.
//

import Foundation
// TODO: Avoid Foundation dependency if possible
// (only used for URL so far)

struct Instance {
    let identifiers: [IdentifierType: String]
    let work: URL?
    let responsibilityStatement: String?
}

extension Instance: Decodable {
    init(from decoder: Decoder) throws {
        let document = try Document(from: decoder)
        let instance = try document.decode(LinkedData.Instance.self,
                                       withTypeName: "http://id.loc.gov/ontologies/bibframe/Instance",
                                       idPrefix: "http://id.loc.gov/resources/instances")
        
        let identifiers: [(IdentifierType, String)] = try document.expand(instance.identifiers, into: Node.self)
            .compactMap {
                guard let value = $0.values?.first?.value?.trimmingCharacters(in: .whitespacesAndNewlines),
                      let identifierTypeRawValue = $0.types?.first,
                      let identifierType = IdentifierType(rawValue: identifierTypeRawValue)
                else {
                    return nil
                }
                return (identifierType, value)
            }
        self.identifiers = .init(uniqueKeysWithValues: identifiers)
        
        work = instance.works?.first?.id
            .flatMap(URL.init(string:))?
            .secure
        
        responsibilityStatement = instance.responsibilityStatements?.first?.value
    }
}
