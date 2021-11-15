//
//  Issuance.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

enum Issuance: String {
    case serial = "http://id.loc.gov/vocabulary/issuance/serl"
    case integrating = "http://id.loc.gov/vocabulary/issuance/intg"
    case monograph = "http://id.loc.gov/vocabulary/issuance/mono"
    case multivolumeMonograph = "http://id.loc.gov/vocabulary/issuance/mulm"
}

extension Issuance {
    // TODO: Consider making a protocol for types that can be initialized with a sequence of links
    init?(expanding links: [Link]?, in document: Document) throws {
        let issuance = links?
            .lazy
            .compactMap { $0.id }
            .compactMap(Issuance.init(rawValue:))
            .first
        
        /*let issuance = try document.expand(links, into: Node.self)
            .lazy
            .compactMap { $0.labels?.first?.value }
            .compactMap(Issuance.init(rawValue:))
            .first*/
        
        guard let issuance = issuance else {
            return nil
        }
        
        self = issuance
    }
}
