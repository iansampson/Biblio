//
//  Node.swift
//
//
//  Created by Ian Sampson on 2021-11-14.
//

struct Node: Decodable {
    let id: String?
    let types: [String]?
    let values: [Value]?
    let labels: [Value]?
    
    enum CodingKeys: String, CodingKey {
        case id = "@id"
        case types = "@type"
        case values = "http://www.w3.org/1999/02/22-rdf-syntax-ns#value"
        case labels = "http://www.w3.org/2000/01/rdf-schema#label"
    }
}
