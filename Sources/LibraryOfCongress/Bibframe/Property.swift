//
//  Instance.swift
//  
//
//  Created by Ian Sampson on 2021-11-13.
//

// TODO: Consider name-spacing inside a Bibframe enum

import Foundation

public enum PropertyType: Codable {
    case bibframe(Bibframe.Class)
    case bflc(BFLC.Class)
    case unknown
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let value = try container.decode(Bibframe.Class.self)
            self = .bibframe(value)
        } catch {
            do {
                let value = try container.decode(BFLC.Class.self)
                self = .bflc(value)
            } catch {
                self = .unknown
            }
        }
    }
}

public struct Property: Decodable {
    typealias Value = [Content]?
    
    public let id: String
    public let type: [PropertyType]
    
    // RDF
    let label: Value
    let value: Value
    
    let issuance: Value
    let provisionalActivity: Value
    let carrier: Value
    let media: Value
    let identifiedBy: Value
    let responsibilityStatement: Value
    let title: Value
    let provisionalActivityStatement: Value
    let extent: Value
    let note: Value
    let dimensions: Value
    let isPartOf: Value
    let instanceOf: Value
    let hasItem: Value
    let adminMetadata: Value
    
    let mainTitle: Value
    let subtitle: Value
    
    let identifiedByAuthority: Value
    let code: Value
    let date: Value
    let place: Value
    let generationDate: Value
    let aap: Value
    let assigner: Value
    let variantType: Value
    let shelfMark: Value
    let status: Value
    let encodingLevel: Value
    let descriptionConventions: Value
    let changeDate: Value
    let creationDate: Value
    let d906: Value
    let d955: Value
    let descriptionModifier: Value
    let descriptionAuthentication: Value
    
    enum CodingKeys: String, CodingKey {
        case id = "@id"
        case type = "@type"
        
        case label = "http://www.w3.org/2000/01/rdf-schema#label"
        case value = "http://www.w3.org/1999/02/22-rdf-syntax-ns#value"
        
        case issuance = "http://id.loc.gov/ontologies/bibframe/issuance"
        case provisionalActivity = "http://id.loc.gov/ontologies/bibframe/provisionActivity"
        case carrier = "http://id.loc.gov/ontologies/bibframe/carrier"
        case media = "http://id.loc.gov/ontologies/bibframe/media"
        case identifiedBy = "http://id.loc.gov/ontologies/bibframe/identifiedBy"
        case responsibilityStatement = "http://id.loc.gov/ontologies/bibframe/responsibilityStatement"
        case title = "http://id.loc.gov/ontologies/bibframe/title"
        case provisionalActivityStatement = "http://id.loc.gov/ontologies/bibframe/provisionActivityStatement"
        case extent = "http://id.loc.gov/ontologies/bibframe/extent"
        case note = "http://id.loc.gov/ontologies/bibframe/note"
        case dimensions = "http://id.loc.gov/ontologies/bibframe/dimensions"
        case isPartOf = "http://purl.org/dc/terms/isPartOf"
        case instanceOf = "http://id.loc.gov/ontologies/bibframe/instanceOf"
        case hasItem = "http://id.loc.gov/ontologies/bibframe/hasItem"
        case adminMetadata = "http://id.loc.gov/ontologies/bibframe/adminMetadata"
        
        case mainTitle = "http://id.loc.gov/ontologies/bibframe/mainTitle"
        case subtitle = "http://id.loc.gov/ontologies/bibframe/subtitle"
        
        case identifiedByAuthority = "http://www.loc.gov/mads/rdf/v1#isIdentifiedByAuthority"
        case code = "http://id.loc.gov/ontologies/bibframe/code"
        case date = "http://id.loc.gov/ontologies/bibframe/date"
        case place = "http://id.loc.gov/ontologies/bibframe/place"
        case generationDate = "http://id.loc.gov/ontologies/bibframe/generationDate"
        case aap = "http://id.loc.gov/ontologies/bflc/aap" // TODO: Find out what AAP is
        case assigner = "http://id.loc.gov/ontologies/bibframe/assigner"
        case variantType = "http://id.loc.gov/ontologies/bibframe/variantType"
        case shelfMark = "http://id.loc.gov/ontologies/bibframe/shelfMark"
        
