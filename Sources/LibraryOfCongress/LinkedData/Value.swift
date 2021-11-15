//
//  Value.swift
//  
//
//  Created by Ian Sampson on 2021-11-14.
//

struct Value: Decodable {
    let value: String?
    
    enum CodingKeys: String, CodingKey {
        case value = "@value"
    }
}
