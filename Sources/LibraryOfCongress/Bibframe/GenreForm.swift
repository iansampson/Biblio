//
//  GenreForm.swift
//  
//
//  Created by Ian Sampson on 2021-11-16.
//

import Foundation

public struct GenreForm {
    public let id: URL
    public let label: String
}

extension Array where Element == GenreForm {
    init(expanding links: [Link]?, in document: Document) throws {
        self = try document.expand(links, into: Node.self).compactMap {
            guard let id = $0.id,
                  let url = URL(string: id),
                  let label = $0.labels?.first?.value
            else {
                return nil
            }
            return GenreForm(id: url, label: label)
        }
    }
}
