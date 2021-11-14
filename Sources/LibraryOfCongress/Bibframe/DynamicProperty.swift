//
//  DynamicProperty.swift
//  
//
//  Created by Ian Sampson on 2021-11-13.
//

struct DynamicProperty: Decodable {
    let id: String
    let type: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "@id"
        case type = "@type"
    }
}
