//
//  Works.swift
//  
//
//  Created by Ian Sampson on 2021-11-19.
//

public struct Works: Codable {
    public let itemsPerPage: Int
    public let query: Query
    public let totalResults: Int
    public let nextCursor: String?
    public let items: [Work]?
}
