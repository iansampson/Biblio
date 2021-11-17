//
//  Link.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

import Foundation

// TODO: Consider nesting inside Item or CrossRef to avoid conflicts
public struct Link: Codable {
    public let url: URL
    public let contentType: String // TODO: Consider using an enum here
    public let contentVersion: String
    public let intendedApplication: String
}
