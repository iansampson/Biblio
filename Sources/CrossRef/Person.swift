//
//  Person.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

public struct Person: Codable {
    public let given: String?
    public let family: String?
    public let sequence: String?
    // TODO: Use an enum for sequence (first, etc.)
    // let affiliation
    // (an array, but of what?)
}

extension Person {
    // TODO: Rename this type to Name
    var name: String? {
        guard
            let given = given,
            let family = family
        else {
            return nil
        }
        // TODO: What about authors that have only one or the other?
        // TODO: Handle particles, etc.
        return given + " " + family
    }
}
