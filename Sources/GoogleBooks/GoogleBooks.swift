//
//  GoogleBooks.swift
//  GoogleBooks
//
//  Created by Ian Sampson on 2021-08-13.
//

import Foundation

public final class GoogleBooks {
    let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    private static let volumes = "https://www.googleapis.com/books/v1/volumes"
    
    public func search(for query: String, field: Field? = nil) async throws -> GoogleBooksResult {
        // Construct URL
        var components = URLComponents(string: GoogleBooks.volumes)!
        
        let text: String
        if let field = field {
            text = "\(field.rawValue): \(query)"
        } else {
            text = query
        }
        
        components.queryItems = [
            URLQueryItem(name: "q", value: text)
        ]
        let url = components.url!
        
        // Request data
        let (data, _) = try await urlSession.data(from: url)
        
        // Decode data
        let decoder = JSONDecoder()
        return try decoder.decode(GoogleBooksResult.self, from: data)
    }
    
    public enum Field: String {
        case inTitle = "intitle"
        case inAuthor = "inauthor"
        case inPublisher = "inpublisher"
        case subject
        case isbn
        case lccn
        case oclc
    }
}


// MARK: - Models

public struct GoogleBooksResult: Codable {
    public let items: [GoogleVolume]
}

public struct GoogleVolume: Codable {
    public struct Info: Codable {
        public let title: String?
        public let subtitle: String?
        public let authors: [String]?
        public let publisher: String?
        public let publishedDate: String? // convert to Date
        public let description: String?
        public let industryIdentifiers: [Identifier]?
        public let imageLinks: ImageLinks?
        public let language: String? // enum
    }
    
    public struct ImageLinks: Codable {
        public let smallThumbnail: URL?
        public let thumbnail: URL?
    }
    
    public struct Identifier: Codable {
        public let type: IdentifierType // make this an enum
        public let identifier: String // actually a number
    }
    
    // TODO: Add more identifiers before using this enum
    // for Identifier.type
    public enum IdentifierType: String, Codable {
        case isbn10 = "ISBN_10"
        case isbn13 = "ISBN_13"
        case issn = "ISSN"
        case other = "OTHER"
    }
    
    //let kind: String
    public let id: String
    public let volumeInfo: Info
}

extension GoogleVolume.ImageLinks {
    private static let pageCurl = "edge"
    
    private func removePageCurl(in url: URL) -> URL {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let uncurled = components.removingQueryItem(GoogleVolume.ImageLinks.pageCurl).url
        else { return url } // or nil?
        return uncurled
    }
    
    public var uncurled: GoogleVolume.ImageLinks {
        GoogleVolume.ImageLinks(smallThumbnail: smallThumbnail.map { removePageCurl(in: $0) },
                                thumbnail: thumbnail.map { removePageCurl(in: $0) })
    }
}

// MARK: - Extensions

private extension URLComponents {
    private func indexForQueryItem(_ name: String) -> Int? {
        guard let queryItems = self.queryItems
            else { return nil }
        
        for (index, item) in queryItems.enumerated() {
            if item.name == name { return index }
        }
        return nil
    }
    
    mutating func removeQueryItem(_ name: String) {
        if let index = indexForQueryItem(name) {
            queryItems?.remove(at: index)
        }
    }
    
    func removingQueryItem(_ name: String) -> URLComponents {
        var components = self
        components.removeQueryItem(name)
        return components
    }
}
