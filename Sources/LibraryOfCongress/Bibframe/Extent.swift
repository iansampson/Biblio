//
//  Extent.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

public struct Extent {
    public let string: String
    // TODO: Parse extent statement
}

extension Extent {
    init?(expanding links: [Link]?, in document: Document) throws {
        let string = try document.expand(links, into: Node.self)
            .lazy
            .compactMap { $0.labels?.first?.value }
            .first
        if let string = string {
            self.string = string
        } else {
            return nil
        }
    }
}
