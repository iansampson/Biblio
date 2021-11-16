//
//  Date.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

import Foundation

// TODO: Consider nesting inside Item or CrossRef to avoid conflicts
public struct DateParts: Codable {
    public let dateParts: [[Int]]? // Or [Int]?
    public let dateTime: Date? // e.g. 2019-04-25T06:53:17Z
    public let timestamp: Int?
}
