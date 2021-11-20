//
//  Metadata.swift
//  
//
//  Created by Ian Sampson on 2021-11-20.
//

import Metadata

extension Instance {
    mutating func merge(_ metadata: Metadata) {
        // Assumes metadata matches the instance
        // TODO: Check IDs defensively
        // TODO: Filter or sort on tags
        // and consider adding only one image
        // TODO: Avoid copying if possible
        // and make this merge more efficient
        // (perhaps by storing images as a set
        // in the first place)
        images = Array(
            Set(images).union(metadata.images.map {
                Image(subject: .cover,
                      url: $0.url) }))
        
        // TODO: Normalize ISBNs
        identifiers = Array(
            Set(identifiers).union(metadata.isbns.map {
                Instance.Identifier(type: .isbn,
                                    value: $0.value) }))
    }
}
