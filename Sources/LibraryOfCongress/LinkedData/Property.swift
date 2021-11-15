//
//  Property.swift
//
//
//  Created by Ian Sampson on 2021-11-14.
//

struct Property: Decodable, Linkable {
    let id: String?
    let type: String?
    let value: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "@id"
        case type = "@type"
        case value = "@value"
    }
}