        case status = "http://id.loc.gov/ontologies/bibframe/status"
        case encodingLevel = "http://id.loc.gov/ontologies/bflc/encodingLevel"
        case descriptionConventions = "http://id.loc.gov/ontologies/bibframe/descriptionConventions"
        case changeDate = "http://id.loc.gov/ontologies/bibframe/changeDate"
        case creationDate = "http://id.loc.gov/ontologies/bibframe/creationDate"
        case d906 = "http://id.loc.gov/ontologies/lclocal/d906"
        case d955 = "http://id.loc.gov/ontologies/lclocal/d955"
        case descriptionModifier = "http://id.loc.gov/ontologies/bibframe/descriptionModifier"
        case descriptionAuthentication = "http://id.loc.gov/ontologies/bibframe/descriptionAuthentication"
        
        // "http://id.loc.gov/ontologies/bibframe/" ??
    }
}

extension Property {
    public struct Content: Decodable {
        let type: String?
        let id: String?
        let value: String?
        
        enum CodingKeys: String, CodingKey {
            case type = "@type"
            case id = "@id"
            case value = "@value"
        }
    }
}

/*public struct Entry: Decodable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        container.decodeIfPresent(Property.self)
        
        // let property = try container.decode(Property.self)
        
        // print(property.type)
        
        // [Instance, Print]
        //
    }
}*/

/*public enum PropertyType: String, Decodable {
    case instance = "http://id.loc.gov/ontologies/bibframe/Instance"
    case print = "http://id.loc.gov/ontologies/bibframe/Print"
    case lccn = "http://id.loc.gov/ontologies/bibframe/Lccn"
    case parallelTitle = "http://id.loc.gov/ontologies/bibframe/ParallelTitle"
    case agent = "http://id.loc.gov/ontologies/bibframe/Agent"
    case place = "http://id.loc.gov/ontologies/bibframe/Place"
    case descriptiveConventions = "http://id.loc.gov/ontologies/bibframe/DescriptionConventions"
    case provisionActivity = "http://id.loc.gov/ontologies/bibframe/ProvisionActivity"
    case publication = "http://id.loc.gov/ontologies/bibframe/Publication"
    case descriptionAuthentication = "http://id.loc.gov/ontologies/bibframe/DescriptionAuthentication"
    case encodingLevel = "http://id.loc.gov/ontologies/bflc/EncodingLevel"
    case generationProcess = "http://id.loc.gov/ontologies/bibframe/GenerationProcess"
    case title = "http://id.loc.gov/ontologies/bibframe/Title"
    case media = "http://id.loc.gov/ontologies/bibframe/Media"
    case carrier = "http://id.loc.gov/ontologies/bibframe/Carrier"
    case work = "http://id.loc.gov/ontologies/bibframe/Work"
    case local = "http://id.loc.gov/ontologies/bibframe/Local"
    case variantTitle = "http://id.loc.gov/ontologies/bibframe/VariantTitle"
    case issuance = "http://id.loc.gov/ontologies/bibframe/Issuance"
    case assigner = "http://id.loc.gov/ontologies/bibframe/assigner"
    case item = "http://id.loc.gov/ontologies/bibframe/Item"
    case isbn = "http://id.loc.gov/ontologies/bibframe/Isbn"
    case shelfMarkLLC = "http://id.loc.gov/ontologies/bibframe/ShelfMarkLcc"
    case adminMetadata = "http://id.loc.gov/ontologies/bibframe/AdminMetadata"
    case status = "http://id.loc.gov/ontologies/bibframe/Status"
    case note = "http://id.loc.gov/ontologies/bibframe/Note"
    case extent = "http://id.loc.gov/ontologies/bibframe/Extent"
}*/
