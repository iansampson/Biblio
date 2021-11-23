//
//  Metadata.swift
//  
//
//  Created by Ian Sampson on 2021-11-19.
//

import Foundation
import ISBN
import DOI

public struct Metadata {
    public let url: URL
    // public internal(set) var isbns: [_ISBN]
    public internal(set) var identifiers: [Identifier]
    // public internal(set) var dois: [ISBN]
    public internal(set) var images: [Image]
    
    public enum Identifier: Equatable {
        case isbn(ISBN)
        case doi(DOI)
    }
    
    // init(url: URL, map: MetadataParser.Map, identifiers: [Identifier]) {
    init(url: URL, map: MetadataParser.Map) {
        self.url = url
        identifiers = []
        // isbns = map[.booksISBN].map(_ISBN.init) + map[.bookISBN].map(_ISBN.init) + map[.isbn].map(_ISBN.init)
        // TODO: Abtstract this function into an initializer or property on Map
        // self.images = map.images
        self.images = []
    }
}
