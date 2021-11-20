//
//  Metadata.swift
//  
//
//  Created by Ian Sampson on 2021-11-19.
//

import Foundation

public struct Metadata {
    public let url: URL
    public internal(set) var isbns: [ISBN]
    public internal(set) var images: [Image]
    
    init(url: URL, map: MetadataParser.Map) {
        self.url = url
        isbns = map[.booksISBN].map(ISBN.init) + map[.bookISBN].map(ISBN.init) + map[.isbn].map(ISBN.init)
        // TODO: Abtstract this function into an initializer or property on Map
        // self.images = map.images
        self.images = []
    }
}
