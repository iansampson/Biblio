//
//  GoogleBooks.swift
//  
//
//  Created by Ian Sampson on 2021-11-20.
//

import GoogleBooks
import LibraryOfCongress

extension Instance {
    mutating func merge(_ volume: GoogleVolume) {
        /*let identifiers: [Instance.Identifier] = volume.volumeInfo.industryIdentifiers?.compactMap {
            guard let type = IdentifierType($0.type) else {
                return nil
            }
            return Instance.Identifier(type: type, value: $0.identifier)
        } ?? []*/
        
        // TODO: Normalize ISBNs and other identifiers
        /*if Set(identifiers).intersection(self.identifiers).isEmpty {
            return
        }*/
        
        if let url = volume.volumeInfo.imageLinks?.uncurled.thumbnail?.secure {
            let image = Image(subject: .cover, url: url)
            if !images.contains(image) {
                images.append(image)
            }
        }
    }
}

extension IdentifierType {
    init?(_ identifierType: GoogleVolume.IdentifierType) {
        switch identifierType {
        case .isbn10, .isbn13:
            self = .isbn
        case .issn:
            self = .issn
        case .other:
            return nil
            // TODO: Consider allowing .unknown as a value
        }
    }
}
