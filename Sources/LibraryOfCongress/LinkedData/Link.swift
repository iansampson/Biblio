//
//  Link.swift
//  
//
//  Created by Ian Sampson on 2021-11-14.
//

struct Link: Decodable, Linkable {
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "@id"
    }
}
