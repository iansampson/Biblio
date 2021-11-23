//
//  Instance.swift
//  
//
//  Created by Ian Sampson on 2021-11-14.
//

import Foundation
// TODO: Avoid Foundation dependency if possible
// (only used for URL so far)

public struct Instance {
    public let type: InstanceType
    // public let identifiers: [IdentifierType: String]
    public let identifiers: [Identifier]
    public let work: URL? // Does every instance have a work?
    public let title: Title? // Consider a more complex struct for title parts
    public let variantTitle: Title? // Or making them strings
    public let responsibilityStatement: String?
    public let provisionActivity: ProvisionActivity?
    public let issuance: Issuance?
    public let extent: Extent?
    public let carrier: Carrier?
}
// TODO: Remove more Optionals if possible

extension Instance: Decodable {
    public init(from decoder: Decoder) throws {
        let document = try Document(from: decoder)
        let instance = try document.decode(LinkedData.Instance.self,
                                       withTypeName: "http://id.loc.gov/ontologies/bibframe/Instance",
                                       idPrefix: "http://id.loc.gov/resources/instances")
        
        type = instance.types.compactMap(InstanceType.init(rawValue:))
            .filter { $0 != .instance }
            .first ?? .instance
        
        identifiers = try .init(expanding: instance.identifiers, in: document)
        
        work = instance.works?.first?.id
            .flatMap(URL.init(string:))?
            .appendingPathExtension("json")
            .secure
        
        // TODO: Abstract into Title initializer
        let titles = try document.expand(instance.titles, into: LinkedData.Title.self)
            .compactMap { title -> Title? in
                let type = title.type?.first.flatMap(TitleType.init(rawValue:)) ?? .regular
                guard let mainTitle = title.mainTitles?.first?.value else {
                    return nil
                }
                // or .subtitle
                return Title(type: type,
                             mainTitle: mainTitle,
                             subtitle: title.subtitles?.first?.value)
            }
            
        title = titles.first { $0.type == .regular }
        variantTitle = titles.first { $0.type == .variant }
        
        responsibilityStatement = instance.responsibilityStatements?.first?.value
        
        provisionActivity = try .init(expanding: instance.provisionActivity, in: document)
        
        issuance = try .init(expanding: instance.issuance, in: document)
        
        extent = try .init(expanding: instance.extent, in: document)
        
        carrier = try .init(expanding: instance.carrier, in: document)
    }
}
