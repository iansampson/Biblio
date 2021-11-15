//
//  BibframeWork.swift
//  
//
//  Created by Ian Sampson on 2021-11-14.
//

/*import Foundation

extension Bibframe {
    public struct Work: Decodable {
        public let contributions: [Contribution]
        
        public struct Contribution: Decodable {
            let agent: JSONLD.Identifiable<URL> // JSONLD.Identifiable<URL>
            let roles: [JSONLD.Identifier<LinkedDataService.Relator>]
            
            enum CodingKeys: String, CodingKey {
                case agent = "http://id.loc.gov/ontologies/bibframe/agent"
                case roles = "http://id.loc.gov/ontologies/bibframe/role"
            }
        }
        
        public init(from decoder: Decoder) throws {
            let container = try JSONLD.Container(type: Bibframe.Class.work,
                                                 from: decoder)
            contributions = try container.decode(Contribution.self,
                                                 forProperty: Bibframe.Property.contribution)
            // TODO: Use [Contribution].self
            
            
            
            
            /*var container = try decoder.unkeyedContainer()
            var workContainer: KeyedDecodingContainer<Bibframe.CodingKeys>?
            var propertyContainers: [String: KeyedDecodingContainer<Bibframe.CodingKeys>] = [:]
            
            while let propertyContainer = try? container.nestedContainer(keyedBy: Bibframe.CodingKeys.self) {
                if let types = try? propertyContainer.decode([BibframeOrBFLCClass].self,
                                                             forKey: .rdf(.type)),
                   types.contains(.bibframe(.work))
                {
                    workContainer = propertyContainer
                } else {
                    let id = try propertyContainer.decode(String.self, forKey: .rdf(.id))
                    propertyContainers[id] = propertyContainer
                }
            }
            
            guard let workContainer = workContainer else {
                throw DecodingError.valueNotFound(Work.self, .init(codingPath: decoder.codingPath,
                                                                   debugDescription: "Data does not contain a valid Work",
                                                                   underlyingError: nil))
            }*/
            
            // TODO: How to handle multiple contributions?
            // TODO: Abstract this section into an extension or another struct
            // (e.g. as an initializer on Contribution)
            /*contributions = try workContainer.decodeMultiple(.id, forProperty: .contribution).compactMap { id in
                guard let container = propertyContainers[id],
                      let types = try? container.decode([BibframeOrBFLCClass].self, forKey: .rdf(.type)),
                      types.contains(.bibframe(.contribution)) // Or .primaryContribution
                else {
                    return nil
                }
                
                if let agentID = try container.decodeIfPresent(.id, forProperty: .agent),
                   let agentURL = URL(string: agentID),
                   let roleID = try container.decodeIfPresent(.id, forProperty: .role),
                   let roleRelator = LinkedDataService.Relator(rawValue: roleID)
                {
                    return Contribution(agent: agentURL, role: roleRelator)
                }
                
                return nil
            }*/
        }
        
        /*init?(container: KeyedDecodingContainer<Bibframe.CodingKeys>) throws {
         let types = try container.decode([Bibframe.Class].self, forKey: .rdf(.type))
         guard types.contains(.work) else {
         return nil
         }
         
         /*responsibilityStatement = try container
          .decodeIfPresent(.responsibilityStatement)
          
          instanceOf = try container
          .decodeIfPresent(.instanceOf)
          .flatMap(URL.init(string:))*/
         }*/
    }
}

public enum BibframeOrBFLCClass: Equatable {
    case bibframe(Bibframe.Class)
    case bflc(BFLC.Class)
}

extension BibframeOrBFLCClass: Decodable {
    public init(from decoder: Decoder) throws {
        do {
            self = .bibframe(try Bibframe.Class(from: decoder))
        } catch {
            self = .bflc(try BFLC.Class(from: decoder))
        }
    }
}

extension Bibframe.CodingKeys: JSONLDCodingKey {
    static var jsonLDID: Bibframe.CodingKeys {
        .rdf(.id)
    }
    
    static var jsonLDType: Bibframe.CodingKeys {
        .rdf(.type)
    }
}*/
