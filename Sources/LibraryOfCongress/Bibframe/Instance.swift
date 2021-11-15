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
    let title: Title? // Consider a more complex struct for title parts
    let variantTitle: Title? // Or making them strings
    let responsibilityStatement: String?
    let provisionActivity: ProvisionActivity?
}
// TODO: Remove more Optionals if possible

extension Instance: Decodable {
    init(from decoder: Decoder) throws {
        let document = try Document(from: decoder)
        let instance = try document.decode(LinkedData.Instance.self,
                                       withTypeName: "http://id.loc.gov/ontologies/bibframe/Instance",
                                       idPrefix: "http://id.loc.gov/resources/instances")
        
        identifiers = try .init(expanding: instance.identifiers, in: document)
        
        work = instance.works?.first?.id
            .flatMap(URL.init(string:))?
            .secure
        
        // TODO: Abstract into Title initializer
        let titles = try document.expand(instance.titles, into: LinkedData.Title.self)
            .compactMap { title -> Title? in
                let type = title.type?.first.flatMap(TitleType.init(rawValue:)) ?? .regular
                guard let value = title.mainTitles?.first?.value else {
                    return nil
                }
                // or .subtitle
                return Title(type: type, value: value)
            }
            
        title = titles.first { $0.type == .regular }
        variantTitle = titles.first { $0.type == .variant }
        
        responsibilityStatement = instance.responsibilityStatements?.first?.value
        
        provisionActivity = try .init(expanding: instance.provisionActivity, in: document)
    }
}
