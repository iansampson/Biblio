//
//  Instance.swift
//  
//
//  Created by Ian Sampson on 2021-11-14.
//

struct Instance: Decodable {
    let identifiers: [IdentifierType: String]
    let responsibilityStatement: String?
    
    init(from decoder: Decoder) throws {
        let document = try Document(from: decoder)
        let work = try document.decode(LinkedData.Instance.self,
                                       withTypeName: "http://id.loc.gov/ontologies/bibframe/Instance",
                                       idPrefix: "http://id.loc.gov/resources/instances")
        
        let identifiers: [(IdentifierType, String)] = try document.expand(work.identifiers, into: Node.self)
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
        
        responsibilityStatement = work.responsibilityStatements?.first?.value
    }
}
