//
//  BibframeIdentifier.swift
//  
//
//  Created by Ian Sampson on 2021-11-13.
//

extension Bibframe {
    /*public enum DecodingError: Error {
        case failedToDecodeIdentifier(rawValue: String)
    }*/
    
    public struct Identifier {
        public let type: IdentifierType
        public let definition: String
    }
    
    public enum ShelfMarkType {
        case ddc
        case lcc
        case udc
        case nlm
    }
    
    public enum IdentifierType: String {
        case shelfMark
        case shelfMarkDdc
        case shelfMarkLcc
        case shelfMarkNlm
        case shelfMarkUdc
        case accessionNumber
        case ansi
        case audioIssueNumber
        case audioTake
        case barcode
        case coden
        case copyrightNumber
        case dissertationIdentifier
        case doi
        case ean
        case eidr
        case fingerprint
        case gtin14Number
        case hdl
        case isan
        case isbn
        case ismn
        case isni
        case iso
        case isrc
        case issn
        case issnL
        case istc
        case iswc
        case lcOverseasAcq
        case lccn
        case local
        case matrixNumber
        case musicDistributorNumber
        case musicPlate
        case musicPublisherNumber
        case nbn
        case postalRegistration
        case publisherNumber
        case reportNumber
        case sici
        case stockNumber
        case strn
        case studyNumber
        case upc
        case urn
        case videoRecordingNumber
    }
}

// TODO: Consider using literals to represent raw values
// (the way Bibframe.Class and Bibframe.Property do)
extension Bibframe.IdentifierType: Decodable {
    public init?(path: String) {
        let prefix = "http://id.loc.gov/ontologies/bibframe/"
        let string = path
        
        guard string.hasPrefix(prefix) else {
            return nil
        }
        
        let suffix = string[prefix.endIndex...]
        let lowercasedSuffix = suffix.first!.lowercased() + suffix.dropFirst()
        
        guard let identifier = Self.init(rawValue: lowercasedSuffix) else {
            return nil
        }
        
        self = identifier
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        guard let identifier = Self.init(path: string) else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath,
                                                    debugDescription: "\(string) is not a valid Bibframe identifier.",
                                                    underlyingError: nil))
        }
        
        self = identifier
    }
    
    init?(class: Bibframe.Class) {
        self.init(path: `class`.rawValue)
    }
}

extension Bibframe.Identifier {
    /// Decodes a Bibframe identifier definition from a keyed container encoded in JSON-LD
    static func decodeDefinition(container: KeyedDecodingContainer<Bibframe.CodingKeys>) throws -> String? {
        if let value = try container.decodeIfPresent([RDF.Content].self, forKey: .rdf(.value)) {
            return value.first?.value?
                .trimmingCharacters(in: .whitespacesAndNewlines)
        } else if let label = try container.decodeIfPresent([RDF.Content].self, forKey: .rdf(.label)) {
            return label.first?.value?
                .trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            return nil
        }
    }
    
    /// Decodes a Bibframe identifier from a keyed container encoded in JSON-LD
    init?(container: KeyedDecodingContainer<Bibframe.CodingKeys>) throws {
        let type = try container.decode([String].self, forKey: .rdf(.type))
            .compactMap { Bibframe.IdentifierType(path: $0) }
            .first
        
        guard let type = type,
              let definition = try Self.decodeDefinition(container: container)
        else {
            return nil
        }
        
        self.init(type: type, definition: definition)
    }
}
